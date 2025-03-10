// ignore_for_file: depend_on_referenced_packages, void_checks

import 'dart:async';
import 'dart:ffi';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:optional/optional.dart';
import 'package:sports_management/di/injection.dart';
import 'package:sports_management/domain/credentialModel.dart';
import 'package:sports_management/pages/login/login_service.dart';
import 'package:sports_management/services/cacheService.dart';
import 'package:sports_management/services/http/api_services.dart';
import 'package:sports_management/services/http/result.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sports_management/services/token_service.dart';

import '../../utils/utils.dart';
import 'login_event.dart';
import 'package:encrypt/encrypt.dart' as crypt;


part 'login_state.dart';

@injectable
class LoginScreenBloc extends Bloc<LoginEvent, LoginState> {
  LoginScreenBloc(this._loginService) : super(const LoginInitialState()) {
    on<LoginEvent>((event, emitter) async {
      switch (event.runtimeType) {
        case InitEvent:
          clearStreams();
          emitter(const LoginInitialState());
          break;
        case LoginTryEvent:
          await _onLoginTryEvent(emitter);
          break;
      }
    });
  }

  final _logger = Logger();
  final LoginService _loginService;
  String userEmail = "";
  bool biometric = false;
  String typeDniSelected = "V";
  bool expired = false;
  bool useEmail = false;
  final Cache _cache = Cache();

  List<String> typeDocs = ["V", "E", "J", "P"];
  final _userNameController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Stream<String> get userNameStream => _userNameController.stream;

  Stream<String> get passwordStream => _passwordController.stream;

  void clearStreams() {
    updateUserName('');
    updatePassword('');
  }

  setBiometric(bool value) {
    biometric = value;
  }

  setValidation(bool value) {
    useEmail = value;
  }

  void setTypeDoc(String? type) {
    typeDniSelected = type ?? typeDocs[0];
  }

  Future<void> _onLoginTryEvent(Emitter<LoginState> emitter) async {
    emitter(const LoginLoadingState());

    var result = await _login();

    var errorMessage = Optional.ofNullable(result.msg)
        .map((p0) => p0.message)
        .orElse(result.errorMessage ?? "Error al loguearse");

    if (result.success) {
      if (errorMessage == "AUTHORIZATION_EMAIL_SENDED") {
        emitter(GoToAuthDeviceState(userEmail, _passwordController.value));
      } else {
        var res = await _loginService.getRole();
        if (res.success) {
            crypt.Key key = crypt.Key.fromBase64(MyUtils.cryptoKey());
            crypt.IV iv = crypt.IV.fromBase64(MyUtils.cryptoIV());
            final encrypter = crypt.Encrypter(crypt.AES(key));
            final encryptedEmail = encrypter.encrypt(userEmail, iv: iv);
            final encryptedPassword =
                encrypter.encrypt(_passwordController.value, iv: iv);
          await _cache.saveLastCredentials(CredentialModel(
            email: encryptedEmail.base64,
            password: encryptedPassword.base64));
          await _loginService.saveProfile();
          emitter(const LoginSuccessState());
        } else {
          await getIt<TokenService>()
              .token()
              .then((value) => value.obj)
              .then((value) => getIt<ApiServices>().closeSession(value!));
          var errorMessage = res.errorMessage ?? "Error al loguearse";
          _logger.i(errorMessage);
          emitter(LoginErrorState(errorMessage: errorMessage));
        }
      }
    } else {
      if (errorMessage == "AUTHORIZATION_EMAIL_SENDED") {
        emitter(GoToAuthDeviceState(userEmail, _passwordController.value));
      } else {
        var errorMessage = result.errorMessage ?? "Error al loguearse";
        emitter(LoginErrorState(errorMessage: errorMessage));
      }
    }
  }

  void clear() {
    _userNameController.value = "";
    _passwordController.value = "";
  }

  void updateUserName(String value) {
    var result = _validateUserName(value);
    if (result != null) {
      _userNameController.sink.addError(result);
    } else {
      userEmail = value;
      _userNameController.sink.add(value);
    }
  }

  bool getExpired() {
    return expired;
  }

  void updatePassword(String value) {
    var result = _validatePassword(value);
    if (result != null) {
      _passwordController.sink.addError(result);
    } else {
      _passwordController.sink.add(value);
    }
  }

  String? _validateUserName(String? value) {
    if (value == null || value == "") {
      return "El usuario no puede estar vacío";
    }

    if (!biometric) {
      if (useEmail) {
        if (!MyUtils.REX_EMAIL.hasMatch(value)) {
          return "Ingresa un email válido";
        }
      } else {
        if (!MyUtils.REX_CI.hasMatch(value) && !MyUtils.isNumeric(value)) {
          return "Ingresa un número de documento válido";
        }
        if (value.length < 4) {
          return "Longitud de número inválida";
        }
      }
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value == "") {
      return "La contraseña no puede estar vacía";
    }

    return null;
  }

  Stream<bool> get validateForm => Rx.combineLatest2(
        userNameStream.map((event) => _validateUserName(event) == null),
        passwordStream.map((event) => _validatePassword(event) == null),
        (
          a,
          b,
        ) =>
            a && b,
      );

  Future<Result<Void>> _login() async {
    String parsedEmail = _userNameController.value;
    if (!biometric) {
      if (!useEmail) {
        if (MyUtils.REX_CI.hasMatch(parsedEmail)) {
          parsedEmail = "$typeDniSelected${parsedEmail.substring(1)}";
        } else {
          parsedEmail = "$typeDniSelected${parsedEmail.padLeft(9, "0")}";
        }
        updateUserName(parsedEmail);
      }
    }
    bool isCI = MyUtils.REX_CI.hasMatch(parsedEmail);
    var retries = 0;
    return RetryWhenStream(
        () => Rx.combineLatest2(userNameStream, passwordStream,
                (userName, password) {
              return _loginService
                  .passwordGrant(userName, password, isCI)
                  .asStream()
                  .timeout(const Duration(seconds: 90));
            }).flatMap((value) => value), (error, stackTrace) {
      retries += 1;
      if (retries < 5) {
        return Stream.value("");
      } else {
        return Stream.error(error, stackTrace);
      }
    }).first.onError(Result.fail);
  }
  
}

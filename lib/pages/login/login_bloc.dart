// ignore_for_file: depend_on_referenced_packages, void_checks

import 'dart:async';
import 'dart:ffi';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:optional/optional.dart';
import 'package:geap_fit/pages/login/login_service.dart';
import 'package:geap_fit/services/http/result.dart';
import 'package:rxdart/rxdart.dart';
import '../../utils/utils.dart';
import 'login_event.dart';

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

  final LoginService _loginService;
  String userEmail = "";
  String typeDniSelected = "V";
  bool expired = false;
  bool useEmail = false;

  List<String> typeDocs = ["V", "E", "J", "P"];
  final _userNameController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Stream<String> get userNameStream => _userNameController.stream;

  Stream<String> get passwordStream => _passwordController.stream;

  void clearStreams() {
    updateUserName('');
    updatePassword('');
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
        emitter(GoToAuthDeviceState(userEmail, _passwordController.value));
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
    if (!MyUtils.REX_EMAIL.hasMatch(value)) {
      return "Ingresa un email válido";
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
    if (MyUtils.REX_CI.hasMatch(parsedEmail)) {
      parsedEmail = parsedEmail.substring(1);
    }
    updateUserName(parsedEmail);          
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

// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sports_management/domain/credentialModel.dart';
import 'package:sports_management/services/cacheService.dart';
import 'package:sports_management/styles/theme_holder.dart';
import 'package:sports_management/utils/get_credentials.dart';
import 'package:sports_management/utils/utils.dart';
import 'package:sports_management/widgets/alert_dialog.dart';
import 'package:encrypt/encrypt.dart' as crypt;

import '../../di/injection.dart';
import '../../styles/bg.dart';
import '../../styles/text.dart';
import '../../utils/staticNamesRoutes.dart';
import 'login_bloc.dart';
import 'login_event.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:local_auth/local_auth.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _logger = Logger();

    late final LocalAuthentication auth;
  bool isSupported = false;
  bool keepInCache = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController ciController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool useEmail = true;
  late Color _primaryColor;

  var obscure = true;
  final Cache _cache = Cache();

  @override
  void initState() {
    _init();
    _logger.i("init");
    _primaryColor = getIt<ThemeHolder>().colorProvider().primary();
    verifyData();
    super.initState();
  }

  void _init() {
    _bloc().setValidation(false);
    _bloc().add(const InitEvent());
  }

  Future<String> check() async {
    var cache = getIt<Cache>();
    var token = await cache.getAccessTokenResponse();
    var profile = await cache.getProfile();
    var third =
        profile == null ? false : await cache.isDeviceAuthorized(profile.id!);

    return "is device auth $third token ${token?.idToken})";
  }

  Future<void> checkDeviceModel() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    _cache.saveDeviceModel(androidInfo.model);
  }

  void verifyData() async {
    String? keepData = await cache.getKeepLastSession();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((value) => setState(() {
          isSupported = value;
        }));
    if (keepData == null) {
      setState(() {
        keepInCache == false;
      });
    } else {
      setState(() {
        keepInCache = keepData.replaceAll('"', '') == "MANTENER" ? true : false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    checkDeviceModel();
    return WillPopScope(
        onWillPop: () async {
          final value = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                actions: <Widget>[
                  TextButton(
                      child: const Text("SÍ"),
                      onPressed: () => SystemNavigator.pop()),
                  TextButton(
                      child: const Text("NO"),
                      onPressed: () => Navigator.of(context).pop())
                ],
                title: const Text(
                  "¿Seguro que deseas salir de la aplicación?",
                  style: TitleTextStyle(fontSize: 22),
                ),
              );
            },
          );
          if (value != null) {
            return Future.value(value);
          } else {
            return Future.value(false);
          }
        },
        child: Scaffold(
            //resizeToAvoidBottomInset: false,
            body: SafeArea(
                child: Center(
                    child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: _formWidget()),
        )))));
  }

  void showToast(BuildContext context, String data) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data)));
  }

  Widget _formWidget() {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlocConsumer<LoginScreenBloc, LoginState>(
                  bloc: _bloc(),
                  listener: (context, state) {
                    _logger.i("state_listener $state");
                    if (state is LoginSuccessState) {
                      _goNext();
                    }
                    if (state is LoginErrorState) {
                      _showError(state.errorMessage);
                    }
                    if (state is GoToAuthDeviceState) {
                      print("TAMBIEN LLEGa pa");
                      _goToAuthDevice(state.userEmail, state.userPassword);
                    }
                  },
                  builder: (context, state) {
                    _logger.i("state_builder $state");
                    var isLoggingIn = state is LoginLoadingState ||
                        state is LoginSuccessState;
                    dynamic render;
                    render = logWithEmail(isLoggingIn);

                    return StatefulBuilder(builder: (context, newState) {
                      return Column(
                        children: [
                          const SizedBox(height: 15),
                          _userAndPass(isLoggingIn, render),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                  flex: isLoggingIn ? 1 : 7,
                                  child: _loginButton(isLoggingIn)),
                              isSupported && keepInCache
                                  ? Flexible(
                                      flex: isLoggingIn ? 0 : 2,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: !isLoggingIn
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color:
                                                      _primaryColor,
                                                ),
                                                child: IconButton(
                                                    onPressed: () {
                                                      !isLoggingIn
                                                          ? biometricAuth()
                                                          : null;
                                                    },
                                                    icon: const SizedBox(
                                                      height: 45,
                                                      width: 50,
                                                      child: Icon(
                                                        Icons.fingerprint,
                                                        size: 40,
                                                        color: Colors.white,
                                                      ),
                                                    )),
                                              )
                                            : const SizedBox(),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _recoverButton(),
                              ],
                            ),
                          ),
                        ],
                      );
                    });
                  }),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // _registerButton(),
            ],
          ),
        )
      ],
    );
  }

  Future<void> biometricAuth() async {
    try {
      bool authenticated = await auth.authenticate(
          localizedReason: 'Mantener huella en el lector para la autenticación',
          options: const AuthenticationOptions(
              useErrorDialogs: true, biometricOnly: true, stickyAuth: true));
      if (authenticated) {
        CredentialModel? credentials = await cache.getLastCredentials();
        if (credentials != null) {
          crypt.Key key = crypt.Key.fromBase64(MyUtils.cryptoKey());
          crypt.IV iv = crypt.IV.fromBase64(MyUtils.cryptoIV());
          final encrypter = crypt.Encrypter(crypt.AES(key));
          final decryptedEmail = encrypter
              .decrypt(crypt.Encrypted.from64(credentials.email), iv: iv);
          final decryptedPassword = encrypter
              .decrypt(crypt.Encrypted.from64(credentials.password), iv: iv);

          _bloc().updateUserName(decryptedEmail);
          _bloc().updatePassword(decryptedPassword);
          _loginBtnTap();
        } else {
          _logger.e("Error de autenticación");
          _showError("No se pudo realizar el proceso de autenticación");
          _bloc().clear();
        }
      } else {
        _logger.e("Error de autenticación");
        _bloc().clear();
        _showError("No se pudo realizar el proceso de autenticación");
      }
    } catch (e) {
      _bloc().clear();
      _logger.e(e);
      _showError("Error de lectura, intente de nuevo o reinicie la aplicación");
    }
  }

  _typeDocument(bool isLoading) {
    return SizedBox(
      height: 60,
      child: DropdownButtonFormField<String>(
        enableFeedback: isLoading,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: isLoading
                        ? const Color.fromARGB(206, 207, 207, 207)
                        : _primaryColor,
                    width: isLoading ? 1 : 2))),
        icon: const Icon(Icons.arrow_downward),
        value: _bloc().typeDniSelected,
        style: const TextStyle(color: Colors.deepPurple, fontFamily: "Kalinga"),
        isExpanded: true,
        onChanged: isLoading ? null : (type) => _bloc().setTypeDoc(type),
        items: _bloc().typeDocs.map<DropdownMenuItem<String>>((String type) {
          return DropdownMenuItem<String>(
              value: type,
              child: Center(
                child: Text(type,
                    style: const TitleTextStyle(color: ColorUtil.dark_gray)),
              ));
        }).toList(),
      ),
    );
  }

  LoginScreenBloc _bloc() {
    return context.read<LoginScreenBloc>();
  }

  Widget _recoverButton() {
    return InkWell(
      onTap: () =>
          context.push(StaticNames.emailFormName.path, extra: "RECOVER"),          
      child: Text(
        "Recuperar contraseña",
        style: TextStyle(
            fontSize: 16,
            color: _primaryColor,
            decoration: TextDecoration.underline),
      ),
    );
  }

  Widget _registerButton() {
    return TextButton(
      onPressed: () => context.go(StaticNames.registerName.path),
      child: const Text(
        "ABRIR UNA NUEVA CUENTA",
        style: TextStyle(
            fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
      ),
    );
  }

  Widget _userAndPass(bool isLoggingIn, Widget render) {
    return AutofillGroup(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 10,
        ),
        logWithEmail(isLoggingIn),
        const SizedBox(height: 10),
        StreamBuilder(
            stream: _bloc().passwordStream,
            builder: (context, snapshot) {
              return TextFormField(
                autofillHints: const [AutofillHints.password],
                keyboardType: TextInputType.text,
                maxLength: 20,
                readOnly: false,
                controller: passwordController,
                onChanged: (text) => _bloc().updatePassword(text),
                enabled: !isLoggingIn,
                validator: (value) => snapshot.error?.toString(),
                obscureText: obscure,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline_sharp),
                    suffixIcon: IconButton(
                        icon: Icon(
                            obscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() {
                              obscure = !obscure;
                            })),
                    labelText: "Contraseña",
                    border: const OutlineInputBorder()),
              );
            }),
      ],
    ));
  }

  Widget _loginButton(bool isLoggingIn) {
    return StreamBuilder(
        stream: _bloc().validateForm,
        builder: (context, snapshot) {
          return Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                  child: MediaQuery.of(context).size.height <= 432
                      ? Visibility(
                          child: _textButtonMini(
                              (snapshot.data ?? false), isLoggingIn),
                        )
                      : _textButton((snapshot.data ?? false), isLoggingIn),
                ),
              )
            ],
          );
        });
  }

  SizedBox logWithEmail(bool isLoggingIn) {
    return SizedBox(
      height: 80,
      child: StreamBuilder(
          stream: _bloc().userNameStream,
          builder: (context, snapshot) {
            return TextFormField(
              enableInteractiveSelection: false,
              autofillHints: const [AutofillHints.email],
              keyboardType: TextInputType.emailAddress,
              maxLength: 40,
              controller: emailController,
              readOnly: false,
              onChanged: (text) => _bloc().updateUserName(text),
              enabled: !isLoggingIn,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => snapshot.error?.toString(),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Correo electrónico",
                  border: OutlineInputBorder(),
                  hintText: ''),
            );
          }),
    );
  }

  Widget _textButton(bool formIsValid, bool isLoggingIn) {
    bool validateInput =
        useEmail ? emailController.text != "" : ciController.text != "";
    return TextButton(
        style: TextButton.styleFrom(
            backgroundColor:
                formIsValid && validateInput && passwordController.text != ""
                    ? _primaryColor
                    : Colors.grey,
            padding: const EdgeInsets.all(20)),
        onPressed: () {
          formIsValid && !isLoggingIn ? _pressLoginButton() : null;
        },
        child: _textOrProgress(isLoggingIn));
  }

  Widget _textButtonMini(bool formIsValid, bool isLoggingIn) {
    return TextButton(
        style: TextButton.styleFrom(
            backgroundColor: formIsValid ? _primaryColor : Colors.grey,
            padding: const EdgeInsets.all(10)),
        onPressed: formIsValid && !isLoggingIn ? _loginBtnTap : null,
        child: _textOrProgress(isLoggingIn));
  }

  void _pressLoginButton() {
    _loginBtnTap();
  }

  Widget _textOrProgress(bool isLoggingIn) {
    if (isLoggingIn) {
      return const CircularProgressIndicator(
        color: ColorUtil.white,
      );
    }

    return Text("INICIAR SESIÓN",
        selectionColor: ColorUtil.gray, style: subtitleStyleText("white", 15));
  }

  void _loginBtnTap() async {
    //var data = await check();
    //showToast(context, data);

    _bloc().add(const LoginTryEvent());
  }

  void _showError(String errorMsg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Alerts.error(errorMsg, () => Navigator.pop(context));
      },
    );
  }

  void _goNext() {
    // _sessionTimer.startTimer();flutter pub add flutter_blue_plus
    context.go(StaticNames.salesName.path);
  }

  void _goToAuthDevice(String userEmail, String userPassword) {
    context.go(StaticNames.salesName.path,
        extra: CredentialModel(email: userEmail, password: userPassword));
  }
}

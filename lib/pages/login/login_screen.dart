// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:geap_fit/domain/credentialModel.dart';
import 'package:geap_fit/services/cacheService.dart';
import 'package:geap_fit/styles/theme_holder.dart';
import 'package:geap_fit/utils/utils.dart';
import 'package:geap_fit/widgets/alert_dialog.dart';
import 'package:encrypt/encrypt.dart' as crypt;

import '../../di/injection.dart';
import '../../styles/bg.dart';
import '../../styles/text.dart';
import '../../utils/staticNamesRoutes.dart';
import 'login_bloc.dart';
import 'login_event.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _logger = Logger();
  final Cache cache = Cache();

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

    return "token ${token?.idToken})";
  }

  Future<void> checkDeviceModel() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    _cache.saveDeviceModel(androidInfo.model);
  }

  void verifyData() async {
    String? keepData = await cache.getKeepLastSession();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
      (value) => setState(() {
        isSupported = value;
      }),
    );
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
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: _formWidget(),
          ),
        ),
      ),
    );
  }

  void showToast(BuildContext context, String data) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data)));
  }

  Widget _formWidget() {
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
                    _goToAuthDevice(state.userEmail, state.userPassword);
                  }
                },
                builder: (context, state) {
                  _logger.i("state_builder $state");
                  var isLoggingIn =
                      state is LoginLoadingState || state is LoginSuccessState;
                  dynamic render;
                  render = logWithEmail(isLoggingIn);
                  return StatefulBuilder(
                    builder: (context, newState) {
                      return Column(
                        children: [
                          const Image(
                            image: AssetImage("assets/icons/icon_white.png"),
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "Inicia sesión",
                            style: titleStyleText("black", 15),
                          ),
                          _userAndPass(isLoggingIn, render),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: isLoggingIn ? 1 : 7,
                                child: _loginButton(isLoggingIn),
                              ),
                              // isSupported && keepInCache
                              //     ? Flexible(
                              //         flex: isLoggingIn ? 0 : 2,
                              //         child: Padding(
                              //           padding:
                              //               const EdgeInsets.only(top: 15.0),
                              //           child: !isLoggingIn
                              //               ? Container(
                              //                   decoration: BoxDecoration(
                              //                     borderRadius:
                              //                         BorderRadius.circular(10),
                              //                     color:
                              //                         _primaryColor,
                              //                   ),
                              //                   child: IconButton(
                              //                       onPressed: () {
                              //                         !isLoggingIn
                              //                             ? biometricAuth()
                              //                             : null;
                              //                       },
                              //                       icon: const SizedBox(
                              //                         height: 45,
                              //                         width: 50,
                              //                         child: Icon(
                              //                           Icons.fingerprint,
                              //                           size: 40,
                              //                           color: Colors.white,
                              //                         ),
                              //                       )),
                              //                 )
                              //               : const SizedBox(),
                              //         ),
                              //       )
                              //     : const SizedBox(),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("¿No recuerdas tu contraseña?\n"),
                                _recoverButton(),
                                const Divider(color: ColorUtil.dark_gray),
                                _registerButton(),
                                const Image(
                                  image: AssetImage(
                                    "assets/icons/exercise.png",
                                  ),
                                  width: 250,
                                  height: 250,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> biometricAuth() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Mantener huella en el lector para la autenticación',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      if (authenticated) {
        CredentialModel? credentials = await cache.getLastCredentials();
        if (credentials != null) {
          crypt.Key key = crypt.Key.fromBase64(MyUtils.cryptoKey());
          crypt.IV iv = crypt.IV.fromBase64(MyUtils.cryptoIV());
          final encrypter = crypt.Encrypter(crypt.AES(key));
          final decryptedEmail = encrypter.decrypt(
            crypt.Encrypted.from64(credentials.email),
            iv: iv,
          );
          final decryptedPassword = encrypter.decrypt(
            crypt.Encrypted.from64(credentials.password),
            iv: iv,
          );

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

  LoginScreenBloc _bloc() {
    return context.read<LoginScreenBloc>();
  }

  Widget _recoverButton() {
    return InkWell(
      onTap:
          () => context.push(StaticNames.emailFormName.path, extra: "RECOVER"),
      child: Text(
        "Recuperar contraseña",
        style: TextStyle(
          fontSize: 16,
          color: _primaryColor,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _userAndPass(bool isLoggingIn, Widget render) {
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          logWithEmail(isLoggingIn),
          const SizedBox(height: 10),
          StreamBuilder(
            stream: _bloc().passwordStream,
            builder: (context, snapshot) {
              return TextFormField(
                autofillHints: const [AutofillHints.password],
                keyboardType: TextInputType.text,
                readOnly: false,
                controller: passwordController,
                onChanged: (text) => _bloc().updatePassword(text),
                enabled: !isLoggingIn,
                validator: (value) => snapshot.error?.toString(),
                obscureText: obscure,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed:
                        () => setState(() {
                          obscure = !obscure;
                        }),
                  ),
                  hintText: 'Contraseña',
                ),
              );
            },
          ),
        ],
      ),
    );
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
                child: _textButton((snapshot.data ?? false), isLoggingIn),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _registerButton() {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: _primaryColor,
        padding: const EdgeInsets.all(10),
      ),
      onPressed: () {
        // _pressLoginButton();
      },
      child: Text(
        "Regístrate",
        selectionColor: ColorUtil.gray,
        style: subtitleStyleText("white", 15),
      ),
    );
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
            controller: emailController,
            readOnly: false,
            onChanged: (text) => _bloc().updateUserName(text),
            enabled: !isLoggingIn,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => snapshot.error?.toString(),
            decoration: const InputDecoration(hintText: 'Correo electrónico'),
          );
        },
      ),
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
                : Colors.blueGrey,
        padding: const EdgeInsets.all(10),
      ),
      onPressed: () {
        formIsValid && !isLoggingIn ? _pressLoginButton() : null;
      },
      child: _textOrProgress(isLoggingIn),
    );
  }

  void _pressLoginButton() {
    _loginBtnTap();
  }

  Widget _textOrProgress(bool isLoggingIn) {
    if (isLoggingIn) {
      return const CircularProgressIndicator(color: ColorUtil.white);
    }
    return Text(
      "Iniciar sesión",
      selectionColor: ColorUtil.gray,
      style: subtitleStyleText("white", 15),
    );
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
    context.go(StaticNames.clients.path);
  }

  void _goToAuthDevice(String userEmail, String userPassword) {
    context.go(
      StaticNames.clients.path,
      extra: CredentialModel(email: userEmail, password: userPassword),
    );
  }
}

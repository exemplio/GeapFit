// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geap_fit/pages/login/styles/inputs.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:geap_fit/pages/login/models/credential_model.dart';
import 'package:geap_fit/services/cacheService.dart';
import 'package:geap_fit/utils/utils.dart';
import 'package:geap_fit/widgets/alert_dialog.dart';
import 'package:encrypt/encrypt.dart' as crypt;

import '../../di/injection.dart';
import '../../styles/bg.dart';
import '../../utils/staticNamesRoutes.dart';
import 'login_bloc.dart';
import 'login_event.dart';
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
  bool _rememberMe = false;
  late final LocalAuthentication auth;
  bool isSupported = false;
  bool keepInCache = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController ciController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool useEmail = true;

  var obscure = true;
  final Cache _cache = Cache();

  @override
  void initState() {
    _init();
    _logger.i("init");
    // _primaryColor = getIt<ThemeHolder>().colorProvider().primary();
    verifyData();
    super.initState();
  }

  void _init() {
    _bloc().setValidation(false);
    _bloc().add(const InitEvent());
  }

  Future<String> check() async {
    var cache = getIt<Cache>();
    var token = await cache.getLastCredentials();

    return "token ${token?.email})";
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

  Widget _buildEmailTF(isLoggingIn, color) {
    return StreamBuilder(
      stream: _bloc().userNameStream,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Email', style: kLabelStyle()),
            const SizedBox(height: 10.0),
            Container(
              alignment: Alignment.centerLeft,
              height: 60.0,
              child: TextFormField(
                enableInteractiveSelection: false,
                autofillHints: const [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                readOnly: false,
                onChanged: (text) => _bloc().updateUserName(text),
                enabled: !isLoggingIn,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => snapshot.error?.toString(),
                style: TextStyle(color: color, fontFamily: 'OpenSans'),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(top: 14.0),
                  prefixIcon: const Icon(Icons.email),
                  hintText: 'Ingresa tu email',
                  hintStyle: kHintTextStyle(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPasswordTF(isLoggingIn, color) {
    return StreamBuilder(
      stream: _bloc().passwordStream,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Password', style: kLabelStyle()),
            const SizedBox(height: 10.0),
            Container(
              alignment: Alignment.centerLeft,
              height: 60.0,
              child: TextFormField(
                autofillHints: const [AutofillHints.password],
                keyboardType: TextInputType.text,
                readOnly: false,
                controller: passwordController,
                onChanged: (text) => _bloc().updatePassword(text),
                enabled: !isLoggingIn,
                validator: (value) => snapshot.error?.toString(),
                obscureText: obscure,
                style: TextStyle(color: color, fontFamily: 'OpenSans'),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(top: 14.0),
                  prefixIcon: const Icon(Icons.lock),
                  hintText: 'Ingresa tu contraseña',
                  hintStyle: kHintTextStyle(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buidlUserAndPass(bool isLoggingIn, Color color) {
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildEmailTF(isLoggingIn, color),
          const SizedBox(height: 30.0),
          _buildPasswordTF(isLoggingIn, color),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed:
            () =>
                context.push(StaticNames.emailFormName.path, extra: "RECOVER"),
        child: Text('¿Olvidaste tu contraseña?', style: kLabelStyle()),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return SizedBox(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value!;
                });
              },
            ),
          ),
          Text('Recuérdame', style: kLabelStyle()),
        ],
      ),
    );
  }

  Widget _textOrProgress(bool isLoggingIn) {
    if (isLoggingIn) {
      return const CircularProgressIndicator(color: ColorUtil.white);
    }
    return const Text(
      'INICIAR SESIÓN',
      style: TextStyle(
        letterSpacing: 1.5,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans',
      ),
    );
  }

  Widget _loginButton(bool formIsValid, bool isLoggingIn, Color color) {
    bool validateInput =
        useEmail ? emailController.text != "" : ciController.text != "";
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              formIsValid && validateInput && passwordController.text != ""
                  ? color
                  : Colors.grey, // Set the background color
        ),
        onPressed: () {
          formIsValid && !isLoggingIn ? _pressLoginButton() : null;
        },
        child: _textOrProgress(isLoggingIn),
      ),
    );
  }

  Widget _buildLoginBtn(bool isLoggingIn, bool isDarkMode, Color color) {
    return StreamBuilder(
      stream: _bloc().validateForm,
      builder: (context, snapshot) {
        return Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                child: _loginButton(
                  (snapshot.data ?? false),
                  isLoggingIn,
                  color,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        const Text('- O -', style: TextStyle(fontWeight: FontWeight.w400)),
        const SizedBox(height: 20.0),
        Text('Iniciar sesión con', style: kLabelStyle()),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: () => print("PRUEBA"),
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(image: logo),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => print('Login with Google'),
            const AssetImage('assets/icons/google.jpg'),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn(color) {
    return GestureDetector(
      onTap: () => print('Sign Up Button Pressed'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '¿No tienes una cuenta? ',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
            TextSpan(
              text: 'Regístrate',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    checkDeviceModel();
    final bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    Color color = isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
                            state is LoginLoadingState ||
                            state is LoginSuccessState;
                        // dynamic render;
                        // render = _buildEmailTF(isLoggingIn);
                        return StatefulBuilder(
                          builder: (context, newState) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40.0,
                                vertical: 60.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text(
                                    'Iniciar sesión',
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 30.0),
                                  _buidlUserAndPass(isLoggingIn, color),
                                  _buildForgotPasswordBtn(),
                                  _buildRememberMeCheckbox(),
                                  _buildLoginBtn(
                                    isLoggingIn,
                                    isDarkMode,
                                    color,
                                  ),
                                  _buildSignInWithText(),
                                  _buildSocialBtnRow(),
                                  _buildSignupBtn(color),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showToast(BuildContext context, String data) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data)));
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
            crypt.Encrypted.from64(credentials.email ?? ""),
            iv: iv,
          );
          final decryptedPassword = encrypter.decrypt(
            crypt.Encrypted.from64(credentials.password ?? ""),
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

  void _showError(String errorMsg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Alerts.error(errorMsg, () => Navigator.pop(context));
      },
    );
  }

  void _pressLoginButton() {
    _loginBtnTap();
  }

  void _loginBtnTap() async {
    //var data = await check();
    //showToast(context, data);

    _bloc().add(const LoginTryEvent());
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

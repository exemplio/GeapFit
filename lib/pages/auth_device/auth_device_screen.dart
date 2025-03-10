import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:sports_management/pages/auth_device/auth_device_bloc.dart';
import 'package:sports_management/styles/bg.dart';
import 'package:sports_management/styles/text.dart';

import '../../di/injection.dart';
import '../../services/session_timer.dart';
import '../../styles/theme_provider.dart';
import '../../utils/staticNamesRoutes.dart';
import '../../widgets/alert_dialog.dart';
import 'auth_device_event.dart';

class AuthDeviceScreen extends StatefulWidget {
  final AuthDeviceBloc bloc;
  String userEmail;
  String userPassword;
  
  AuthDeviceScreen(
      {super.key,
      required this.bloc,
      required this.userEmail,
      required this.userPassword});

  @override
  State<AuthDeviceScreen> createState() => _AuthDeviceScreenState();
}

class _AuthDeviceScreenState extends State<AuthDeviceScreen> {
  final _sessionTimer = SessionTimer();
  final _colorProvider = getIt<ThemeProvider>().colorProvider();

  AuthDeviceBloc _bloc() {
    return widget.bloc;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc().clear();
    });
    _bloc().setData(widget.userEmail, widget.userPassword);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthDeviceBloc, AuthDeviceState>(
      bloc: _bloc(),
      listener: (context, state) {
        if (state is AuthDeviceErrorState) {
          _showError(state.errorMessage);
        }

        if (state is CodeSentErrorState) {
          _showError(state.errorMessage);
        }

        if (state is AuthDeviceSuccessState) {
          _sessionTimer.startTimer();
          context.go(StaticNames.salesName.path);
        }
      },
      builder: (context, state) {
        var isLoading = state is AuthDeviceLoadingState;

        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image(
                        //   image: AssetImage("assets/img/Logo-PinPagos-04.png"),
                        //   width: 200,
                        //   height: 200,
                        // )
                      ],
                    ),
                    const SizedBox(height: 50),
                    Text("Verificación del código",
                        textAlign: TextAlign.start,
                        style: subtitleStyleText("", 35)),
                    const SizedBox(height: 10),
                    Center(
                        child: Text(
                            "Le enviamos un código por correo electrónico, por favor ingréselo a continuación",
                            textAlign: TextAlign.start,
                            style: titleStyleText("", 16))),
                    const SizedBox(height: 30),
                    isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: _colorProvider.primary(),
                            ))
                        : OtpTextField(
                            clearText: true,
                            enabled: !isLoading,
                            numberOfFields: 6,
                            focusedBorderColor: _colorProvider.primary(),
                            borderColor: _colorProvider.primary(),
                            showFieldAsBox: true,
                            onSubmit: (value) =>
                                _bloc().add(AuthDeviceTryEvent(value)),
                          ),
                    const SizedBox(height: 10),
                    const Text(
                      "Ingrese el código recibido por correo electrónico",
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: _colorProvider.primary(),
                                    padding: const EdgeInsets.all(20)),
                                onPressed: isLoading ? null : _sendCode,
                                child: _textOrProgress(isLoading)))
                      ],
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                        onTap: isLoading
                            ? null
                            : () => context.go(StaticNames.loginName.path),
                        child: Text("¿Correo incorrecto? Regresar",
                            style: subtitleStyleText("", 16)))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _textOrProgress(bool isLoading) {
    if (isLoading) {
      return const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: ColorUtil.white,
          ));
    }

    return Text("Reenviar código", style: titleStyleText("white", 16));
  }

  void _sendCode() {
    _bloc().add(ResendCodeEvent());
  }

  void _showError(String errorMsg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Alerts.error(errorMsg, () => Navigator.pop(context));
      },
    );
  }
}

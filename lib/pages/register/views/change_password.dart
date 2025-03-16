// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:geap_fit/di/injection.dart';
import 'package:geap_fit/services/http/api_services.dart';
import 'package:geap_fit/services/http/result.dart';
import 'package:geap_fit/styles/bg.dart';
import 'package:geap_fit/styles/text.dart';
import 'package:geap_fit/styles/theme_provider.dart';
import 'package:geap_fit/utils/encrypt_password.dart';
import 'package:geap_fit/utils/staticNamesRoutes.dart';
import 'package:geap_fit/utils/utils.dart';
import 'package:geap_fit/widgets/alert_dialog.dart';

class ChangePassword extends StatefulWidget {
  String email;
  ChangePassword({required this.email, super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _colorProvider = getIt<ThemeProvider>().colorProvider();
  final _formKey = GlobalKey<FormState>();
  final ApiServices _apiServices = getIt<ApiServices>();
  bool loading = false;
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
  var obscure1 = true;
  var obscure2 = true;
  var obscure3 = true;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const PopScope(
        canPop: false,
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(),
                ),
                SizedBox(height: 10),
                Text("Cargando"),
              ],
            ),
          ),
        ),
      );
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        context.goNamed(StaticNames.loginName.name);
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Image(
                  image: AssetImage("assets/icons/icon_white.png"),
                  width: 180,
                  height: 180,
                ),
                Text(
                  "CONTRASEÑA EXPIRADA",
                  textAlign: TextAlign.center,
                  style: TitleTextStyle(
                    fontSize: 18,
                    color: _colorProvider.primaryLight(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(
                          0,
                          4,
                        ), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 50,
                            left: 20,
                            right: 20,
                            bottom: 30,
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5.0,
                                ),
                                child: SizedBox(
                                  height: 79,
                                  child: TextFormField(
                                    obscureText: obscure1,
                                    autofillHints: const [
                                      AutofillHints.password,
                                    ],
                                    controller: oldPasswordController,
                                    keyboardType: TextInputType.text,
                                    maxLength: 20,
                                    readOnly: false,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          value == "") {
                                        return 'Contraseña anterior obligatoria';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.lock_outline_sharp,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          obscure1
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        onPressed:
                                            () => setState(() {
                                              obscure1 = !obscure1;
                                            }),
                                      ),
                                      labelText: "Contraseña anterior",
                                      border: const OutlineInputBorder(),
                                      hintText: '',
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5.0,
                                ),
                                child: SizedBox(
                                  height: 79,
                                  child: TextFormField(
                                    obscureText: obscure2,
                                    autofillHints: const [
                                      AutofillHints.password,
                                    ],
                                    controller: newPasswordController,
                                    keyboardType: TextInputType.text,
                                    maxLength: 20,
                                    readOnly: false,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      String patternUpper = r'^(?=.*?[A-Z])';

                                      String patternLower = r'^(?=.*?[a-z])';
                                      String patternNumber = r'^(?=.*?[0-9])';
                                      String patternSpecial =
                                          r'^(?=.*?[!@#\$&-~+/_.^])';
                                      RegExp regExpUp = RegExp(patternUpper);
                                      RegExp regExpLw = RegExp(patternLower);
                                      RegExp regExpNm = RegExp(patternNumber);
                                      RegExp regExpSp = RegExp(patternSpecial);
                                      if (value == null ||
                                          value.isEmpty ||
                                          value == "") {
                                        return 'Contraseña obligatoria';
                                      }
                                      if (!regExpUp.hasMatch(value)) {
                                        return 'Mínimo un caracter en mayúsculas';
                                      }
                                      if (!regExpLw.hasMatch(value)) {
                                        return 'Mínimo un caracter en mínusculas';
                                      }
                                      if (!regExpNm.hasMatch(value)) {
                                        return 'Mínimo un número';
                                      }
                                      if (!regExpSp.hasMatch(value)) {
                                        return 'Mínimo un caracter especial';
                                      }
                                      if (value.length < 8) {
                                        return 'Minimo 8 caracteres';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.lock_outline_sharp,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          obscure2
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        onPressed:
                                            () => setState(() {
                                              obscure2 = !obscure2;
                                            }),
                                      ),
                                      labelText: "Nueva contraseña",
                                      border: const OutlineInputBorder(),
                                      hintText: '',
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5.0,
                                ),
                                child: SizedBox(
                                  height: 79,
                                  child: TextFormField(
                                    obscureText: obscure3,
                                    autofillHints: const [
                                      AutofillHints.password,
                                    ],
                                    controller: repeatPasswordController,
                                    keyboardType: TextInputType.text,
                                    maxLength: 20,
                                    readOnly: false,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          value == "") {
                                        return 'Confirmación obligatoria';
                                      }
                                      if (newPasswordController.text !=
                                          repeatPasswordController.text) {
                                        return 'La contraseña no concuerda';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.lock_outline_sharp,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          obscure3
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        onPressed:
                                            () => setState(() {
                                              obscure3 = !obscure3;
                                            }),
                                      ),
                                      labelText: "Confirmar nueva contraseña",
                                      border: const OutlineInputBorder(),
                                      hintText: '',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                _buttonClean(),
                                const SizedBox(width: 5),
                                _buttonSend(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonClean() {
    return Expanded(
      child: TextButton.icon(
        icon: const Icon(
          Icons.restore_from_trash_sharp,
          color: ColorUtil.white,
        ),
        style: TextButton.styleFrom(
          backgroundColor: ColorUtil.gray,
          padding: const EdgeInsets.all(20),
        ),
        onPressed: () {
          setState(() {
            oldPasswordController.text = "";
            newPasswordController.text = "";
            repeatPasswordController.text = "";
          });
        },
        label: const Text(
          "LIMPIAR",
          style: TitleTextStyle(color: ColorUtil.white, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buttonSend() {
    return Expanded(
      child: TextButton.icon(
        icon: const Icon(Icons.payment_outlined, color: ColorUtil.white),
        style: TextButton.styleFrom(
          backgroundColor: _colorProvider.primary(),
          padding: const EdgeInsets.all(20),
        ),
        onPressed:
            () async =>
                _formKey.currentState!.validate() ? buttonAction() : null,
        label: const Text(
          "CAMBIAR",
          style: TitleTextStyle(color: ColorUtil.white, fontSize: 12),
        ),
      ),
    );
  }

  Future<Result> sendChangePassword() async {
    Map<String, dynamic> body = {
      "password": Cryptom.encrypt(
        oldPasswordController.text,
        MyUtils.publicKey,
      ),
      "new_password": Cryptom.encrypt(
        newPasswordController.text,
        MyUtils.publicKey,
      ),
    };
    return await _apiServices.recoverExpiredPassword(widget.email, body);
  }

  buttonAction() async {
    setState(() {
      loading = true;
    });
    var sendChange = await sendChangePassword();

    if (sendChange.success) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder:
            (BuildContext context) => PopScope(
              canPop: false,
              child: Alerts.success("Contraseña renovada exitosamente", () {
                Navigator.pop(context);
                context.goNamed(StaticNames.loginName.name);
              }),
            ),
      );
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder:
            (BuildContext context) => PopScope(
              canPop: false,
              child: Alerts.error(
                sendChange.errorMessage ?? "Error",
                () => Navigator.pop(context),
              ),
            ),
      );
    }
    setState(() {
      loading = false;
    });
  }
}

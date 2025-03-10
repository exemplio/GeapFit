// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sports_management/di/injection.dart';
import 'package:sports_management/services/http/api_services.dart';
import 'package:sports_management/services/http/result.dart';
import 'package:sports_management/styles/bg.dart';
import 'package:sports_management/styles/text.dart';
import 'package:sports_management/styles/theme_provider.dart';
import 'package:sports_management/utils/translate.dart';
import 'package:sports_management/utils/uppercase.dart';
import 'package:sports_management/widgets/alert_dialog.dart';

class EmailForm extends StatefulWidget {
  String title;
  EmailForm({required this.title, super.key});

  @override
  State<EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final _colorProvider = getIt<ThemeProvider>().colorProvider();
  TextEditingController emailController = TextEditingController();
  TextEditingController emailToSendController = TextEditingController();
  TextEditingController answer1Controller = TextEditingController();
  TextEditingController answer2Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ApiServices _apiServices = getIt<ApiServices>();
  List<dynamic> questions = [];
  bool loading = false;
  bool principal = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                      child: CircularProgressIndicator()),
                  SizedBox(height: 10),
                  Text("Cargando")
                ]),
          ),
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Image(
                image: AssetImage("assets/img/Logo-PinPagos-03.png"),
                width: 180,
                height: 120,
              ),
              Text(translate(widget.title),
                  textAlign: TextAlign.center,
                  style: TitleTextStyle(
                      fontSize: 18,
                      color: _colorProvider.primary(),
                      fontWeight: FontWeight.bold)),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 4), // changes position of shadow
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
                              top: 50, left: 20, right: 20, bottom: 30),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 79,
                                child: TextFormField(
                                  enabled: questions.isEmpty,
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  maxLength: 50,
                                  readOnly: false,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value == "") {
                                      return 'Correo obligatorio';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      labelText: "Correo electrónico",
                                      border: OutlineInputBorder(),
                                      hintText: ''),
                                ),
                              ),
                              questions.isNotEmpty
                                  ? Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(questions[0],
                                                  style: const TextStyle(
                                                      fontSize: 14)),
                                              SizedBox(
                                                height: 79,
                                                child: TextFormField(
                                                  enabled: questions.isNotEmpty,
                                                  controller: answer1Controller,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  maxLength: 20,
                                                  readOnly: false,
                                                  inputFormatters: [
                                                    LowerCaseTextFormatter(),
                                                  ],
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  validator: (value) {
                                                    if (questions.isNotEmpty) {
                                                      if (value == null ||
                                                          value.isEmpty ||
                                                          value == "") {
                                                        return 'Respuesta obligatoria';
                                                      }
                                                    }
                                                    return null;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText:
                                                              "Respuesta 1",
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText: ''),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(questions[1],
                                                  style: const TextStyle(
                                                      fontSize: 14)),
                                              SizedBox(
                                                height: 79,
                                                child: TextFormField(
                                                  enabled: questions.isNotEmpty,
                                                  controller: answer2Controller,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  inputFormatters: [
                                                    LowerCaseTextFormatter(),
                                                  ],
                                                  maxLength: 20,
                                                  readOnly: false,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  validator: (value) {
                                                    if (questions.isNotEmpty) {
                                                      if (value == null ||
                                                          value.isEmpty ||
                                                          value == "") {
                                                        return 'Respuesta obligatoria';
                                                      }
                                                    }
                                                    return null;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText:
                                                              "Respuesta 2",
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText: ''),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.0),
                                              child: Text(
                                                "Correo a donde enviar desea enviar la información",
                                                style: TextStyle(fontSize: 14),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value: true,
                                                        groupValue: principal,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            principal =
                                                                value ?? true;
                                                          });
                                                        },
                                                      ),
                                                      const Text("Principal",
                                                          style: TextStyle(
                                                              fontSize: 16))
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value: false,
                                                        groupValue: principal,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            principal =
                                                                value ?? false;
                                                          });
                                                        },
                                                      ),
                                                      const Text("Otro",
                                                          style: TextStyle(
                                                              fontSize: 16))
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        !principal
                                            ? SizedBox(
                                                height: 79,
                                                child: TextFormField(
                                                  enabled: questions.isNotEmpty,
                                                  controller:
                                                      emailToSendController,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  maxLength: 50,
                                                  readOnly: false,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  validator: (value) {
                                                    if (!principal &&
                                                        questions.isNotEmpty) {
                                                      if (value == null ||
                                                          value.isEmpty ||
                                                          value == "") {
                                                        return 'Correo obligatorio';
                                                      }
                                                    }
                                                    return null;
                                                  },
                                                  decoration: const InputDecoration(
                                                      labelText:
                                                          "Otro electronico",
                                                      border:
                                                          OutlineInputBorder(),
                                                      hintText: ''),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    )
                                  : const SizedBox()
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
                                _buttonSend()
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 15.0, top: 10),
                            child: InkWell(
                                child: const Text(
                                  "Regresar",
                                  style: TextStyle(
                                      color: Color.fromARGB(185, 44, 44, 44),
                                      decoration: TextDecoration.underline),
                                ),
                                onTap: () {
                                  context.pop();
                                }),
                          ),
                        ],
                      )
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonClean() {
    return Expanded(
      child: TextButton.icon(
          icon: const Icon(Icons.restore_from_trash_sharp,
              color: ColorUtil.white),
          style: TextButton.styleFrom(
              backgroundColor: ColorUtil.gray,
              padding: const EdgeInsets.all(20)),
          onPressed: () {
            setState(() {
              questions = [];
              emailController.text = "";
              answer1Controller.text = "";
              answer2Controller.text = "";
              emailToSendController.text = "";
              principal = true;
            });
          },
          label: const Text("LIMPIAR",
              style: TitleTextStyle(color: ColorUtil.white, fontSize: 12))),
    );
  }

  Widget _buttonSend() {
    String titleButton = "";
    if (widget.title == "RECOVER") {
      if (questions.isEmpty) {
        titleButton = "CONSULTAR";
      } else {
        titleButton = "RECUPERAR";
      }
    } else {
      titleButton = "ENVIAR";
    }
    return Expanded(
      child: TextButton.icon(
          icon: const Icon(Icons.payment_outlined, color: ColorUtil.white),
          style: TextButton.styleFrom(
              backgroundColor: _colorProvider.primary(),
              padding: const EdgeInsets.all(20)),
          onPressed: () async =>
              _formKey.currentState!.validate() ? buttonAction() : null,
          label: Text(titleButton,
              style:
                  const TitleTextStyle(color: ColorUtil.white, fontSize: 12))),
    );
  }

  Future<Result> recoverAction(String email) async {
    return await _apiServices.recoveryQuestions(email);
  }

  Future<Result> resendAction(String email) async {
    return await _apiServices.resendSign(email);
  }

  Future<Result> sendRecoverAction() async {
    String otherEmail =
        principal ? emailController.text : emailToSendController.text;
    Map<String, dynamic> body = {
      "email": emailController.text,
      "emails_to_send_url": [otherEmail],
      "security_questions": [
        {"question": questions[0], "answer": answer1Controller.text},
        {"question": questions[1], "answer": answer2Controller.text},
      ],
    };
    return await _apiServices.recovery(body);
  }

  buttonAction() async {
    setState(() {
      loading = true;
    });
    if (widget.title == "RECOVER") {
      if (questions.isEmpty) {
        var recover = await recoverAction(emailController.text);
        if (recover.success) {
          questions = recover.obj;
        } else {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => PopScope(
                  canPop: false,
                  child: Alerts.error(recover.errorMessage ?? "Error",
                      () => Navigator.pop(context))));
        }
        setState(() {
          loading = false;
        });
      } else {
        var sendRecover = await sendRecoverAction();
        if (sendRecover.success) {
          String otherEmail =
              principal ? emailController.text : emailToSendController.text;
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => PopScope(
                  canPop: false,
                  child: Alerts.success(
                      "Información de recuperación enviada con éxito al correo: '$otherEmail'",
                      () => Navigator.pop(context))));
        } else {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => PopScope(
                  canPop: false,
                  child: Alerts.error(sendRecover.errorMessage ?? "Error",
                      () => Navigator.pop(context))));
        }
        setState(() {
          loading = false;
        });
      }
    } else {
      var resend = await resendAction(emailController.text);
      if (resend.success) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => PopScope(
                canPop: false,
                child: Alerts.success("Correo de activación enviado con éxito",
                    () => Navigator.pop(context))));
      } else {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => PopScope(
                canPop: false,
                child: Alerts.error(resend.errorMessage ?? "Error",
                    () => Navigator.pop(context))));
      }
      setState(() {
        loading = false;
      });
    }
  }
}

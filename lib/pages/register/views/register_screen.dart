// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:geap_fit/di/injection.dart';
import 'package:geap_fit/styles/theme_provider.dart';
import 'package:geap_fit/utils/staticNamesRoutes.dart';
import 'package:geap_fit/utils/uppercase.dart';
import 'package:geap_fit/utils/utils.dart';
import 'package:geap_fit/widgets/alert_dialog.dart';

import '../../../styles/bg.dart';
import '../../../styles/text.dart';
import '../register_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _colorProvider = getIt<ThemeProvider>().colorProvider();
  final logger = Logger();
  final _formKey = GlobalKey<FormState>();
  String showQuestion1 = "345";
  String showQuestion2 = "SEGUNDO NOMBRE DE TU MADRE";
  String? type = "NATURAL_PERSON";
  List<SelectedListItem> questionList1 = [];
  List<SelectedListItem> questionList2 = [];
  String terms = "";
  bool acepted = false;
  bool loadingState = false;

  var obscure = true;
  var obscure2 = true;

  @override
  void initState() {
    _bloc().init();
    //_loadAnswers("8");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ignore: unused_element
  void _init() {
    _bloc().add(const InitEvent());
  }

  RegisterBloc _bloc() {
    return context.read<RegisterBloc>();
  }

  var maskFormatter = MaskTextInputFormatter(
    mask: '(###) ###-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked:
          loadingState
              ? null
              : (didPop) {
                _bloc().clean();
                context.goNamed(StaticNames.loginName.name);
              },
      child: Scaffold(
        body: BlocConsumer<RegisterBloc, RegisterState>(
          bloc: _bloc(),
          listener: (context, state) {
            if (state is RegisterSuccessState) {
              _successSign();
            }
            if (state is RegisterErrorState) {
              if (((state.errorMessage != "NOT_ENOUGH_SECURITY_QUESTIONS" &&
                  state.errorMessage != "GATEWAY_TIMEOUT"))) {
                errorModal(state.errorMessage);
              }
            }
            loadingState = state is RegisterLoadingState;
          },
          builder: (context, state) {
            if (state is RegisterErrorState &&
                ((state.errorMessage == "NOT_ENOUGH_SECURITY_QUESTIONS" ||
                        state.errorMessage == "GATEWAY_TIMEOUT") &&
                    questionList1.isEmpty)) {
              return _errorScreen(errorMessage: state.errorMessage);
            }
            return SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Image(
                          image: AssetImage("assets/icons/icon_white.png"),
                          width: 200,
                          height: 80,
                        ),
                        Text(
                          "NUEVA CUENTA",
                          textAlign: TextAlign.center,
                          style: TitleTextStyle(
                            fontSize: 18,
                            color: _colorProvider.primary(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Form(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: _typeUser(loadingState),
                                  ),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    flex: 2,
                                    child: _typeDocument(loadingState),
                                  ),
                                  Flexible(
                                    flex: 5,
                                    child: _documentNumber(loadingState),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 7.0,
                                ),
                                child: SizedBox(
                                  height: 79,
                                  child: TextFormField(
                                    controller: _bloc().emailController,
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
                                      if (!MyUtils.REX_EMAIL.hasMatch(value)) {
                                        return 'Ingresar un correo válido';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      labelText: "Correo electrónico",
                                      border: OutlineInputBorder(),
                                      hintText: '',
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: _typePhone(loadingState),
                                  ),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    flex: 3,
                                    child: _phoneNumber(loadingState),
                                  ),
                                ],
                              ),
                              type == "NATURAL_PERSON"
                                  ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5.0,
                                          ),
                                          child: SizedBox(
                                            height: 79,
                                            child: TextFormField(
                                              textCapitalization:
                                                  TextCapitalization.characters,
                                              controller:
                                                  _bloc().firstNameController,
                                              keyboardType: TextInputType.name,
                                              inputFormatters: [
                                                UpperCaseTextFormatter(),
                                              ],
                                              maxLength: 15,
                                              readOnly: false,
                                              validator: (value) {
                                                if (type == "NATURAL_PERSON") {
                                                  if (value == null ||
                                                      value.isEmpty ||
                                                      value == "") {
                                                    return 'Nombre obligatorio';
                                                  }
                                                  return null;
                                                }
                                                return null;
                                              },
                                              autovalidateMode:
                                                  AutovalidateMode
                                                      .onUserInteraction,
                                              decoration: const InputDecoration(
                                                labelText: "Nombre",
                                                border: OutlineInputBorder(),
                                                hintText: '',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Flexible(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5.0,
                                          ),
                                          child: SizedBox(
                                            height: 79,
                                            child: TextFormField(
                                              textCapitalization:
                                                  TextCapitalization.characters,
                                              controller:
                                                  _bloc().lastNameController,
                                              keyboardType: TextInputType.name,
                                              inputFormatters: [
                                                UpperCaseTextFormatter(),
                                              ],
                                              maxLength: 15,
                                              readOnly: false,
                                              validator: (value) {
                                                if (type == "NATURAL_PERSON") {
                                                  if (value == null ||
                                                      value.isEmpty ||
                                                      value == "") {
                                                    return 'Apellido obligatorio';
                                                  }
                                                  return null;
                                                }
                                                return null;
                                              },
                                              autovalidateMode:
                                                  AutovalidateMode
                                                      .onUserInteraction,
                                              decoration: const InputDecoration(
                                                labelText: "Apellido",
                                                border: OutlineInputBorder(),
                                                hintText: '',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                  : Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                    ),
                                    child: SizedBox(
                                      height: 79,
                                      child: TextFormField(
                                        textCapitalization:
                                            TextCapitalization.characters,
                                        controller:
                                            _bloc().businessNameController,
                                        keyboardType: TextInputType.name,
                                        inputFormatters: [
                                          UpperCaseTextFormatter(),
                                        ],
                                        maxLength: 20,
                                        readOnly: false,
                                        validator: (value) {
                                          if (type == "LEGAL_PERSON") {
                                            if (value == null ||
                                                value.isEmpty ||
                                                value == "") {
                                              return 'Razón Social obligatoria';
                                            }
                                            return null;
                                          }
                                          return null;
                                        },
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: const InputDecoration(
                                          labelText: "Razón Social",
                                          border: OutlineInputBorder(),
                                          hintText: '',
                                        ),
                                      ),
                                    ),
                                  ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 5.0,
                                        bottom: 5.0,
                                        right: 2,
                                      ),
                                      child: SizedBox(
                                        height: 84,
                                        child: TextFormField(
                                          controller:
                                              _bloc().passwordController,
                                          autofillHints: const [
                                            AutofillHints.password,
                                          ],
                                          keyboardType: TextInputType.text,
                                          maxLength: 20,
                                          readOnly: false,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.deny(
                                              RegExp(r'\s'),
                                            ),
                                          ],
                                          validator: (value) {
                                            String patternUpper =
                                                r'^(?=.*?[A-Z])';

                                            String patternLower =
                                                r'^(?=.*?[a-z])';
                                            String patternNumber =
                                                r'^(?=.*?[0-9])';
                                            String patternSpecial =
                                                r'^(?=.*?[!@#\$&~+.\\\-])';
                                            RegExp regExpUp = RegExp(
                                              patternUpper,
                                            );
                                            RegExp regExpLw = RegExp(
                                              patternLower,
                                            );
                                            RegExp regExpNm = RegExp(
                                              patternNumber,
                                            );
                                            RegExp regExpSp = RegExp(
                                              patternSpecial,
                                            );
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
                                          // enabled: !isLoggingIn,
                                          obscureText: obscure,
                                          decoration: InputDecoration(
                                            prefixIcon: const Icon(
                                              Icons.lock_outline_sharp,
                                            ),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                obscure
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                              ),
                                              onPressed:
                                                  () => setState(() {
                                                    obscure = !obscure;
                                                  }),
                                            ),
                                            labelText: "Contraseña",
                                            border: const OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 5.0,
                                        bottom: 5.0,
                                        left: 2,
                                      ),
                                      child: SizedBox(
                                        height: 84,
                                        child: TextFormField(
                                          validator:
                                              (value) =>
                                                  _bloc().passwordValidator(),
                                          controller:
                                              _bloc()
                                                  .passwordConfirmationController,
                                          autofillHints: const [
                                            AutofillHints.password,
                                          ],
                                          keyboardType: TextInputType.text,
                                          maxLength: 20,
                                          readOnly: false,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.deny(
                                              RegExp(r'\s'),
                                            ),
                                          ],
                                          obscureText: obscure2,
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
                                            labelText: "Confirmar contraseña",
                                            border: const OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              /* Row(
                              children: [
                                IconButton(
                                    color:
                                        const Color.fromARGB(255, 34, 28, 28),
                                    onPressed: () {
                                      dropdown1();
                                    },
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                    )),
                                Flexible(
                                    child: Text(showQuestion1,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(fontSize: 14))),
                              ],
                            ),
                            SizedBox(
                              height: 79,
                              child: TextFormField(
                                controller: _bloc().answerController,
                                keyboardType: TextInputType.name,
                                maxLength: 8,
                                readOnly: false,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value == "") {
                                    return 'Respuesta obligatoria';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: "Respuesta 1",
                                    border: OutlineInputBorder(),
                                    hintText: ''),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                    color: Colors.black,
                                    onPressed: () {
                                      dropdown2();
                                    },
                                    icon: const Icon(
                                        Icons.keyboard_arrow_down_sharp)),
                                Flexible(
                                    child: Text(showQuestion2,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(fontSize: 14))),
                              ],
                            ),
                            SizedBox(
                              height: 79,
                              child: TextFormField(
                                controller: _bloc().answer2Controller,
                                keyboardType: TextInputType.text,
                                maxLength: 8,
                                readOnly: false,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value == "") {
                                    return 'Respuesta obligatoria';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: "Respuesta 2",
                                    border: OutlineInputBorder(),
                                    hintText: ''),
                              ),
                            ), */
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Checkbox(
                                      value: acepted,
                                      onChanged:
                                          loadingState
                                              ? null
                                              : ((value) {
                                                setState(() {
                                                  if (value != null) {
                                                    acepted = value;
                                                  } else {
                                                    acepted = !acepted;
                                                  }
                                                });
                                              }),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                              "Términos y Condiciones",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                            content: SizedBox(
                                              height:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.5,
                                              child: SingleChildScrollView(
                                                child: Text(
                                                  terms,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Cerrar"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Text(
                                      "Acepto términos y condiciones.",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      alignment: AlignmentDirectional.topCenter,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 0.0),
                                          child: Text(
                                            "Esto es un producto",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                255,
                                                94,
                                                94,
                                                94,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Image(
                                          image: ResizeImage(
                                            AssetImage(
                                              'assets/img/credicard4.png',
                                            ),
                                            width: 160,
                                            height: 50,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              paddingFunction(),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                children: [_registerButton(loadingState)],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 15.0,
                                top: 10,
                              ),
                              child: TextButton(
                                child: Text(
                                  "Reenviar correo de activación",
                                  style: TextStyle(
                                    color: _colorProvider.primary(),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                onPressed: () {
                                  context.pushNamed(
                                    StaticNames.emailFormName.name,
                                    extra: "RESEND",
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /* void _loadAnswers(amount) async {
    List<dynamic>? response = await _bloc().securityQuestion1(amount);
    if (response != null) {
      int halfLength =
          int.parse((response.length / 2).toString().replaceAll('.0', ""));
      List<dynamic> list1 = response.sublist(0, halfLength);
      List<dynamic> list2 = response.sublist(halfLength);
      for (var i = 0; i < halfLength; i++) {
        questionList1.add(SelectedListItem(
            name: list1[i]["question"],
            value: list1[i]["question"],
            isSelected: i == 0 ? true : false));
      }
      for (var i = 0; i < halfLength; i++) {
        questionList2.add(SelectedListItem(
            name: list2[i]["question"],
            value: list2[i]["question"],
            isSelected: i == 0 ? true : false));
      }
      setState(() {
        showQuestion1 = list1[0]["question"];
        showQuestion2 = list2[0]["question"];
        _bloc().question1Controller.text = showQuestion1;
        _bloc().question2Controller.text = showQuestion2;
      });
    } else {
      _bloc()
          .add(const RegisterErrorEvent(errorMessage: "Error al cargar datos"));
    }
  } */

  void dropdown1() {
    DropDownState(
      DropDown(
        bottomSheetTitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text("Pregunta 1", style: titleStyleText("", 18))],
          ),
        ),
        data: questionList1,
        selectedItems: (List<dynamic> selectedList) {
          for (var item in selectedList) {
            if (item is SelectedListItem) {
              setState(() {
                showQuestion1 = item.value ?? "";
                _bloc().question1Controller.text = item.value ?? "";
              });
            }
          }
        },
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  }

  void dropdown2() {
    DropDownState(
      DropDown(
        bottomSheetTitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text("Pregunta 2", style: titleStyleText("", 18))],
          ),
        ),
        data: questionList2,
        selectedItems: (List<dynamic> selectedList) {
          for (var item in selectedList) {
            if (item is SelectedListItem) {
              setState(() {
                showQuestion2 = item.value ?? "";
                _bloc().question2Controller.text = item.value ?? "";
              });
            }
          }
        },
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  }

  Widget paddingFunction() {
    if (_bloc().passwordValidator() != "") {
      return const Padding(padding: EdgeInsets.all(8.0));
    } else {
      return const SizedBox.shrink();
    }
  }

  _typePhone(bool loadingState) {
    return SizedBox(
      height: 59,
      child: DropdownButtonFormField<String>(
        value: _bloc().typePhoneSelected,
        icon: const Icon(Icons.arrow_downward),
        style: const TextStyle(color: Colors.deepPurple, fontFamily: "Kalinga"),
        isExpanded: true,
        validator: (type) => _bloc().validateTypePhone(type),
        onChanged: loadingState ? null : (type) => _bloc().setTypePhone(type),
        items:
            _bloc().types_phones.map<DropdownMenuItem<String>>((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(
                  type,
                  style: const TitleTextStyle(color: ColorUtil.dark_gray),
                ),
              );
            }).toList(),
      ),
    );
  }

  SizedBox _phoneNumber(bool loadingState) {
    return SizedBox(
      height: 79,
      child: TextFormField(
        controller: _bloc().phoneController,
        keyboardType: TextInputType.number,
        maxLength: 8,
        readOnly: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        enabled: !loadingState,
        inputFormatters: [_bloc().maskFormatter],
        validator: (value) => _bloc().validateNumber(value),
        decoration: const InputDecoration(
          labelText: "Número de teléfono",
          border: OutlineInputBorder(),
          hintText: '',
        ),
      ),
    );
  }

  _typeDocument(bool loadingState) {
    return SizedBox(
      height: 59,
      child: DropdownButtonFormField<String>(
        iconSize: 0,
        value: _bloc().typeDniSelected,
        alignment: Alignment.center,
        style: const TextStyle(color: Colors.deepPurple, fontFamily: "Kalinga"),
        isExpanded: true,
        validator: (type) => _bloc().validateTypeDni(type),
        onChanged: loadingState ? null : (type) => _bloc().setTypeDoc(type),
        items:
            _bloc().types_docs.map<DropdownMenuItem<String>>((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Center(
                  child: Text(
                    type,
                    style: const TitleTextStyle(color: ColorUtil.dark_gray),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  _typeUser(bool loadingState) {
    return SizedBox(
      height: 59,
      child: DropdownButtonFormField<String>(
        value: _bloc().typeController.text,
        icon: const Icon(Icons.arrow_downward),
        style: const TextStyle(color: Colors.deepPurple, fontFamily: "Kalinga"),
        decoration: const InputDecoration(label: Text("Tipo")),
        isExpanded: true,
        onChanged:
            loadingState
                ? null
                : (value) {
                  String formattedType =
                      value == "Natural" ? "NATURAL_PERSON" : "LEGAL_PERSON";
                  setState(() {
                    type = formattedType;
                    _bloc().typeController.text = value ?? "";
                  });
                },
        items:
            _bloc().types_user.map<DropdownMenuItem<String>>((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(
                  type,
                  style: const TitleTextStyle(color: ColorUtil.dark_gray),
                ),
              );
            }).toList(),
      ),
    );
  }

  SizedBox _documentNumber(bool loadingState) {
    return SizedBox(
      height: 79,
      child: TextFormField(
        controller: _bloc().idDocController,
        keyboardType: TextInputType.number,
        maxLength: 9,
        readOnly: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        enabled: !loadingState,
        validator: (value) {
          if (value == null || value.isEmpty || value == "") {
            return 'Número de documento obligatorio';
          }
          return null;
        },
        decoration: const InputDecoration(
          labelText: "RIF/CI",
          border: OutlineInputBorder(),
          hintText: '',
        ),
      ),
    );
  }

  Widget _registerButton(bool loadingState) {
    return Expanded(
      child: TextButton.icon(
        icon: const Icon(Icons.person, color: ColorUtil.white),
        style: TextButton.styleFrom(
          backgroundColor: _colorProvider.primary(),
          padding: const EdgeInsets.all(20),
        ),
        onPressed:
            () async =>
                _formKey.currentState!.validate() && !loadingState
                    ? acepted
                        ? confirmRegister()
                        : showMessage()
                    : null,
        label: const Text(
          "REGISTRAR",
          style: TitleTextStyle(color: ColorUtil.white, fontSize: 14),
        ),
      ),
    );
  }

  Widget _errorScreen({String errorMessage = "Ha ocurrido un error"}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        Text(errorMessage.toUpperCase(), textAlign: TextAlign.center),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            onTap: () {
              if ((errorMessage == "NOT_ENOUGH_SECURITY_QUESTIONS" ||
                      errorMessage == "GATEWAY_TIMEOUT") &&
                  questionList1.isEmpty) {
                context.goNamed(StaticNames.loginName.name);
              } else {
                _bloc().add(const RegisterLoadedEvent());
              }
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back_sharp, color: Colors.red),
                Text("Regresar", style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void errorModal(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Alerts.error(errorMessage, () => Navigator.pop(context));
      },
    );
  }

  confirmRegister() {
    showDialog(
      context: context,
      builder: (context) {
        return PopScope(
          canPop: !loadingState,
          child: AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            content: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "¿Estás seguro que su correo es ",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        TextSpan(
                          text: _bloc().emailController.text,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: _colorProvider.primary(),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text: " y su número de documento es ",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        TextSpan(
                          text:
                              "${_bloc().typeDniSelected}-${_bloc().idDocController.text}?",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Si su correo es incorrecto, se podrá registrar de nuevo dentro de 24 horas.",
                    style: TextStyle(
                      color: Color(0xffb71c1c),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              ElevatedButton(
                style: const ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(Size(130, 40)),
                  backgroundColor: MaterialStatePropertyAll(Colors.grey),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "CANCELAR",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  fixedSize: const MaterialStatePropertyAll(Size(130, 40)),
                  backgroundColor: MaterialStatePropertyAll(
                    _colorProvider.primary(),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (loadContext) {
                      _bloc().signUp(loadContext);
                      return PopScope(
                        canPop: false,
                        onPopInvoked: (didPop) {},
                        child: const Center(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text(
                  "ACEPTAR",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _successSign() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Alerts.success(
          "Usuario creado con exito. Por favor revise su buzón de correo ${_bloc().emailController.text} y active su cuenta. Tiene un lapso de 24 horas, si no el correo será eliminado automáticamente y tendrá que repetir el proceso de registro.",
          () {
            Navigator.pop(context);
            context.goNamed(StaticNames.loginName.name);
          },
          buttonText: "Cerrar",
        );
      },
    );
  }

  showMessage() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(milliseconds: 1500),
        content: Text("Debe aceptar los términos y condiciones"),
      ),
    );
  }
}

/* Widget _loadingCenter() {
  return const Center(
    child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 50, height: 50, child: CircularProgressIndicator()),
          SizedBox(height: 10),
          Text("Cargando")
        ]),
  );
} */

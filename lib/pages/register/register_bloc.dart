// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names, use_build_context_synchronously

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:geap_fit/pages/register/register_service.dart';
import 'package:geap_fit/services/http/result.dart';
import 'package:geap_fit/utils/utils.dart';

import '../../styles/theme_provider.dart';
import '../../utils/encrypt_password.dart';
import '../../utils/translate.dart';

part 'register_event.dart';
part 'register_state.dart';

@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final _logger = Logger();
  final RegisterService _registerService;
  final ThemeProvider themeProvider;
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController idDocController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController answerController = TextEditingController(text: "hola");
  TextEditingController answer2Controller = TextEditingController(text: "hola");
  TextEditingController question1Controller =
      TextEditingController(text: "345");
  TextEditingController question2Controller =
      TextEditingController(text: "SEGUNDO NOMBRE DE TU MADRE");
  TextEditingController typeController = TextEditingController(text: "Natural");
  List<dynamic> show1 = [];
  List<dynamic> show2 = [];

  RegisterBloc(this._registerService, this.themeProvider)
      : super(const RegisterInitialState()) {
    on<RegisterEvent>((event, emit) {
      _logger.i(event);
      switch (event.runtimeType) {
        case RegisterInitialEvent:
          emit(const RegisterLoadingState());
          break;
        case RegisterSuccessEvent:
          emit(const RegisterSuccessState());
          break;
        case RegisterLoadingEvent:
          emit(const RegisterLoadingState());
          break;
        case RegisterLoadedEvent:
          emit(const RegisterLoadedState());
          break;
        case RegisterErrorEvent:
          emit(RegisterErrorState(
              errorMessage: (event as RegisterErrorEvent).errorMessage));
          break;
      }
    });
  }

  void init() {
    clean();
    typePhoneSelected = types_phones[0];
    typeDniSelected = types_docs[0];
    add(const RegisterLoadedEvent());
  }

  Future<void> signUp(BuildContext context) async {
    try {
      add(const RegisterLoadingEvent());

      var country = "VE";
      var email = emailController.text;
      var first_name = firstNameController.text.toUpperCase();
      var id_doc = "$typeDniSelected${idDocController.text.padLeft(9, "0")}";
      var id_doc_type = "CI";
      var last_name = lastNameController.text.toUpperCase();
      var business_name = businessNameController.text.toUpperCase();
      var password =
          Cryptom.encrypt(passwordController.text, MyUtils.publicKey);
      var phone = phoneController.text == ""
          ? null
          : '$typePhoneSelected${maskFormatter.unmaskText(phoneController.text)}';
      var answer = answerController.text;
      var answer2 = answerController.text;
      var question = question1Controller.text;
      var question2 = question2Controller.text;
      var type =
          typeController.text == "Natural" ? "NATURAL_PERSON" : "LEGAL_PERSON";
      var result = await _registerService
          .selfSignUp(
              country: country,
              email: email,
              first_name: first_name,
              id_doc: id_doc,
              id_doc_type: id_doc_type,
              last_name: last_name,
              business_name: business_name,
              password: password,
              phone: phone,
              answer: answer,
              answer2: answer2,
              question: question,
              question2: question2,
              type: type)
          .onError((error, stackTrace) => Result.fail(error, stackTrace))
          .timeout(
            const Duration(seconds: 90),
            onTimeout: () => Result.fail("TIEMPO DE ESPERA AGOTADO", null),
          );

      if (result.success) {
        add(const RegisterSuccessEvent());
      } else {
        errorMessage = result.errorMessage;
        add(RegisterErrorEvent(
            errorMessage:
                translate(errorMessage ?? "Error al realizar el pago")));
      }
      Navigator.pop(context);
    } catch (e) {
      _logger.e("Error: $e");
    }
  }

  Future<List<dynamic>?> refreshAnswers(amount) async {
    add(const RegisterLoadingEvent());
    var resultado = await _registerService.securityQuestions(amount);
    if (resultado.success) {
      if (resultado.obj != null) {
        if (resultado.obj!.isNotEmpty) {
          add(const RegisterLoadedEvent());
          return resultado.obj;
        }
      }
    } else {
      add(RegisterErrorEvent(
          errorMessage: resultado.errorMessage ??
              "Error al consultar datos para registro"));
    }
    return null;
  }

  Future<List<dynamic>?> securityQuestion1(amount) async {
    var response = await refreshAnswers(amount);
    show1 = response ?? [];
    return response;
  }

  String? errorMessage;
  String? typeDniSelected;
  String? typePhoneSelected;

  List<String> types_docs = ["V", "E", "J", "P"];
  List<String> types_phones = ["412", "414", "416", "424", "426"];
  List<String> types_user = ["Natural", "Jurídico"];

  String? validateNumber(phone) {
    var t = r'[0-9]{3}\-[0-9]{4}';
    String pattern = t;
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(phone) && phone != null && phone != "") {
      return 'Ingrese un número de teléfono válido';
    } else {
      return null;
    }
  }

  String? validateDni(digits) {
    if (digits == null || digits.isEmpty) {
      return 'La cédula no puede estar vacia';
    }
    if (digits.length < 4) {
      return 'Ingrese una cédula válida';
    }
    return null;
  }

  String? validateTypeDni(type) {
    if (type == null || type.isEmpty) {
      return 'Seleccione un tipo de cédula';
    }
    return null;
  }

  String? validateTypePhone(type) {
    if (type == null || type.isEmpty) {
      return 'Seleccione un tipo de operador';
    }
    return null;
  }

  void setTypePhone(String? type) {
    typePhoneSelected = type ?? types_phones[0];
    add(const RegisterLoadedEvent());
  }

  void setTypeDoc(String? type) {
    typeDniSelected = type ?? types_docs[0];
    add(const RegisterLoadedEvent());
  }

  void setTypeUser(String? type) {
    typeController.text = type ?? types_docs[0];
    add(const RegisterLoadedEvent());
  }

  var maskFormatter = MaskTextInputFormatter(
      mask: '###-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  String? passwordValidator() {
    if (passwordController.text != passwordConfirmationController.text) {
      return 'La contraseña no concuerda';
    }
    return null;
  }

  clean() async {
    emailController = TextEditingController();
    firstNameController = TextEditingController();
    businessNameController = TextEditingController();
    idDocController = TextEditingController();
    lastNameController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmationController = TextEditingController();
    phoneController = TextEditingController();
    answerController = TextEditingController(text: "hola");
    answer2Controller = TextEditingController(text: "hola");
    question1Controller = TextEditingController(text: "345");
    question2Controller =
        TextEditingController(text: "SEGUNDO NOMBRE DE TU MADRE");
    typeController = TextEditingController(text: "Natural");
    show1 = [];
    show2 = [];
  }
}

// ignore_for_file: depend_on_referenced_packages

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sports_management/di/injection.dart';
import 'package:sports_management/services/http/api_services.dart';

part 'withdraw_event.dart';
part 'withdraw_state.dart';

class WithdrawBloc extends Bloc<WithdrawEvent, WithdrawState> {
  final _logger = Logger();
  WithdrawBloc() : super(const WithdrawInitState()) {
    on<WithdrawEvent>((event, emit) {
      _logger.i("event ${event.runtimeType}");
      switch (event.runtimeType) {
        case WithdrawInitEvent:
          emit(const WithdrawInitState());
          break;
        case WithdrawLoadingEvent:
          emit(const WithdrawLoadingState());
          break;
        case WithdrawReloadingEvent:
          emit(
              WithdrawReloadingState((event as WithdrawReloadingEvent).loaded));
          break;
        case WithdrawErrorEvent:
          emit(WithdrawErrorState((event as WithdrawErrorEvent).errorMsg));
          break;
        case WithdrawSuccessEvent:
          emit(const WithdrawSuccessState());
          break;
      }
    });
  }
  var maskFormatter = MaskTextInputFormatter(
      mask: '###-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  var numFormat =
      CurrencyTextInputFormatter.currency(locale: 'es_VE', decimalDigits: 2, symbol: "");

  String? validateTypeService(type) {
    if (type == null || type.isEmpty) {
      return 'Seleccione un tipo de servicio';
    }
    return null;
  }

  String? validateTypePhone(type) {
    if (type == null || type.isEmpty) {
      return 'Seleccione un tipo de operador';
    }
    return null;
  }

  String? validateNumber(phone) {
    var t = r'[0-9]{3}\-[0-9]{4}';
    if (phone == null || phone.isEmpty) {
      return 'El número de teléfono no puede estar vacio';
    }
    String pattern = t;
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(phone)) {
      return 'Ingrese un número de teléfono válido';
    } else {
      return null;
    }
  }

  String? validateTypeDni(type) {
    if (type == null || type.isEmpty) {
      return 'Seleccione un tipo de cédula';
    }
    return null;
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

  String? validateAmount(amount) {
    if (amount == null || amount.isEmpty) {
      return "El monto no puede estar vacio";
    }
    return null;
  }

  Future<void> sendRecharge(
      Map<String, dynamic> body, Map<String, dynamic> params) async {
    add(const WithdrawLoadingEvent());
    var result = await getIt<ApiServices>().withdraw(body, params);
    if (result.success) {
      add(const WithdrawSuccessEvent());
    } else {
      add(WithdrawErrorEvent(
          result.errorMessage ?? "Error al realizar el retiro"));
    }
  }
}

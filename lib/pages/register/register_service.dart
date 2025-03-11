// ignore_for_file: unused_field, unused_element, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:injectable/injectable.dart';
import 'package:sports_management/domain/message.dart';
import 'package:sports_management/services/http/api_services.dart';
import 'package:sports_management/services/http/result.dart';
import 'package:sports_management/services/token_service.dart';
import 'package:sports_management/utils/utils.dart';

@injectable
class RegisterService {
  final ApiServices _apiServices;
  final TokenService _tokenService;

  RegisterService(this._apiServices, this._tokenService);

  Future<Result<Void>> _getQuestions() async {
    return Result.success(null);
  }

  Future<Result<Message>> selfSignUp({
    required String country,
    required String email,
    required String id_doc,
    required String id_doc_type,
    required String password,
    String? phone,
    required String answer,
    required String answer2,
    required String question,
    required String question2,
    required String type,
    String? first_name,
    String? last_name,
    String? business_name,
  }) async {
    List<Map<String, String>> security_questions = [
      {
        "question": question,
        "answer": answer,
      },
      {
        "question": question2,
        "answer": answer2,
      },
    ];

    Map<String, dynamic> body = {};
    if (type == "NATURAL_PERSON") {
      body = {
        "country": country,
        "email": email,
        "first_name": first_name,
        "id_doc": id_doc,
        "id_doc_type": id_doc_type,
        "last_name": last_name,
        "password": password,
        "security_questions": security_questions,
        "type": type,
      };
    } else {
      body = {
        "country": country,
        "email": email,
        "id_doc": id_doc,
        "id_doc_type": id_doc_type,
        "business_name": business_name,
        "password": password,
        "security_questions": security_questions,
        "type": type,
      };
    }
    if (phone != null) body["phone"] = phone;
    return await _apiServices.selfSignUp(body: body);
  }

  Future<Result<List>> securityQuestions(amount) async {
    return await _apiServices.securityQuestionService(amount);
  }
}

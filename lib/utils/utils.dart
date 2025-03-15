// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geap_fit/services/http/domain/productModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/http/result.dart';
import 'extensions.dart';

abstract class MyUtils {
  static final Random random = Random();

  static final RegExp REX_CI = RegExp(r'^[VEJG][0-9]+$');
  
  static final RegExp REX_EMAIL = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  static final Set<String> nonAuthServices = {
    "/oauth/authorize",
    "/oauth/info_from_credentials"
  };
  static final Map<String, String> operador = {
  };

  static final Map<String, String> operadorNumber = {
  };
  static parseDNI(dni) {
    dni = dni.padLeft((9), "0");
    return dni;
  }

  static bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  static double? parseAmount(amount) {
    switch (amount.runtimeType) {
      case String:
        var parsedAmount = double.tryParse(amount);
        bool parse = parsedAmount?.isFinite ?? false;
        return parse ? parsedAmount : null;
      case int:
        return double.parse(amount.toString());
      case double:
        return amount;
    }
    return null;
  }

  static int? parseAmountInt(dynamic amount) {
    switch (amount.runtimeType) {
      case String:
        var parsedAmount = int.tryParse(amount);
        bool parse = parsedAmount?.isFinite ?? false;
        return parse ? parsedAmount : null;
      case int:
        return amount;
      case double:
        return int.parse(amount.toString());
    }
    return null;
  }

  static bool get showSplashScreen =>
      dotenv.env['SHOW_SPLASH_SCREEN']?.parseBool() ?? false;

  static bool get randomTheme =>
      dotenv.env['RANDOM_THEME']?.parseBool() ?? false;

  static String get authId => dotenv.env['AUTH_ID'] ?? '';

  static String get type => dotenv.env['CONTEXT_PATH'] ?? '';

  static String get clientId => dotenv.env['CLIENT_ID'] ?? '';

  static String get base => dotenv.env['API_URL'] ?? '';

  static String get publicKey => dotenv.env['PASSWORD_PUBLIC_KEY'] ?? '';

  static String get apiKey => dotenv.env['API_KEY'] ?? '';

  static bool get disableSslVerification =>
      dotenv.env['DISABLE_SSL_VERIFICATION']?.parseBool() ?? false;

  static String uri = "$type/pin_pad/payment";

  static Map<String, String> params = {};
  static Map<String, String> params2 = {};

  static Map<String, String> headers = {
    "Content-type": "application/json",
    'Accept': 'application/json',
  };
  static Map<String, String> headers2 = {
    "Content-type": "application/x-www-form-urlencoded",
  };

  static void testLoadDemo() {
    dotenv.testLoad(fileInput: File('env.demo').readAsStringSync());
  }

  static Future<void> loadDemo() {
    return dotenv.load(fileName: "env.demo");
  }

  static Future<Result<T>> nextResult<T, S>(
      Result<S> result, Future<Result<T>> Function(Result<S> result) function) {
    if (!result.success) {
      return Future.value(Result.transform(result));
    }

    return function(result);
  }

  static List<ProductModel> orderList(List<ProductModel> list) {
    if (list.isEmpty) {
      return [];
    } else {
      int n = list.length;
      int i, k;
      ProductModel aux;
      for (k = 1; k < n; k++) {
        for (i = 0; i < (n - k); i++) {
          if (list[i].formattedName!.compareTo(list[i + 1].formattedName!) >
              0) {
            aux = list[i];
            list[i] = list[i + 1];
            list[i + 1] = aux;
          }
        }
      }
      return list;
    }
  }

  static String cryptoKey() {
    return "DixFbJ8hts9YNyHEIYFIh6J1ZHJLAMUlKCkCBtjpvyM=";
  }

  static String cryptoIV() {
    return "Ra5z/FEYQfDgIFcqSxIZSw==";
  }

  static Future<SharedPreferences> prefs() {
    return SharedPreferences.getInstance();
  }
}

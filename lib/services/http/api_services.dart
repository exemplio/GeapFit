// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:geap_fit/domain/profile.dart';
import 'package:geap_fit/pages/client/models/userModel.dart';
import 'package:geap_fit/pages/agenda/models/collect_channel_model.dart';
import 'package:geap_fit/pages/agenda/models/store_model.dart';
import 'package:geap_fit/services/cacheService.dart';
import 'package:geap_fit/services/http/domain/password_grant_request.dart';
import 'package:geap_fit/services/http/http_util.dart';
import 'package:geap_fit/services/http/is_online_provider.dart';
import 'package:geap_fit/services/http/result.dart';
import 'package:geap_fit/utils/staticNamesServices.dart';
import '../../domain/access_token_response.dart';
import '../../domain/credential_response.dart';
import '../../domain/message.dart';
import '../../pages/agenda/models/rate_model.dart';
import '../../utils/utils.dart';
import 'http_service.dart';

@injectable
class ApiServices {
  final HttpService _httpService;
  final IsOnlineProvider _isOnlineProvider;
  // ignore: unused_field
  final _cache = Cache();
  ApiServices(this._httpService, this._isOnlineProvider);

  Uri url(String unencodedPath, {Map<String, dynamic>? queryParameters}) {
    return Uri.https(MyUtils.base, unencodedPath, queryParameters);
  }

  Uri urlAuth(String unencodedPath, {Map<String, dynamic>? queryParameters}) {
    return Uri.https(MyUtils.baseAuth, unencodedPath, queryParameters);
  }

  Future<Result<T>> httpCall<T>(
    Future<Response> Function(Client client) f, {
    T Function(dynamic json)? parseJson,
  }) async {
    var isOnline = await _isOnlineProvider.isOnline();

    if (isOnline) {
      return _httpService
          .response(f)
          .then((value) => HttpUtil.result(value, parseJson))
          .onError(HttpUtil.failResult);
    }

    return Future.value(Result.failMsg("No posee conexión a internet"));
  }

  Future<Result<AccessTokenResponse>> passwordGrant(
    PasswordGrantRequest request,
  ) {
    String path = StaticNamesPath.passwordGrant.path;
    var uri = urlAuth(
      "${MyUtils.typeAuth}$path",
      queryParameters: {"key": MyUtils.apiKey},
    );
    var headers = {HttpHeaders.contentTypeHeader: ContentType.json.toString()};
    return httpCall(
      (client) => client.post(uri, body: jsonEncode(request), headers: headers),
      parseJson: (json) => AccessTokenResponse.fromJson(json),
    );
  }

  Future<Result<AccessTokenResponse>> refreshToken(
    String idToken,
    String refreshToken,
  ) {
    var uri = url(
      "${MyUtils.type}${MyUtils.type}${StaticNamesPath.refresh.path}",
      queryParameters: {"refresh_token": refreshToken},
    );
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: "Bearer $idToken",
      "app-id": MyUtils.clientId,
    };

    return httpCall(
      (client) => client.put(uri, headers: headers),
      parseJson: (json) => AccessTokenResponse.fromJson(json),
    );
  }

  Future<Result> recoverExpiredPassword(
    String email,
    Map<String, dynamic> body,
  ) async {
    Map<String, dynamic> params = {"app-id": MyUtils.clientId, "email": email};
    var uri = url(
      "${MyUtils.type}${MyUtils.type}${StaticNamesPath.recoverExpired.path}",
      queryParameters: params,
    );

    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
      "app-id": MyUtils.clientId,
    };
    return httpCall(
      (client) => client.put(uri, body: jsonEncode(body), headers: headers),
      parseJson: (json) => json,
    );
  }

  Future<Result> recovery(Map<String, dynamic> body) {
    Map<String, String> params = {};
    params["app-id"] = MyUtils.clientId;
    var uri = url(
      "${MyUtils.type}${MyUtils.type}${StaticNamesPath.sendRecover.path}",
      queryParameters: params,
    );
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
      "app-id": MyUtils.clientId,
    };

    return httpCall(
      (client) => client.post(uri, body: jsonEncode(body), headers: headers),
    );
  }

  Future<Result> resendSign(String param) async {
    Map<String, String> params = {};
    params["app-id"] = MyUtils.clientId;
    params["email"] = param;
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
      "app-id": MyUtils.clientId,
    };

    var uri = url(
      "${MyUtils.type}${MyUtils.type}${StaticNamesPath.resend.path}",
      queryParameters: params,
    );
    return httpCall(
      (client) => client.get(uri, headers: headers),
      parseJson: (json) => json,
    );
  }

  Future<Result> recoveryQuestions(String param) async {
    Map<String, String> params = {};
    params["app-id"] = MyUtils.clientId;
    params["email"] = param;
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
      "app-id": MyUtils.clientId,
    };

    var uri = url(
      "${MyUtils.type}${MyUtils.type}${StaticNamesPath.recover.path}",
      queryParameters: params,
    );
    return httpCall(
      (client) => client.get(uri, headers: headers),
      parseJson: (json) => json,
    );
  }

  Future<Result<Void>> closeSession(String idToken) {
    var uri = url(
      "${MyUtils.type}${MyUtils.type}${StaticNamesPath.closeSession.path}",
    );
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: "Bearer $idToken",
    };

    return httpCall((client) => client.put(uri, headers: headers));
  }

  Future<Result<Profile>> profile() {
    var headers = {HttpHeaders.contentTypeHeader: ContentType.json.toString()};
    var uri = url("${MyUtils.type}${StaticNamesPath.profile.path}");

    return httpCall(
      (client) => client.get(uri, headers: headers),
      parseJson: (json) => Profile.fromJson(json),
    );
  }

  Future<Result<Users>> getClients() async {
    Map<String, String> params = {};

    var headers = {HttpHeaders.contentTypeHeader: ContentType.json.toString()};
    // var token = await initHeaders();
    // headers.addAll(token);

    var uri = url(
      "${MyUtils.type}${StaticNamesPath.getClients.path}",
      queryParameters: params,
    );

    return httpCall(
      (client) => client.get(uri, headers: headers),
      parseJson: (json) => Users.fromJson(json),
    );
  }

  Future<Result<CurrencyRate>> getRate({
    required Map<String, String> params,
    required Map<String, dynamic> body,
  }) async {
    var headers = {HttpHeaders.contentTypeHeader: ContentType.json.toString()};

    var uri = url(
      "${MyUtils.type}${StaticNamesPath.rate.path}",
      queryParameters: params,
    );

    return httpCall(
      (client) => client.post(uri, headers: headers, body: jsonEncode(body)),
      parseJson: (json) => CurrencyRate.fromJson(json),
    );
  }

  Future<Result<AccessTokenResponse>> authorize(String auth) {
    var uri = url("${MyUtils.type}${StaticNamesPath.authorize.path}");

    var headers = {HttpHeaders.authorizationHeader: "Basic $auth"};

    return httpCall(
      (client) => client.post(uri, headers: headers),
      parseJson: (json) => AccessTokenResponse.fromJson(json),
    );
  }

  Future<Result<Message>> selfSignUp({
    required Map<String, dynamic> body,
  }) async {
    Map<String, String> params = {};
    params["app-id"] = MyUtils.clientId;
    var uri = url(
      "${MyUtils.type}${MyUtils.type}${StaticNamesPath.selfSignUp.path}",
      queryParameters: params,
    );
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
      "app-id": MyUtils.clientId,
    };

    return httpCall(
      (client) => client.post(uri, headers: headers, body: jsonEncode(body)),
      parseJson: (json) => Message.fromJson(json),
    ).then(
      (value) => Result(
        value.success,
        value.obj,
        value.error,
        value.stackTrace,
        value.errorMessage,
        value.obj,
      ),
    );
  }

  Future<Result<List<dynamic>>> securityQuestionService(String param) async {
    Map<String, String> params = {};
    params["app-id"] = MyUtils.clientId;
    params["amount"] = param;
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
      "app-id": MyUtils.clientId,
    };

    var uri = url(
      "${MyUtils.type}${MyUtils.type}${StaticNamesPath.securityQuestions.path}",
      queryParameters: params,
    );
    return httpCall(
      (client) => client.get(uri, headers: headers),
      parseJson: (json) => json,
    );
  }
}

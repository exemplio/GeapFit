import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:geap_fit/domain/access_token_response.dart';
import 'package:geap_fit/domain/profile.dart';
import 'package:geap_fit/services/http/domain/password_grant_request.dart';
import 'package:geap_fit/services/http/result.dart';

import '../../services/http/api_services.dart';

@injectable
class GetCredentials {
  final ApiServices _apiServices;

  GetCredentials(this._apiServices);

  Future<Result<AccessTokenResponse>> refreshToken(
    String idToken,
    String refreshToken,
  ) {
    return _apiServices.refreshToken(idToken, refreshToken);
  }

  Future<Result<AccessTokenResponse>> authorize(
    String clientId,
    String secret,
  ) {
    var auth = utf8.fuse(base64).encode("$clientId:$secret");

    return _apiServices.authorize(auth);
  }

  Future<Result<AccessTokenResponse>> passwordGrant(
    String email,
    String password,
    bool isCI,
  ) {
    return _apiServices.passwordGrant(PasswordGrantRequest(email, password));
  }

  Future<Result<Profile>> profile() {
    return _apiServices.profile();
  }

  Future<Result<void>> getClients() {
    return _apiServices.getClients();
  }
}

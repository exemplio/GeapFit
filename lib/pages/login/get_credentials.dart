import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:sports_management/domain/access_token_response.dart';
import 'package:sports_management/domain/credential_response.dart';
import 'package:sports_management/domain/profile.dart';
import 'package:sports_management/pages/client/models/initModel.dart';
import 'package:sports_management/services/http/domain/password_grant_request.dart';
import 'package:sports_management/services/http/domain/role_request.dart';
import 'package:sports_management/services/http/result.dart';

import '../../domain/message.dart';
import '../../services/get/fingerprint_service.dart';
import '../../services/http/api_services.dart';
import '../../services/http/domain/auth_device_request.dart';
import '../../utils/encrypt_password.dart';
import '../../utils/utils.dart';

@injectable
class GetCredentials {
  final ApiServices _apiServices;
  final FingerprintService _fingerprintService;

  GetCredentials(this._apiServices, this._fingerprintService);

  Future<Result<CredentialResponse>> credentials(
      String email, String password) {
    return Future(() {
      var publicKey = MyUtils.publicKey;
      var result = Cryptom.encrypt(password, publicKey);
      Map<String, String> body = {
        "client_id": MyUtils.clientId.toString(),
        "username": email,
        "password": result
      };

      return _apiServices.credentials(body);
    });
  }

  Future<Result<AccessTokenResponse>> refreshToken(
      String accessToken, String refreshToken) {
    return _apiServices.refreshToken(accessToken, refreshToken);
  }

  Future<Result<AccessTokenResponse>> authorize(
      String clientId, String secret) {
    var auth = utf8.fuse(base64).encode("$clientId:$secret");

    return _apiServices.authorize(auth);
  }

  Future<Result<AccessTokenResponse>> passwordGrant(
      String email, String password, bool isCI) {
    return _fingerprintService.fingerprint().then((fingerprint) {
      var result = Cryptom.encrypt(password, MyUtils.publicKey);
      return PasswordGrantRequest(MyUtils.clientId, email, result, fingerprint);
    }).then((value) => _apiServices.passwordGrant(value, isCI));
  }

  Future<Result<Message>> authDevice(String accessToken) {
    return _fingerprintService
        .fingerprint()
        .then((value) => AuthDeviceRequest.check(value, "MOBILE",
            features: {"platform": "FLUTTER"}))
        .then((value) => _apiServices.authDevice(accessToken, value));
  }

  Future<Result<Profile>> profile() {
    return _apiServices.profile();
  }
  Future<Result<Init>> init(String businessId) {
    return _apiServices.init(businessId);
  }
  Future<Result<Roles>> role() {
    return _apiServices.roles();
  }
}

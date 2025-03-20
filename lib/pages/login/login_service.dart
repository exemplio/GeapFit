// ignore_for_file: depend_on_referenced_packages

import 'dart:ffi';

import 'package:geap_fit/pages/login/models/credential_model.dart';
import 'package:injectable/injectable.dart';
import 'package:geap_fit/pages/login/get_credentials.dart';
import 'package:geap_fit/utils/utils.dart';
import '../../services/cacheService.dart';
import '../../services/http/result.dart';

@injectable
class LoginService {
  final Cache _cache;
  final GetCredentials _getCredentials;
  LoginService(this._cache, this._getCredentials);

  Future<Result<Void>> passwordGrant(
    String email,
    String password,
    bool isCI,
  ) async {
    return _getCredentials
        .passwordGrant(email, password, isCI)
        .then((value) => MyUtils.nextResult(value, _authDevice));
  }

  Future<Result<CredentialModel>> _saveLastCredentials(
    Result<CredentialModel> result,
  ) async {
    var accessTokenResponse = result.obj;
    if (accessTokenResponse != null) {
      await _cache.saveLastCredentials(accessTokenResponse);
      return result;
    }

    return Result.result(result);
  }

  Future<Result<Void>> _authDevice(Result<CredentialModel> result) async {
    await _saveLastCredentials(result);
    var idToken = result.obj;
    if (idToken != null) {
      return Result.result(result);
    }

    return Result.failMsg("No hay access token para el dispositivo");
  }
}

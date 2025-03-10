// ignore_for_file: depend_on_referenced_packages

import 'dart:ffi';

import 'package:injectable/injectable.dart';
import 'package:sports_management/domain/access_token_response.dart';
import 'package:sports_management/domain/credential_response.dart';
import 'package:sports_management/pages/login/get_credentials.dart';
import 'package:sports_management/utils/utils.dart';
import '../../services/cacheService.dart';
import '../../services/http/domain/role_request.dart';
import '../../services/http/result.dart';
import '../../styles/theme_selector.dart';

@injectable
class LoginService {
  final Cache _cache;
  final GetCredentials _getCredentials;
  final ThemeSelector _themeSelector;
  LoginService(this._cache, this._getCredentials, this._themeSelector);

  Future<Result<Void>> passwordGrant(
      String email, String password, bool isCI) async {
    return _getCredentials
        .passwordGrant(email, password, isCI)
        .then((value) => MyUtils.nextResult(value, _authDevice));
  }

  Future<Result<AccessTokenResponse>> refreshToken(
      String accessToken, String refreshToken) {
    return _getCredentials
        .refreshToken(accessToken, refreshToken)
        .then((value) => MyUtils.nextResult(value, _saveAccessToken));
  }

  Future<Result<AccessTokenResponse>> _saveAccessToken(
      Result<AccessTokenResponse> result) async {
    var accessTokenResponse = result.obj;
    if (accessTokenResponse != null) {
      await _cache.saveAccessToken(accessTokenResponse);
      return result;
    }

    return Result.result(result);
  }

  Future<Result<Void>> _authDevice(Result<AccessTokenResponse> result) async {
    await _saveAccessToken(result);
    var accessToken = result.obj?.accessToken;
    if (accessToken != null) {
      return _getCredentials.authDevice(accessToken).then(Result.result);
    }

    return Result.failMsg("No hay access token para el dispositivo");
  }

  Future<Result<Void>> login(String email, String password) {
    return _getCredentials.credentials(email, password).then((result) {
      return MyUtils.nextResult(result, (result) {
        return auth(result.obj).then((value) => Result.result(value));
      });
    });
  }

  Future<Result<AccessTokenResponse>> auth(
      CredentialResponse? credentialResponse) {
    // var clientId = credentialResponse?.integration?.client?.id;

    // if (credentialResponse != null &&
    //     clientId != null &&
    //     clientSecret != null) {
    //   //  print(credentialResponse);
    //   _cache.setCacheJson("credentials", credentialResponse);
    //   return authorize(clientId, clientSecret);
    // }

    return Future.value(Result.failMsg("Este usuario no posee integración"));
  }

  Future<Result<AccessTokenResponse>> authorize(
      String clientId, String secret) {
    return _getCredentials.authorize(clientId, secret).then((result) {
      if (result.success) {
        var accessTokenResponse = result.obj;

        if (accessTokenResponse != null) {
          _cache.setCacheJson("access_token", accessTokenResponse);
        }
      }

      return result;
    });
  }

  Future<Result<Void>> saveProfile() {
    return _getCredentials.profile().then((value) {
      if (value.success) {
        var profile = value.obj;
        if (profile != null) {
          _cache.saveDeviceIsAuthorized(profile.id!);
          _themeSelector.selectThemeFromProfile(profile);
          return _cache.saveProfile(profile).then((v) => Result.result(value));
        }
      }
      return Result.result(value);
    });
  }

  Future<Result<Void>> getRole() {
    return _getCredentials.role().then((value) {
      if (value.success) {
        var role = value.obj; // ?
        if (role != null) {
          var roles = role.roles ?? [];
          if (roles.isNotEmpty) {
            var result = roles
                .where((Role role) => role.appName == "SERVICEPAY_POS")
                .first;
            if (result.businessId != null) {
              return saveInitData(result.businessId ?? "");
            }
          }
        }
      }
      return Result.result(value);
    });
  }

  Future<Result<Void>> saveInitData(String businessId) {
    return _getCredentials.init(businessId).then((value) {
      if (value.success) {
        var initData = value.obj;
        if (initData != null) {
          if (initData.profile?.id != null) {
            _cache.saveDeviceIsAuthorized(initData.profile?.id ?? "");
          }
          return _cache
              .saveInitData(initData)
              .then((v) => Result.result(value));
        }
      }
      return Result.result(value);
    });
  }
}

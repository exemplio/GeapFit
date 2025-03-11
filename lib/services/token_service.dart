import 'package:injectable/injectable.dart';
import 'package:sports_management/domain/credential_response.dart';
import 'package:sports_management/pages/login/login_service.dart';

import 'cacheService.dart';
import 'http/result.dart';

@injectable
class TokenService {
  final Cache _cache;
  final LoginService _loginService;

  TokenService(this._cache, this._loginService);

  Future<Result<String>> token() async {
    var accessTokenResponse = await _cache.getAccessTokenResponse();
    if (accessTokenResponse != null) {
      var idToken = accessTokenResponse.idToken;
      if (idToken != null) {
        {
          var refreshToken = accessTokenResponse.idToken;
          var expireDate = DateTime.fromMillisecondsSinceEpoch(565465);
          if (refreshToken != null &&
              expireDate != null &&
              expireDate.isBefore(DateTime.now())) {
            return _loginService
                .refreshToken(idToken, refreshToken)
                .then((value) {
              var token = value.obj?.idToken;
              if (token != null) {
                return Result.success(token);
              }

              return Result.result(value);
            });
          }
        }

        return Future.value(Result.success(accessTokenResponse.idToken));
      }
    }


    var credentialsJson = await _cache.getCacheJson("credentials");

    if (credentialsJson != null) {
      var credentialResponse = CredentialResponse.fromJson(credentialsJson);

      return _loginService.auth(credentialResponse).then((result) {
        if (result.success) {
          var idToken = result.obj?.idToken;
          if (idToken != null) {
            return Result.success(idToken);
          }

          return Result.failMsg("No hay access token");
        }

        return Result.result(result);
      });
    }

    return Future.value(
        Result.failMsg("No hay credenciales guardadas, inicie sesion"));
  }
}

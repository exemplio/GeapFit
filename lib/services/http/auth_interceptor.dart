// ignore_for_file: depend_on_referenced_packages

import 'package:http_interceptor/http_interceptor.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:geap_fit/services/cacheService.dart';
import 'package:geap_fit/services/token_service.dart';

import '../../utils/utils.dart';

@injectable
class AuthInterceptor implements InterceptorContract {
  final _logger = Logger();
  final TokenService _tokenService;
  final Cache _cache;

  AuthInterceptor(this._tokenService, this._cache);

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    if (data.url.contains(MyUtils.type)) {
      data.headers.update(
        "testing-id",
        (value) => MyUtils.authId,
        ifAbsent: () => MyUtils.authId,
      );
    } else {
      var resource = data.url.replaceAll(
        "https://${MyUtils.base}${MyUtils.type}",
        "",
      );

      if (!MyUtils.nonAuthServices.contains(resource)) {
        var result = await _tokenService.token();
        var idToken = result.obj;
        if (result.success && idToken != null) {
          var header = "Bearer $idToken";

          data.headers.update(
            "authorization",
            (value) => "Bearer $idToken",
            ifAbsent: () => header,
          );

          var credentialResponse = await _cache.credentialResponse();
          if (credentialResponse != null) {
            var realm = credentialResponse.profile?.realm;
            var id = credentialResponse.profile?.id;
            var email = credentialResponse.profile?.emailDeflt;
            data.params.update(
              "realm",
              (value) => realm,
              ifAbsent: () => realm,
            );
            data.params.update(
              "business_id",
              (value) => id,
              ifAbsent: () => id,
            );
            data.params.update("user_id", (value) => id, ifAbsent: () => id);
            data.params.update(
              "user_email",
              (value) => email,
              ifAbsent: () => email,
            );
          }
        } else {
          _logger.e("No hay token o credenciales $result");
        }
      }
    }

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}

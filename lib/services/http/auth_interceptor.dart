// ignore_for_file: depend_on_referenced_packages

import 'package:http_interceptor/http_interceptor.dart';
import 'package:injectable/injectable.dart';
import 'package:geap_fit/services/cacheService.dart';

import '../../utils/utils.dart';

@injectable
class AuthInterceptor implements InterceptorContract {
  final Cache _cache;

  AuthInterceptor(this._cache);

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
    }

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}

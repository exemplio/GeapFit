// ignore_for_file: depend_on_referenced_packages

import 'package:geap_fit/di/injection.dart';
import 'package:geap_fit/domain/access_token_response.dart';
import 'package:geap_fit/pages/agenda/models/store_model.dart';
import 'package:geap_fit/services/cacheService.dart';
import 'package:geap_fit/services/http/api_services.dart';
import 'package:geap_fit/services/http/domain/password_grant_request.dart';

import '../../../services/http/result.dart';

final _apiServices = getIt<ApiServices>();
final _cache = Cache();

Future<Result<AccessTokenResponse>> getInventory() async {
  var init = await _cache.getInitData();
  Map<String, String> params = {
    "realm": init?.initData?.ally?.realm ?? "",
    "business_id": init?.initData?.ally?.id ?? "",
    "type": "PAGINATE",
    "limit": "10",
  };

  return await _apiServices.passwordGrant("" as PasswordGrantRequest);
}

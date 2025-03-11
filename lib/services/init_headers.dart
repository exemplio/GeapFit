import 'package:sports_management/services/cacheService.dart';
import 'package:sports_management/utils/utils.dart';

import '../domain/access_token_response.dart';
import '../pages/client/models/initModel.dart';

final _cache = Cache();

Future<Map<String, String>> initHeaders() async {
  Map<String, String> headers = {};

  AccessTokenResponse? access = await _cache.getAccessTokenResponse();
  var token = access?.idToken;

  if(token != null){
    headers["Authorization"] = "bearer $token";
  }
  return headers;
}

Future<Map<String, String>> initParams() async {
  Init? init = await _cache.getInitData();
  Map<String, String> params = {};
  params["client_id"] = MyUtils.apiKey;
  if(init?.role?.businessId!=null){
    params["role_owner_id"] = init?.role?.businessId ?? "";
  }
  return params;
}
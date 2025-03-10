// ignore_for_file: depend_on_referenced_packages

import 'package:sports_management/di/injection.dart';
import 'package:sports_management/pages/store/models/store_model.dart';
import 'package:sports_management/services/cacheService.dart';
import 'package:sports_management/services/http/api_services.dart';

import '../../../services/http/result.dart';

final _apiServices = getIt<ApiServices>();
final _cache = Cache();

Future<Result<InventoryModel>> getInventory() async {
  var init = await _cache.getInitData();
  Map<String, String> params = {
    "realm": init?.initData?.ally?.realm ?? "",
    "business_id": init?.initData?.ally?.id ?? "",
    "type": "PAGINATE",
    "limit": "10",
  };

  return await _apiServices.inventory(params: params);
}

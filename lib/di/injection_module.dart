import 'package:injectable/injectable.dart';
import 'package:geap_fit/services/http/http_service.dart';
import 'package:geap_fit/services/http/service_module.dart';

@module
abstract class InjectionModule {

  @lazySingleton
  HttpService get httpService => ServiceModule.httpService();

  /*@preResolve
  Future<SharedPreferences> get prefs => MyUtils.prefs();*/
}

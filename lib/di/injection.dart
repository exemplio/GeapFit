import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:geap_fit/di/injection.config.dart';

GetIt getIt = GetIt.instance;

@injectableInit
Future<void> configureInjection(String environment) async =>
    getIt.init(environment: environment);

abstract class Env {
  static const demo = 'demo';
}

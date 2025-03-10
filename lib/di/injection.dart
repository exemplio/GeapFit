import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_management/di/injection.config.dart';

GetIt getIt = GetIt.instance;

@injectableInit
Future<void> configureInjection(String environment) async =>
    getIt.init(environment: environment);

abstract class Env {
  static const demo = 'demo';
  static const qa = 'qa';
  static const prod = 'prod';
  static const dev = 'dev';
}

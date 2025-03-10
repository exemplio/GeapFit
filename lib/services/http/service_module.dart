// ignore_for_file: depend_on_referenced_packages

import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:sports_management/di/injection.dart';
import 'package:sports_management/services/http/auth_interceptor.dart';
import 'package:sports_management/services/http/http_service.dart';

import 'logging_interceptor.dart';

class ServiceModule {
  static HttpService httpService() {
    return HttpService(() => client());
  }
  static HttpService testHttpService() {
    return HttpService(() => testClient());
  }

  static Client client() {
    return InterceptedClient.build(
        requestTimeout: const Duration(minutes: 3),
        interceptors: [
          getIt<AuthInterceptor>(),
          LoggingInterceptor(),
        ]);
  }

  static Client testClient() {
    return InterceptedClient.build(
        requestTimeout: const Duration(minutes: 3),
        interceptors: [
          LoggingInterceptor(),
        ]);
  }
}

// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:geap_fit/domain/credentialModel.dart';
import 'package:geap_fit/pages/logout/logout_service.dart';
import 'package:geap_fit/services/cacheService.dart';
import 'package:geap_fit/services/http/result.dart';
import 'package:geap_fit/utils/get_credentials.dart';

import '../../styles/theme_provider.dart';

part 'logout_event.dart';
part 'logout_state.dart';

@injectable
class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final _logger = Logger();
  final LogoutService _logoutService;
  final ThemeProvider themeProvider;
  final Cache _cache;

  LogoutBloc(this._logoutService, this._cache, this.themeProvider)
    : super(const LogoutInitial()) {
    on<LogoutEvent>((event, emit) async {
      switch (event.runtimeType) {
        case InitEvent:
          emit(const LogoutInitial());
          break;
        case ExecuteLogoutEvent:
          _logger.i("CLOSE SESSION");
          await themeProvider.setDfltTheme();
          String? keep = await cache.getKeepLastSession();
          if (keep != null) {
            keep = keep.replaceAll('"', '');
          }
          CredentialModel? credentialModel = await cache.getLastCredentials();

          unawaited(
            _logoutService
                .closeSession()
                .onError((error, stackTrace) => Result.fail(error, stackTrace))
                .then((value) async {
                  await _cache.emptyCacheData();
                  cache.saveKeepLastSession(keep ?? "MANTENER");
                  cache.saveLastCredentials(
                    credentialModel ?? CredentialModel(email: "", password: ""),
                  );
                }),
          );
          _logger.i("GotoLoginState");
          emit(const GotoLoginState());
          break;
      }
    });
  }
}

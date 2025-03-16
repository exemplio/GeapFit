// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geap_fit/pages/business/business_service.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:geap_fit/domain/credentialModel.dart';
import 'package:geap_fit/services/cacheService.dart';
import 'package:geap_fit/services/http/result.dart';
import 'package:geap_fit/utils/get_credentials.dart';

import '../../styles/theme_provider.dart';

part 'business_event.dart';
part 'business_state.dart';

@injectable
class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  final _logger = Logger();
  final BusinessService _businessService;
  final ThemeProvider themeProvider;
  final Cache _cache;

  BusinessBloc(this._businessService, this._cache, this.themeProvider)
    : super(const BusinessInitial()) {
    on<BusinessEvent>((event, emit) async {
      switch (event.runtimeType) {
        case InitEvent:
          emit(const BusinessInitial());
          break;
        case ExecuteBusinessEvent:
          _logger.i("CLOSE SESSION");
          await themeProvider.setDfltTheme();
          String? keep = await cache.getKeepLastSession();
          if (keep != null) {
            keep = keep.replaceAll('"', '');
          }
          CredentialModel? credentialModel = await cache.getLastCredentials();

          unawaited(
            _businessService
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

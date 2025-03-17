// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:geap_fit/di/injection_module.dart' as _i427;
import 'package:geap_fit/pages/bottom_nav/bottom_nav_bloc.dart' as _i1051;
import 'package:geap_fit/pages/login/get_credentials.dart' as _i404;
import 'package:geap_fit/pages/login/login_bloc.dart' as _i127;
import 'package:geap_fit/pages/login/login_service.dart' as _i596;
import 'package:geap_fit/pages/register/register_bloc.dart' as _i17;
import 'package:geap_fit/pages/register/register_service.dart' as _i851;
import 'package:geap_fit/services/cacheService.dart' as _i99;
import 'package:geap_fit/services/get/fingerprint_service.dart' as _i256;
import 'package:geap_fit/services/http/api_services.dart' as _i281;
import 'package:geap_fit/services/http/auth_interceptor.dart' as _i303;
import 'package:geap_fit/services/http/cache_online_provider.dart' as _i323;
import 'package:geap_fit/services/http/http_service.dart' as _i989;
import 'package:geap_fit/services/http/is_online_provider.dart' as _i716;
import 'package:geap_fit/services/token_service.dart' as _i636;
import 'package:geap_fit/styles/profile_theme_selector.dart' as _i604;
import 'package:geap_fit/styles/theme_holder.dart' as _i1052;
import 'package:geap_fit/styles/theme_loader.dart' as _i339;
import 'package:geap_fit/styles/theme_provider.dart' as _i287;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final injectionModule = _$InjectionModule();
    gh.factory<_i99.Cache>(() => _i99.Cache());
    gh.factory<_i256.FingerprintService>(() => _i256.FingerprintService());
    gh.factory<_i604.ProfileThemeSelector>(() => _i604.ProfileThemeSelector());
    gh.factory<_i339.ThemeLoader>(() => _i339.ThemeLoader());
    gh.lazySingleton<_i989.HttpService>(() => injectionModule.httpService);
    gh.factory<_i1051.BottomNavBloc>(
      () => _i1051.BottomNavBloc(gh<_i99.Cache>()),
    );
    gh.singleton<_i1052.ThemeHolder>(
      () => _i1052.ThemeHolder(gh<_i339.ThemeLoader>()),
    );
    gh.factory<_i716.IsOnlineProvider>(
      () => _i323.CacheOnlineProvider(gh<_i99.Cache>()),
    );
    gh.singleton<_i287.ThemeProvider>(
      () => _i287.ThemeProvider(gh<_i1052.ThemeHolder>()),
    );
    gh.factory<_i281.ApiServices>(
      () => _i281.ApiServices(
        gh<_i989.HttpService>(),
        gh<_i716.IsOnlineProvider>(),
      ),
    );
    gh.factory<_i404.GetCredentials>(
      () => _i404.GetCredentials(gh<_i281.ApiServices>()),
    );
    gh.factory<_i596.LoginService>(
      () => _i596.LoginService(gh<_i99.Cache>(), gh<_i404.GetCredentials>()),
    );
    gh.factory<_i127.LoginScreenBloc>(
      () => _i127.LoginScreenBloc(gh<_i596.LoginService>()),
    );
    gh.factory<_i636.TokenService>(
      () => _i636.TokenService(gh<_i99.Cache>(), gh<_i596.LoginService>()),
    );
    gh.factory<_i851.RegisterService>(
      () => _i851.RegisterService(
        gh<_i281.ApiServices>(),
        gh<_i636.TokenService>(),
      ),
    );
    gh.factory<_i303.AuthInterceptor>(
      () => _i303.AuthInterceptor(gh<_i636.TokenService>(), gh<_i99.Cache>()),
    );
    gh.factory<_i17.RegisterBloc>(
      () => _i17.RegisterBloc(
        gh<_i851.RegisterService>(),
        gh<_i287.ThemeProvider>(),
      ),
    );
    return this;
  }
}

class _$InjectionModule extends _i427.InjectionModule {}

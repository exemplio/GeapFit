// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:sports_management/di/injection_module.dart' as _i24;
import 'package:sports_management/pages/auth_device/auth_device_bloc.dart'
    as _i22;
import 'package:sports_management/pages/auth_device/auth_device_service.dart'
    as _i18;
import 'package:sports_management/pages/bottom_nav/bottom_nav_bloc.dart'
    as _i11;
import 'package:sports_management/pages/login/get_credentials.dart' as _i12;
import 'package:sports_management/pages/login/login_bloc.dart' as _i20;
import 'package:sports_management/pages/login/login_service.dart' as _i16;
import 'package:sports_management/pages/logout/logout_bloc.dart' as _i23;
import 'package:sports_management/pages/logout/logout_service.dart' as _i21;
import 'package:sports_management/services/cacheService.dart' as _i3;
import 'package:sports_management/services/get/fingerprint_service.dart'
    as _i4;
import 'package:sports_management/services/http/api_services.dart' as _i10;
import 'package:sports_management/services/http/auth_interceptor.dart'
    as _i19;
import 'package:sports_management/services/http/cache_online_provider.dart'
    as _i7;
import 'package:sports_management/services/http/http_service.dart' as _i5;
import 'package:sports_management/services/http/is_online_provider.dart'
    as _i6;
import 'package:sports_management/services/token_service.dart' as _i17;
import 'package:sports_management/styles/profile_theme_selector.dart' as _i8;
import 'package:sports_management/styles/theme_holder.dart' as _i13;
import 'package:sports_management/styles/theme_loader.dart' as _i9;
import 'package:sports_management/styles/theme_provider.dart' as _i14;
import 'package:sports_management/styles/theme_selector.dart' as _i15;

import 'package:sports_management/pages/register/register_service.dart'
    as _i25;
import 'package:sports_management/pages/register/register_bloc.dart' as _i26;
import 'package:sports_management/pages/withdraw/bloc/withdraw_bloc.dart'
    as _i46;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final injectionModule = _$InjectionModule();
    gh.factory<_i3.Cache>(() => _i3.Cache());
    gh.factory<_i4.FingerprintService>(() => _i4.FingerprintService());
    gh.lazySingleton<_i5.HttpService>(() => injectionModule.httpService);
    gh.factory<_i6.IsOnlineProvider>(
        () => _i7.CacheOnlineProvider(gh<_i3.Cache>()));
    gh.factory<_i8.ProfileThemeSelector>(() => _i8.ProfileThemeSelector());
    gh.factory<_i9.ThemeLoader>(() => _i9.ThemeLoader());
    gh.factory<_i10.ApiServices>(() => _i10.ApiServices(
          gh<_i5.HttpService>(),
          gh<_i6.IsOnlineProvider>(),
        ));
    gh.factory<_i11.BottomNavBloc>(() => _i11.BottomNavBloc(gh<_i3.Cache>()));
    gh.factory<_i12.GetCredentials>(() => _i12.GetCredentials(
          gh<_i10.ApiServices>(),
          gh<_i4.FingerprintService>(),
        ));
    gh.singleton<_i13.ThemeHolder>(() => _i13.ThemeHolder(gh<_i9.ThemeLoader>()));
    gh.singleton<_i14.ThemeProvider>(() => _i14.ThemeProvider(gh<_i13.ThemeHolder>()));
    gh.factory<_i15.ThemeSelector>(
        () => _i15.ThemeSelector(gh<_i14.ThemeProvider>()));
    gh.factory<_i16.LoginService>(() => _i16.LoginService(
          gh<_i3.Cache>(),
          gh<_i12.GetCredentials>(),
          gh<_i15.ThemeSelector>(),
        ));
    gh.factory<_i17.TokenService>(() => _i17.TokenService(
          gh<_i3.Cache>(),
          gh<_i16.LoginService>(),
        ));
    gh.factory<_i18.AuthDeviceService>(() => _i18.AuthDeviceService(
          gh<_i17.TokenService>(),
          gh<_i10.ApiServices>(),
          gh<_i4.FingerprintService>(),
        ));
    gh.factory<_i19.AuthInterceptor>(() => _i19.AuthInterceptor(
          gh<_i17.TokenService>(),
          gh<_i3.Cache>(),
        ));
    gh.factory<_i20.LoginScreenBloc>(() => _i20.LoginScreenBloc(
          gh<_i16.LoginService>(),
        ));
    gh.factory<_i21.LogoutService>(() => _i21.LogoutService(
          gh<_i10.ApiServices>(),
          gh<_i17.TokenService>(),
        ));
    gh.factory<_i22.AuthDeviceBloc>(() => _i22.AuthDeviceBloc(
          gh<_i18.AuthDeviceService>(),
          gh<_i16.LoginService>(),
        ));
    gh.factory<_i23.LogoutBloc>(() => _i23.LogoutBloc(
          gh<_i21.LogoutService>(),
          gh<_i3.Cache>(),
          gh<_i14.ThemeProvider>(),
        ));
    gh.factory<_i25.RegisterService>(() => _i25.RegisterService(
          gh<_i10.ApiServices>(),
          gh<_i17.TokenService>(),
        ));
    gh.factory<_i46.WithdrawBloc>(() => _i46.WithdrawBloc());
    gh.factory<_i26.RegisterBloc>(() => _i26.RegisterBloc(
          gh<_i25.RegisterService>(),
          gh<_i14.ThemeProvider>(),
        ));
    return this;
  }
}

class _$InjectionModule extends _i24.InjectionModule {}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geap_fit/di/injection.dart';
import 'package:geap_fit/pages/login/login_bloc.dart';
import 'package:geap_fit/pages/logout/logout_bloc.dart';
import 'package:geap_fit/pages/register/register_bloc.dart';


List<BlocProvider> blocProviders = [

  BlocProvider<LogoutBloc>(create: (context) => getIt<LogoutBloc>()),
  BlocProvider<LoginScreenBloc>(create: (context) => getIt<LoginScreenBloc>()),
  BlocProvider<RegisterBloc>(create: (context) => getIt<RegisterBloc>()),
];

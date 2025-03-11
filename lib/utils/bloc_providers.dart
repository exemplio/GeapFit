import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_management/di/injection.dart';
import 'package:sports_management/pages/login/login_bloc.dart';
import 'package:sports_management/pages/logout/logout_bloc.dart';
import 'package:sports_management/pages/register/register_bloc.dart';


List<BlocProvider> blocProviders = [

  BlocProvider<LogoutBloc>(create: (context) => getIt<LogoutBloc>()),
  BlocProvider<LoginScreenBloc>(create: (context) => getIt<LoginScreenBloc>()),
  BlocProvider<RegisterBloc>(create: (context) => getIt<RegisterBloc>()),
];

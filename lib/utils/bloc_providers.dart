import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geap_fit/di/injection.dart';
import 'package:geap_fit/pages/login/login_bloc.dart';
import 'package:geap_fit/pages/register/register_bloc.dart';

List<BlocProvider> blocProviders = [
  BlocProvider<LoginScreenBloc>(create: (context) => getIt<LoginScreenBloc>()),
  BlocProvider<RegisterBloc>(create: (context) => getIt<RegisterBloc>()),
];

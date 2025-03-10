// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:sports_management/di/injection.dart';
import 'package:sports_management/services/http/dev_http_overrides.dart';
import 'package:sports_management/services/http/network_connectivity.dart';
import 'package:sports_management/styles/theme_provider.dart';
import 'package:sports_management/utils/bloc_providers.dart';
import 'package:sports_management/utils/utils.dart';
import 'package:provider/provider.dart';
import 'routes/routes.dart';
import 'services/cacheService.dart';

String environment = "";

void mainCommon(String env) async {
  environment = env;
  WidgetsFlutterBinding.ensureInitialized();

  await configureInjection(env);

  // Pass all uncaught "fatal" errors from the framework to Crashlytics

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics

  if (MyUtils.disableSslVerification) {
    HttpOverrides.global = DevHttpOverrides();
  }

  final networkConnectivity = NetworkConnectivity.instance;
  networkConnectivity.initialise();
  networkConnectivity.stream
      .listen((event) => getIt<Cache>().saveNetworkState(event));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await getIt<ThemeProvider>().loadThemes();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _logger = Logger();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProviders,
      child: ChangeNotifierProvider(
          create: (context) => getIt<ThemeProvider>(),
          child: Consumer<ThemeProvider>(builder: (context, state, child) {
            _logger.i("app_theme_name ${state.appTheme().name}");
            return MaterialApp.router(
              theme: state.theme(),
              locale: const Locale('es'),
              debugShowCheckedModeBanner: false,
              routerConfig: router,
            );
          })),
    );
  }
}

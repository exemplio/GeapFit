// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geap_fit/di/injection.dart';
import 'package:geap_fit/services/http/dev_http_overrides.dart';
import 'package:geap_fit/services/http/network_connectivity.dart';
import 'package:geap_fit/utils/bloc_providers.dart';
import 'package:geap_fit/utils/utils.dart';
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
  networkConnectivity.stream.listen(
    (event) => getIt<Cache>().saveNetworkState(event),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // await getIt<ThemeProvider>().loadThemes();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProviders,
      child: MaterialApp.router(
        theme: ThemeData.light(), // Light theme
        darkTheme: ThemeData.dark(), // Dark theme
        themeMode: ThemeMode.system,
        locale: const Locale('es'),
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}

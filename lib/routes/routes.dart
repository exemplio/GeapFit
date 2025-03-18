// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:geap_fit/pages/business/business_bloc.dart';
import 'package:geap_fit/pages/business/business_screen.dart';
import 'package:geap_fit/pages/chat/chat_bloc.dart';
import 'package:geap_fit/pages/chat/chat_screen.dart';
import 'package:geap_fit/pages/library/library_bloc.dart';
import 'package:geap_fit/pages/library/library_service.dart';
import 'package:geap_fit/pages/message/message_bloc.dart';
import 'package:geap_fit/pages/message/message_screen.dart';
import 'package:geap_fit/services/http/domain/productModel.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:geap_fit/pages/pages.dart';
import 'package:geap_fit/pages/agenda/agenda_bloc.dart';
import 'package:geap_fit/pages/agenda/models/store_model.dart';
import 'package:geap_fit/utils/global.dart';
import 'package:geap_fit/utils/staticNamesRoutes.dart';
import '../di/injection.dart';
import '../pages/bottom_nav/bottom_nav.dart';
import '../pages/bottom_nav/bottom_nav_bloc.dart';
import '../pages/client/client_bloc.dart';
import '../services/cacheService.dart';

final _rootNavigatorKey = Globalkeys.rootNavigatorKey;
final _shellNavigatorKey = Globalkeys.shellNavigatorKey;

final _logger = Logger();

class Routes extends StatefulWidget {
  const Routes({Key? key}) : super(key: key);

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: const Locale('es'),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}

GoRoute rootRoute() {
  return GoRoute(
    path: StaticNames.rootName.path,
    redirect: (context, state) async {
      bool isLoggedIn = await getIt<Cache>().areCredentialsStored();
      _logger.i("tienes credenciales? $isLoggedIn");
      return isLoggedIn ? StaticNames.clients.path : StaticNames.loginName.path;
    },
  );
}

final GoRouter router = GoRouter(
  initialLocation: StaticNames.rootName.path,
  navigatorKey: _rootNavigatorKey,
  routes: [
    rootRoute(),
    GoRoute(
      path: StaticNames.loginName.path,
      name: StaticNames.loginName.name,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        _logger.i(state.location);
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: StaticNames.emailFormName.path,
      name: StaticNames.emailFormName.name,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        _logger.i(state.location);
        return EmailForm(title: state.extra.toString());
      },
    ),
    GoRoute(
      path: StaticNames.registerName.path,
      name: StaticNames.registerName.name,
      builder: (context, state) {
        _logger.i(state.location);
        return const RegisterScreen();
      },
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return BottomNavScreen(bloc: getIt<BottomNavBloc>(), child: child);
      },
      routes: [
        GoRoute(
          name: StaticNames.clients.name,
          parentNavigatorKey: _shellNavigatorKey,
          path: StaticNames.clients.path,
          builder: (context, state) {
            _logger.i(state.location);
            return ClientScreen(bloc: ClientEqBloc());
          },
        ),
        GoRoute(
          name: StaticNames.agenda.name,
          parentNavigatorKey: _shellNavigatorKey,
          path: StaticNames.agenda.path,
          builder: (context, state) {
            _logger.i(state.location);
            // ApiServices ;
            return AgendaScreen(bloc: AgendaBloc());
          },
        ),
        GoRoute(
          name: StaticNames.library.name,
          parentNavigatorKey: _shellNavigatorKey,
          path: StaticNames.library.path,
          builder: (context, state) {
            _logger.i(state.location);
            // ApiServices ;
            return LibraryScreen(bloc: LibraryBloc());
          },
        ),
        GoRoute(
          name: StaticNames.business.name,
          parentNavigatorKey: _shellNavigatorKey,
          path: StaticNames.business.path,
          builder: (context, state) {
            _logger.i(state.location);
            // ApiServices ;
            return BusinessScreen(bloc: BusinessBloc());
          },
        ),
        GoRoute(
          name: StaticNames.chat.name,
          parentNavigatorKey: _shellNavigatorKey,
          path: StaticNames.chat.path,
          builder: (context, state) {
            _logger.i(state.location);
            // ApiServices ;
            return ChatScreen(bloc: ChatBloc());
          },
          routes: [
            GoRoute(
              parentNavigatorKey: _shellNavigatorKey,
              name: StaticNames.message.name,
              path: StaticNames.message.path,
              builder: (context, state) {
                _logger.i(state.location);
                var product = state.extra;
                // _logger.i(product.formattedName);
                return MessageScreen(bloc: MessageBloc());
              },
            ),
          ],
        ),
      ],
    ),
  ],
);

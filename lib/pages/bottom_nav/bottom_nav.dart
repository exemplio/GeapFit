// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:sports_management/utils/staticNamesRoutes.dart';

import '../../widgets/tabs.dart';
import 'bottom_nav_bloc.dart';

class BottomNavScreen extends StatefulWidget {
  final BottomNavBloc bloc;

  const BottomNavScreen({Key? key, required this.child, required this.bloc})
      : super(key: key);
  final Widget child;

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen>
    with WidgetsBindingObserver {
  // ignore: unused_field
  AppLifecycleState? _lastLifecycleState;
  final _logger = Logger();

  List<ScaffoldWithNavBarTabItem> tabs = [
    ScaffoldWithNavBarTabItem(
        initialLocation: StaticNames.salesName.path,
        icon: const Icon(Icons.point_of_sale_sharp),
        label: "Clientes"),
    ScaffoldWithNavBarTabItem(
        initialLocation: StaticNames.store.path,
        icon: const Icon(Icons.store),
        label: "Agenda"),
    ScaffoldWithNavBarTabItem(
        initialLocation: StaticNames.logoutName.path,
        icon: const Icon(Icons.exit_to_app),
        label: "Librería"),
    ScaffoldWithNavBarTabItem(
        initialLocation: StaticNames.logoutName.path,
        icon: const Icon(Icons.exit_to_app),
        label: "Negocio"),
    ScaffoldWithNavBarTabItem(
        initialLocation: StaticNames.logoutName.path,
        icon: const Icon(Icons.exit_to_app),
        label: "Chat"),
  ];

  List<NavigationDestinationTabItem> destinations = [
    NavigationDestinationTabItem(
      initialLocation: StaticNames.salesName.path,
      selectedIcon: const Icon(Icons.photo_camera_front_outlined),
      icon: const Icon(Icons.photo_camera_front_outlined),
      label: "Clientes",
    ),
    NavigationDestinationTabItem(
      initialLocation: StaticNames.store.path,
      selectedIcon: const Icon(Icons.view_agenda),
      icon: const Icon(Icons.view_agenda),
      label: "Agenda",
    ),
    NavigationDestinationTabItem(
      initialLocation: StaticNames.logoutName.path,
      selectedIcon: const Icon(Icons.library_books),
      icon: const Icon(Icons.library_books),
      label: "Librería",
    ),
    NavigationDestinationTabItem(
      initialLocation: StaticNames.logoutName.path,
      selectedIcon: const Icon(Icons.business),
      icon: const Icon(Icons.business),
      label: "Negocio",
    ),
    NavigationDestinationTabItem(
      initialLocation: StaticNames.logoutName.path,
      selectedIcon: const Icon(Icons.chat),
      icon: const Icon(Icons.chat),
      label: "Chat",
    ),
  ];

  int get _currentIndex => _locationToTabIndex(GoRouter.of(context).location);

  int _locationToTabIndex(String location) {
    final index =
        tabs.indexWhere((t) => location.startsWith(t.initialLocation));
    return index < 0 ? 0 : index;
  }

  void _onDestinationTapped(BuildContext context, int tabIndex) {
    //print(destinations[tabIndex].initialLocation);
    context.go(destinations[tabIndex].initialLocation);
  }

  BottomNavBloc _bloc() {
    return widget.bloc;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bloc().init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _logger.i("$state");
    _lastLifecycleState = state;

    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _disconnectDevice();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _disconnectDevice() {
    _bloc().disconnectDevice();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BottomNavBloc, BottomNavState>(
      bloc: _bloc(),
      listener: (context, state) {},
      builder: (context, state) {
        if (true) {
          return Scaffold(
              resizeToAvoidBottomInset: false,
              body: widget.child,
              bottomNavigationBar: NavigationBar(
                onDestinationSelected: (index) =>
                    _onDestinationTapped(context, index),
                selectedIndex: _currentIndex,
                destinations: destinations,
              ));
        }
      },
    );
  }
}

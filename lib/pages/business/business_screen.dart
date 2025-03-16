// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geap_fit/pages/library/library_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:geap_fit/pages/library/library_bloc.dart';
import 'package:geap_fit/styles/bg.dart';
import 'package:geap_fit/styles/text.dart';
import 'package:geap_fit/utils/staticNamesRoutes.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final _logger = Logger();

  // final _cache = Cache();

  Widget buttonText = Text(
    "CERRAR SESIÓN",
    style: subtitleStyleText("white", 15),
  );

  @override
  void initState() {
    _bloc().add(const InitEvent());
    super.initState();
  }

  void executeLibraryEvent() {
    _bloc().add(const ExecuteLibraryEvent());
  }

  void closeSession() {
    setState(() {
      buttonText = const SizedBox(
        width: 25,
        height: 25,
        child: CircularProgressIndicator(color: ColorUtil.white),
      );
    });
    executeLibraryEvent();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LibraryBloc, LibraryState>(
      bloc: _bloc(),
      listener: (context, state) {
        if (state is GotoLoginState) {
          _logger.i("Going to login");
          context.go(StaticNames.loginName.path);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: const Text(
              "GEAP FIT",
              style: TitleTextStyle(fontSize: 24, color: ColorUtil.white),
            ),
            centerTitle: true,
          ),
          body: const Center(child: Text("Pantalla testing")),
        );
      },
    );
  }

  LibraryBloc _bloc() {
    return context.read<LibraryBloc>();
  }
}

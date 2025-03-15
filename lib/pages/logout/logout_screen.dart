// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:geap_fit/pages/logout/logout_bloc.dart';
import 'package:geap_fit/styles/bg.dart';
import 'package:geap_fit/styles/text.dart';
import 'package:geap_fit/utils/staticNamesRoutes.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  final _logger = Logger();

  // final _cache = Cache();

  Widget buttonText =
      Text("CERRAR SESIÓN", style: subtitleStyleText("white", 15));

  @override
  void initState() {
    _bloc().add(const InitEvent());
    super.initState();
  }

  void executeLogoutEvent() {
    _bloc().add(const ExecuteLogoutEvent());
  }

  void closeSession() {
    setState(() {
      buttonText = const SizedBox(
        width: 25,
        height: 25,
        child: CircularProgressIndicator(color: ColorUtil.white),
      );
    });
    executeLogoutEvent();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogoutBloc, LogoutState>(
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
          "SPORT",
          style: TitleTextStyle(fontSize: 24, color: ColorUtil.white),
        ),
        centerTitle: true,
      ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            margin: const EdgeInsets.fromLTRB(1, 15, 4, 5),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: ColorUtil.error,
                                    padding: const EdgeInsets.all(20)),
                                onPressed: closeSession,
                                child: buttonText))),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  LogoutBloc _bloc() {
    return context.read<LogoutBloc>();
  }
}

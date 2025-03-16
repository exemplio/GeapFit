// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geap_fit/pages/chat/chat_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:geap_fit/pages/chat/chat_bloc.dart';
import 'package:geap_fit/styles/bg.dart';
import 'package:geap_fit/styles/text.dart';
import 'package:geap_fit/utils/staticNamesRoutes.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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

  void executeChatEvent() {
    _bloc().add(const ExecuteChatEvent());
  }

  void closeSession() {
    setState(() {
      buttonText = const SizedBox(
        width: 25,
        height: 25,
        child: CircularProgressIndicator(color: ColorUtil.white),
      );
    });
    executeChatEvent();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
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

  ChatBloc _bloc() {
    return context.read<ChatBloc>();
  }
}

// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geap_fit/pages/client/models/user_model.dart';

import '../../di/injection.dart';
import '../../services/http/api_services.dart';

part 'chat_state.dart';
part 'chat_event.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final _apiServices = getIt<ApiServices>();
  List<Fields> chat = [];

  ChatBloc() : super(ChatInitialState()) {
    on<ChatEvent>((event, emitter) async {
      switch (event.runtimeType) {
        case ChatInitialEvent:
          if (chat.isNotEmpty) {
            emitter(ChatLoadedProductState(chat: chat));
          } else {
            emitter(ChatLoadingProductState());
            getUsers();
          }
          break;
        case ChatErrorEvent:
          emitter(ChatErrorProductState());
          break;
        case ChatLoadedEvent:
          emitter(ChatLoadedProductState(chat: chat));
          break;
        case ChatRefreshEvent:
          chat = [];
          emitter(ChatLoadingProductState());
          getUsers();
          break;
      }
    });
  }
  void init() {
    chat = [];
    add(ChatInitialEvent());
  }

  Future<void> getUsers() async {
    add(ChatLoadingEvent());
    var initData = await _apiServices.getClients();
    List<Document>? saveInitData;
    saveInitData = initData.obj?.documents;
    List<Document> users = [];
    if (saveInitData != null) {
      for (var element in saveInitData) {
        users.add(element);
      }
    }
    if (users.isEmpty) {
      add(ChatErrorEvent());
    }
    if (users.isNotEmpty) {
      chat = [];
      for (var inv in users) {
        if (inv.fields != null) {
          chat.add(inv.fields!);
          // chat = inv.fields as List<Fields>? ?? [];
          add(ChatLoadedEvent());
        }
      }
      // chat = MyUtils.orderList(chat);
    }
  }
}

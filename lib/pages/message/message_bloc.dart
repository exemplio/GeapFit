// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geap_fit/pages/client/models/userModel.dart';

import '../../di/injection.dart';
import '../../services/http/api_services.dart';

part 'message_state.dart';
part 'message_event.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final _apiServices = getIt<ApiServices>();
  List<Fields> message = [];

  MessageBloc() : super(MessageInitialState()) {
    on<MessageEvent>((event, emitter) async {
      print("<-------------------->");
      print(event.runtimeType);
      print("<-------------------->");
      switch (event.runtimeType) {
        case MessageInitialEvent:
          if (message.isNotEmpty) {
            emitter(MessageLoadedProductState(message: message));
          } else {
            emitter(MessageLoadingProductState());
            getUsers();
          }
          break;
        case MessageErrorEvent:
          emitter(MessageErrorProductState());
          break;
        case MessageLoadedEvent:
          emitter(MessageLoadedProductState(message: message));
          break;
        case MessageRefreshEvent:
          message = [];
          emitter(MessageLoadingProductState());
          // getUsers();
          break;
      }
    });
  }
  void init() {
    message = [];
    add(MessageInitialEvent());
  }

  Future<void> getUsers() async {
    add(MessageLoadingEvent());

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
      add(MessageErrorEvent());
    }

    if (users.isNotEmpty) {
      message = [];
      for (var inv in users) {
        if (inv.fields != null) {
          message.add(inv.fields!);
          // message = inv.fields as List<Fields>? ?? [];
          add(MessageLoadedEvent());
        }
      }
      // message = MyUtils.orderList(message);
    }
  }
}

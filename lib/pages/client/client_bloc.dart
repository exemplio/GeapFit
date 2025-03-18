// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../di/injection.dart';
import '../../services/cacheService.dart';
import '../../services/http/api_services.dart';
import 'models/userModel.dart';

part 'client_state.dart';
part 'client_event.dart';

class ClientEqBloc extends Bloc<ClientEqEvent, ClientEqState> {
  final _apiServices = getIt<ApiServices>();
  List<Fields> usuarios = [];

  ClientEqBloc() : super(ClientInitialState()) {
    on<ClientEqEvent>((event, emitter) async {
      switch (event.runtimeType) {
        case ClientInitialEvent:
          if (usuarios.isNotEmpty) {
            emitter(ClientLoadedProductState(usuarios: usuarios));
          } else {
            emitter(ClientLoadingProductState());
            getUsers();
          }
          break;
        case ClientErrorEvent:
          emitter(ClientErrorProductState());
          break;
        case ClientLoadedEvent:
          emitter(ClientLoadedProductState(usuarios: usuarios));
          break;
        case ClientRefreshEvent:
          usuarios = [];
          emitter(ClientLoadingProductState());
          getUsers();
          break;
      }
    });
  }
  void init() {
    usuarios = [];
    add(ClientInitialEvent());
  }

  Future<void> getUsers() async {
    add(ClientLoadingEvent());

    var initData = await _apiServices.getClients();

    List<Document>? saveInitData;
    saveInitData = initData.obj?.documents;
    List<Document> usersJson = [];
    if (saveInitData != null) {
      for (var element in saveInitData) {
        usersJson.add(element);
      }
    }

    if (usersJson.isEmpty) {
      add(ClientErrorEvent());
    }

    if (usersJson.isNotEmpty) {
      usuarios = [];
      for (var inv in usersJson) {
        if (inv.fields != null) {
          usuarios.add(inv.fields!);
          // usuarios = inv.fields as List<Fields>? ?? [];
          add(ClientLoadedEvent());
        }
      }
      // usuarios = MyUtils.orderList(usuarios);
    }
  }
}

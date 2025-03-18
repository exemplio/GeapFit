// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geap_fit/pages/client/models/userModel.dart';

import '../../di/injection.dart';
import '../../services/http/api_services.dart';

part 'agenda_state.dart';
part 'agenda_event.dart';

class AgendaBloc extends Bloc<AgendaEvent, AgendaState> {
  final _apiServices = getIt<ApiServices>();
  List<Fields> agenda = [];

  AgendaBloc() : super(AgendaInitialState()) {
    on<AgendaEvent>((event, emitter) async {
      switch (event.runtimeType) {
        case AgendaInitialEvent:
          if (agenda.isNotEmpty) {
            emitter(AgendaLoadedProductState(agenda: agenda));
          } else {
            emitter(AgendaLoadingProductState());
            getUsers();
          }
          break;
        case AgendaErrorEvent:
          emitter(AgendaErrorProductState());
          break;
        case AgendaLoadedEvent:
          emitter(AgendaLoadedProductState(agenda: agenda));
          break;
        case AgendaRefreshEvent:
          agenda = [];
          emitter(AgendaLoadingProductState());
          getUsers();
          break;
      }
    });
  }

  void init() {
    agenda = [];
    add(AgendaInitialEvent());
  }

  Future<void> getUsers() async {
    add(AgendaLoadingEvent());
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
      add(AgendaErrorEvent());
    }
    if (users.isNotEmpty) {
      agenda = [];
      for (var inv in users) {
        if (inv.fields != null) {
          agenda.add(inv.fields!);
          // agenda = inv.fields as List<Fields>? ?? [];
          add(AgendaLoadedEvent());
        }
      }
      // agenda = MyUtils.orderList(agenda);
    }
  }
}

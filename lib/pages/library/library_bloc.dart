// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geap_fit/pages/client/models/user_model.dart';

import '../../di/injection.dart';
import '../../services/http/api_services.dart';

part 'library_state.dart';
part 'library_event.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final _apiServices = getIt<ApiServices>();
  List<Fields> library = [];

  LibraryBloc() : super(LibraryInitialState()) {
    on<LibraryEvent>((event, emitter) async {
      switch (event.runtimeType) {
        case LibraryInitialEvent:
          if (library.isNotEmpty) {
            emitter(LibraryLoadedProductState(library: library));
          } else {
            emitter(LibraryLoadingProductState());
            getUsers();
          }
          break;
        case LibraryErrorEvent:
          emitter(LibraryErrorProductState());
          break;
        case LibraryLoadedEvent:
          emitter(LibraryLoadedProductState(library: library));
          break;
        case LibraryRefreshEvent:
          library = [];
          emitter(LibraryLoadingProductState());
          getUsers();
          break;
      }
    });
  }
  void init() {
    library = [];
    add(LibraryInitialEvent());
  }

  Future<void> getUsers() async {
    add(LibraryLoadingEvent());
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
      add(LibraryErrorEvent());
    }
    if (users.isNotEmpty) {
      library = [];
      for (var inv in users) {
        if (inv.fields != null) {
          library.add(inv.fields!);
          // library = inv.fields as List<Fields>? ?? [];
          add(LibraryLoadedEvent());
        }
      }
      // library = MyUtils.orderList(library);
    }
  }
}

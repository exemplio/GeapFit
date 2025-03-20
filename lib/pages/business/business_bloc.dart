// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geap_fit/pages/client/models/user_model.dart';

import '../../di/injection.dart';
import '../../services/http/api_services.dart';

part 'business_state.dart';
part 'business_event.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  final _apiServices = getIt<ApiServices>();
  List<Fields> business = [];

  BusinessBloc() : super(BusinessInitialState()) {
    on<BusinessEvent>((event, emitter) async {
      switch (event.runtimeType) {
        case BusinessInitialEvent:
          if (business.isNotEmpty) {
            emitter(BusinessLoadedProductState(business: business));
          } else {
            emitter(BusinessLoadingProductState());
            getUsers();
          }
          break;
        case BusinessErrorEvent:
          emitter(BusinessErrorProductState());
          break;
        case BusinessLoadedEvent:
          emitter(BusinessLoadedProductState(business: business));
          break;
        case BusinessRefreshEvent:
          business = [];
          emitter(BusinessLoadingProductState());
          getUsers();
          break;
      }
    });
  }
  void init() {
    business = [];
    add(BusinessInitialEvent());
  }

  Future<void> getUsers() async {
    add(BusinessLoadingEvent());
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
      add(BusinessErrorEvent());
    }
    if (users.isNotEmpty) {
      business = [];
      for (var inv in users) {
        if (inv.fields != null) {
          business.add(inv.fields!);
          // business = inv.fields as List<Fields>? ?? [];
          add(BusinessLoadedEvent());
        }
      }
      // business = MyUtils.orderList(business);
    }
  }
}

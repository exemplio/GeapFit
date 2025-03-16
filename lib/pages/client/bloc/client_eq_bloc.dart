// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geap_fit/utils/utils.dart';

import '../../../di/injection.dart';
import '../../../services/cacheService.dart';
import '../../../services/http/api_services.dart';
import '../../../services/http/domain/productModel.dart';
import '../models/initModel.dart';

part 'client_eq_state.dart';
part 'client_eq_event.dart';

class ClientEqBloc extends Bloc<ClientEqEvent, ClientEqState> {
  final _cache = Cache();
  final _apiServices = getIt<ApiServices>();
  List<ProductModel> products = [];
  ProfileModel? profile;

  ClientEqBloc() : super(ClientInitialState()) {
    on<ClientEqEvent>((event, emitter) async {
      switch (event.runtimeType) {
        case ClientInitialEvent:
          if (products != [] && profile != null) {
            emitter(
              ClientLoadedProductState(products: products, profile: profile),
            );
          } else {
            emitter(ClientLoadingProductState());
            getProducts();
          }
          break;
        case ClientErrorProductEvent:
          emitter(ClientErrorProductState());
          break;
        case ClientLoadedProductEvent:
          emitter(
            ClientLoadedProductState(products: products, profile: profile),
          );
          break;
        case ClientRefreshProductEvent:
          products = [];
          profile = null;
          emitter(ClientLoadingProductState());
          getProducts();
          break;
      }
    });
  }
  void init() {
    products = [];
    add(ClientInitialEvent());
  }

  Future<void> getProducts() async {
    add(ClientLoadingProductEvent());
    Init? init = await _cache.getInitData();
    var businessId = init?.businessProfile?.id;
    var initData = await _apiServices.init(businessId ?? "");
    Init guardarInitData = initData.obj ?? Init();
    List<Inventories>? inventories = guardarInitData.inventories;
    ProfileModel? model = init?.profile;

    if (model != null) {
      profile = model;
    }

    if (inventories?.length == null) {
      add(ClientErrorProductEvent());
    }

    if (inventories!.isNotEmpty) {
      products = [];
      for (var inv in inventories) {
        if (inv.products!.isNotEmpty) {
          products.addAll(inv.products!);
          add(ClientLoadedProductEvent());
        }
      }
      products = MyUtils.orderList(products);
    }
  }
}

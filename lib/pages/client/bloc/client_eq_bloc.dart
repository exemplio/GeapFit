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

class SalesEqBloc extends Bloc<SalesEqEvent, SalesEqState> {
  final _cache = Cache();
  final _apiServices = getIt<ApiServices>();
  List<ProductModel> products = [];
  ProfileModel? profile;

  SalesEqBloc() : super(SalesInitialState()) {
    on<SalesEqEvent>((event, emitter) async {
      switch (event.runtimeType) {
        case SalesInitialEvent:
          if (products != [] && profile != null) {
            emitter(
              SalesLoadedProductState(products: products, profile: profile),
            );
          } else {
            emitter(SalesLoadingProductState());
            getProducts();
          }
          break;
        case SalesErrorProductEvent:
          emitter(SalesErrorProductState());
          break;
        case SalesLoadedProductEvent:
          emitter(
            SalesLoadedProductState(products: products, profile: profile),
          );
          break;
        case SalesRefreshProductEvent:
          products = [];
          profile = null;
          emitter(SalesLoadingProductState());
          getProducts();
          break;
      }
    });
  }
  void init() {
    products = [];
    add(SalesInitialEvent());
  }

  Future<void> getProducts() async {
    add(SalesLoadingProductEvent());
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
      add(SalesErrorProductEvent());
    }

    if (inventories!.isNotEmpty) {
      products = [];
      for (var inv in inventories) {
        if (inv.products!.isNotEmpty) {
          products.addAll(inv.products!);
          add(SalesLoadedProductEvent());
        }
      }
      products = MyUtils.orderList(products);
    }
  }
}

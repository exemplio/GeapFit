// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geap_fit/utils/utils.dart';

import '../../di/injection.dart';
import '../../services/cacheService.dart';
import '../../services/http/api_services.dart';
import '../../services/http/domain/productModel.dart';
import 'models/initModel.dart';

part 'client_state.dart';
part 'client_event.dart';

class ClientEqBloc extends Bloc<ClientEqEvent, ClientEqState> {
  final _cache = Cache();
  final _apiServices = getIt<ApiServices>();
  List<Fields> products = [];
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

    var initData = await _apiServices.getClients();

    Document? guardarInitData;

    // Safely cast initData.obj to Document?
    guardarInitData = initData.obj;
    if (initData.obj is Document) {
    } else {
      print("initData.obj is not a Document");
    }

    // Handle the case when guardarInitData is null
    if (guardarInitData == null) {
      print("guardarInitData is null");
    } else {
      print(guardarInitData);
    }

    // Assign guardarInitData to a List<Document>
    List<Document> inventories = [];
    if (guardarInitData != null) {
      inventories.add(guardarInitData);
    }
    print(inventories);

    if (inventories.isEmpty) {
      add(ClientErrorProductEvent());
    }

    if (inventories.isNotEmpty) {
      products = [];
      print("TAMBIEN LLEGA ACA");
      for (var inv in inventories) {
        print(guardarInitData);
        print("----");
        print(inv.fields);
        if (inv.fields != null) {
          // products.addAll(inv.fields!);
          products = inv.fields as List<Fields>? ?? [];
          add(ClientLoadedProductEvent());
        }
      }
      // products = MyUtils.orderList(products);
    }
  }
}

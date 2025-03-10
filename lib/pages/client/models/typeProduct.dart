// ignore_for_file: depend_on_referenced_packages, file_names

import '../../../services/http/domain/productModel.dart';

class TypeProduct {
  List<ProductModel>? prepay;
  List<ProductModel>? pospay;
  TypeProduct({this.prepay, this.pospay});

  TypeProduct.fromJson(List<ProductModel> products) {
    if (products.isNotEmpty) {
      for (var product in products) {
        if (product.category?.trim() == "RECARGA") {
          prepay = [];
          prepay?.add(product);
        }
        if (product.category?.trim() == "POSPAGO") {
          pospay = [];
          pospay?.add(product);
        }
      }
    }
  }
  toJson() {
    Map<String, dynamic> json = {};
    json["prepay"] = prepay?.map((e) => e.toJson()).toList();
    json["pospay"] = pospay?.map((e) => e.toJson()).toList();
    return json;
  }
}

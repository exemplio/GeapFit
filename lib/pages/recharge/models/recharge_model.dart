import 'package:geap_fit/pages/store/models/store_model.dart';

import '../../store/models/collect_channel_model.dart';

class RechargeModel {
  List<CollectMethods>? banks;
  Results? product;

  RechargeModel({this.banks, this.product});

  RechargeModel.fromJson(
      List<Map<String, dynamic>> listBanks, Map<String, dynamic> mproduct) {
    banks = [];
    for (var element in listBanks) {
      banks?.add(CollectMethods.fromJson(element));
    }
    product = Results.fromJson(mproduct);
  }
}

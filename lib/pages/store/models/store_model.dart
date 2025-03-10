// ignore_for_file: depend_on_referenced_packages

import 'package:intl/intl.dart';
import '../../../services/http/domain/productModel.dart';

class InventoryModel {
  int? count;
  List<Results>? results;

  InventoryModel({this.count, this.results});

  InventoryModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['results'] != null) {
      results = [];
      json['results'].forEach((v) {
        results?.add(Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (results != null) {
      data['results'] = results?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String? realm;
  String? businessId;
  String? type;
  String? id;
  String? businessName;
  String? businessEmail;
  String? idDoc;
  String? idDocType;
  String? allyStatus;
  String? name;
  String? unit;
  double? balance;
  String? formattedBalance;
  double? minLimit;
  String? formattedMinLimit;
  double? transactionFee;
  String? formattedTransactionFee;
  String? feeChargeType;
  String? externalSapCode;
  List<Products>? products;
  Info? info;
  String? internalSapCode;

  Results(
      {this.realm,
      this.businessId,
      this.type,
      this.id,
      this.businessName,
      this.businessEmail,
      this.idDoc,
      this.idDocType,
      this.allyStatus,
      this.name,
      this.unit,
      this.balance,
      this.formattedBalance,
      this.minLimit,
      this.formattedMinLimit,
      this.transactionFee,
      this.feeChargeType,
      this.externalSapCode,
      this.products,
      this.info,
      this.internalSapCode});

  Results.fromJson(Map<String, dynamic> json) {
    NumberFormat numFormat = NumberFormat('###,###.##', 'es_VE');

    realm = json['realm'];
    businessId = json['business_id'];
    type = json['type'];
    id = json['id'];
    businessName = json['business_name'];
    businessEmail = json['business_email'];
    idDoc = json['id_doc'];
    idDocType = json['id_doc_type'];
    allyStatus = json['ally_status'];
    name = json['name'];
    unit = json['unit'];
    if (json['balance'] != null) {
      if (json['balance'].runtimeType is double) {
        balance = json['balance'];
        formattedBalance = numFormat.format(balance);
      } else {
        balance = double.parse(json['balance'].toString());
        formattedBalance = numFormat.format(balance);
      }
    }

    if (json['min_limit'] != null) {
      if (json['min_limit'].runtimeType is double) {
        minLimit = json['min_limit'];
        formattedMinLimit = numFormat.format(minLimit);
      } else {
        minLimit = double.parse(json['min_limit'].toString());
        formattedMinLimit = numFormat.format(minLimit);
      }
    }
    if (json['transaction_fee'] != null) {
      if (json['transaction_fee'].runtimeType is double) {
        transactionFee = json['transaction_fee'];
        formattedTransactionFee = numFormat.format(transactionFee);
      } else {
        transactionFee = double.parse(json['transaction_fee'].toString());
        formattedTransactionFee = numFormat.format(transactionFee);
      }
    }

    feeChargeType = json['fee_charge_type'];
    externalSapCode = json['external_sap_code'];
    // if (json['products'] != null) {
    //   products = [];
    //   json['products'].forEach((v) {
    //     products?.add(new Products.fromJson(v));
    //   });
    // }
    info = json['info'] != null ? Info.fromJson(json['info']) : null;
    internalSapCode = json['internal_sap_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['realm'] = realm;
    data['business_id'] = businessId;
    data['type'] = type;
    data['id'] = id;
    data['business_name'] = businessName;
    data['business_email'] = businessEmail;
    data['id_doc'] = idDoc;
    data['id_doc_type'] = idDocType;
    data['ally_status'] = allyStatus;
    data['name'] = name;
    data['unit'] = unit;
    data['balance'] = balance;
    data['min_limit'] = minLimit;
    data['transaction_fee'] = transactionFee;
    data['fee_charge_type'] = feeChargeType;
    data['external_sap_code'] = externalSapCode;
    if (products != null) {
      data['products'] = products?.map((v) => v.toJson()).toList();
    }
    if (info != null) {
      data['info'] = info?.toJson();
    }
    data['internal_sap_code'] = internalSapCode;
    return data;
  }
}

class Products {
  bool? cancelable;
  String? id;
  String? name;
  String? url;
  String? company;
  String? area;
  String? category;
  Features? features;
  bool? isCancelable;
  List<String>? channels;
  String? status;

  Products(
      {this.cancelable,
      this.id,
      this.name,
      this.url,
      this.company,
      this.area,
      this.category,
      this.features,
      this.isCancelable,
      this.channels,
      this.status});

  Products.fromJson(Map<String, dynamic> json) {
    cancelable = json['cancelable'];
    id = json['id'];
    name = json['name'];
    url = json['url'];
    company = json['company'];
    area = json['area'];
    category = json['category'];
    features =
        json['features'] != null ? Features.fromJson(json['features']) : null;
    isCancelable = json['is_cancelable'];
    channels = json['channels'].cast<String>();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cancelable'] = cancelable;
    data['id'] = id;
    data['name'] = name;
    data['url'] = url;
    data['company'] = company;
    data['area'] = area;
    data['category'] = category;
    if (features != null) {
      data['features'] = features?.toJson();
    }
    data['is_cancelable'] = isCancelable;
    data['channels'] = channels;
    data['status'] = status;
    return data;
  }
}

class Info {
  String? createdBy;
  String? createdByEmail;
  String? createdAt;
  String? updatedBy;
  String? updatedByEmail;
  String? updatedAt;

  Info(
      {this.createdBy,
      this.createdByEmail,
      this.createdAt,
      this.updatedBy,
      this.updatedByEmail,
      this.updatedAt});

  Info.fromJson(Map<String, dynamic> json) {
    createdBy = json['created_by'];
    createdByEmail = json['created_by_email'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedByEmail = json['updated_by_email'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_by'] = createdBy;
    data['created_by_email'] = createdByEmail;
    data['created_at'] = createdAt;
    data['updated_by'] = updatedBy;
    data['updated_by_email'] = updatedByEmail;
    data['updated_at'] = updatedAt;
    return data;
  }
}

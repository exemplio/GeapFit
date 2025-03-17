// ignore_for_file: file_names

import 'package:geap_fit/services/http/domain/productModel.dart';
import '../../../services/http/domain/role_request.dart';

class Init {
  AccessToken? idToken;
  ProfileModel? profile;
  ProfileModel? businessProfile;
  Country? country;
  Role? role;
  InitData? initData;
  List<Inventories>? inventories;

  Init({
    this.idToken,
    this.profile,
    this.businessProfile,
    this.country,
    this.role,
    this.initData,
    this.inventories,
  });

  Init.fromJson(Map<String, dynamic> json) {
    idToken =
        json['id_token'] != null
            ? AccessToken.fromJson(json['id_token'])
            : null;
    profile =
        json['profile'] != null ? ProfileModel.fromJson(json['profile']) : null;
    businessProfile =
        json['business_profile'] != null
            ? ProfileModel.fromJson(json['business_profile'])
            : null;
    country =
        json['country'] != null ? Country.fromJson(json['country']) : null;
    role = json['role'] != null ? Role.fromJson(json['role']) : null;
    initData =
        json['init_data'] != null ? InitData.fromJson(json['init_data']) : null;
    if (json['inventories'] != null) {
      inventories = <Inventories>[];
      json['inventories'].forEach((v) {
        inventories?.add(Inventories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (idToken != null) {
      data['id_token'] = idToken?.toJson();
    }
    if (profile != null) {
      data['profile'] = profile?.toJson();
    }
    if (businessProfile != null) {
      data['business_profile'] = businessProfile?.toJson();
    }
    if (country != null) {
      data['country'] = country?.toJson();
    }
    if (role != null) {
      data['role'] = role?.toJson();
    }
    if (initData != null) {
      data['init_data'] = initData?.toJson();
    }
    if (inventories != null) {
      data['inventories'] = inventories?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AccessToken {
  String? idToken;
  int? expiresIn;
  String? refreshToken;
  String? tokenType;

  AccessToken({
    this.idToken,
    this.expiresIn,
    this.refreshToken,
    this.tokenType,
  });

  AccessToken.fromJson(Map<String, dynamic> json) {
    idToken = json['id_token'];
    expiresIn = json['expires_in'];
    refreshToken = json['refresh_token'];
    tokenType = json['token_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_token'] = idToken;
    data['expires_in'] = expiresIn;
    data['refresh_token'] = refreshToken;
    data['token_type'] = tokenType;
    return data;
  }
}

class ProfileModel {
  String? realm;
  String? id;
  String? emailDeflt;
  String? firstName;
  String? lastName;
  String? businessName;
  String? alias;
  String? country;
  bool? lock;
  String? idDoc;
  String? idDocType;
  String? type;
  String? phoneDeflt;
  List<String>? bankAccounts;

  ProfileModel({
    this.realm,
    this.id,
    this.emailDeflt,
    this.firstName,
    this.lastName,
    this.businessName,
    this.alias,
    this.country,
    this.lock,
    this.idDoc,
    this.idDocType,
    this.type,
    this.phoneDeflt,
    this.bankAccounts,
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    realm = json['realm'];
    id = json['id'];
    emailDeflt = json['email_deflt'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    businessName = json['business_name'];
    alias = json['alias'];
    country = json['country'];
    lock = json['lock'];
    idDoc = json['id_doc'];
    idDocType = json['id_doc_type'];
    type = json['type'];
    phoneDeflt = json['phone_deflt'];
    if (json['bank_accounts'] != null) {
      bankAccounts = [];
      json['bank_accounts'].forEach((v) {
        bankAccounts?.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['realm'] = realm;
    data['id'] = id;
    data['email_deflt'] = emailDeflt;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['business_name'] = businessName;
    data['alias'] = alias;
    data['country'] = country;
    data['lock'] = lock;
    data['id_doc'] = idDoc;
    data['id_doc_type'] = idDocType;
    data['type'] = type;
    data['phone_deflt'] = phoneDeflt;
    if (bankAccounts != null) {
      data['bank_accounts'] = bankAccounts?.map((v) => v).toList();
    }
    return data;
  }
}

class Country {
  String? realm;
  String? alpha2;
  String? alpha3;
  String? isoNumber;
  String? name;
  String? shortName;
  Capital? capital;
  List<String>? states;
  String? currency;
  List<String>? currencies;
  Info? info;

  Country({
    this.realm,
    this.alpha2,
    this.alpha3,
    this.isoNumber,
    this.name,
    this.shortName,
    this.capital,
    this.states,
    this.currency,
    this.currencies,
    this.info,
  });

  Country.fromJson(Map<String, dynamic> json) {
    realm = json['realm'];
    alpha2 = json['alpha2'];
    alpha3 = json['alpha3'];
    isoNumber = json['iso_number'];
    name = json['name'];
    shortName = json['short_name'];
    capital =
        json['capital'] != null ? Capital.fromJson(json['capital']) : null;
    // if (json['states'] != null) {
    //   if(json['states'].length != 0) {
    //     states = [];
    //     json['states'].forEach((v) {
    //       if(v != null) {
    //         states?.add(v);
    //       }
    //     });
    //   }
    // }
    currency = json['currency'];
    currencies = json['currencies'].cast<String>();
    info = json['info'] != null ? Info.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['realm'] = realm;
    data['alpha2'] = alpha2;
    data['alpha3'] = alpha3;
    data['iso_number'] = isoNumber;
    data['name'] = name;
    data['short_name'] = shortName;
    if (capital != null) {
      data['capital'] = capital?.toJson();
    }
    if (states != null) {
      data['states'] = states?.map((v) => v).toList();
    }
    data['currency'] = currency;
    data['currencies'] = currencies;
    if (info != null) {
      data['info'] = info?.toJson();
    }
    return data;
  }
}

class Capital {
  String? name;
  List<String>? municipalities;
  List<String>? cities;

  Capital({this.name, this.municipalities, this.cities});

  Capital.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['municipalities'] != null) {
      municipalities = [];
      json['municipalities'].forEach((v) {
        municipalities?.add(v);
      });
    }
    if (json['cities'] != null) {
      cities = [];
      json['cities'].forEach((v) {
        cities?.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (municipalities != null) {
      data['municipalities'] = municipalities?.map((v) => v).toList();
    }
    if (cities != null) {
      data['cities'] = cities?.map((v) => v).toList();
    }
    return data;
  }
}

class Info {
  String? createdBy;
  String? createdByEmail;
  String? createdAt;

  Info({this.createdBy, this.createdByEmail, this.createdAt});

  Info.fromJson(Map<String, dynamic> json) {
    createdBy = json['created_by'];
    createdByEmail = json['created_by_email'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_by'] = createdBy;
    data['created_by_email'] = createdByEmail;
    data['created_at'] = createdAt;
    return data;
  }
}

class InitData {
  List<Inventories>? inventories;
  Ally? ally;

  InitData({this.inventories, this.ally});

  InitData.fromJson(Map<String, dynamic> json) {
    if (json['inventories'] != null) {
      inventories = <Inventories>[];
      json['inventories']?.forEach((v) {
        inventories?.add(Inventories.fromJson(v));
      });
    }
    ally = json['ally'] != null ? Ally.fromJson(json['ally']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (inventories != null) {
      data['inventories'] = inventories?.map((v) => v.toJson()).toList();
    }
    if (ally != null) {
      data['ally'] = ally?.toJson();
    }
    return data;
  }
}

class Inventories {
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
  String? balance;
  String? minLimit;
  String? transactionFee;
  String? feeChargeType;
  String? externalSapCode;
  List<ProductModel>? products;
  String? internalSapCode;

  Inventories({
    this.realm,
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
    this.minLimit,
    this.transactionFee,
    this.feeChargeType,
    this.externalSapCode,
    this.products,
    this.internalSapCode,
  });

  Inventories.fromJson(Map<String, dynamic> json) {
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
    balance = json['balance'].toString();
    minLimit = json['min_limit'].toString();
    transactionFee = json['transaction_fee'].toString();
    feeChargeType = json['fee_charge_type'];
    externalSapCode = json['external_sap_code'];
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(ProductModel.fromJson(v));
      });
    }
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
    data['internal_sap_code'] = internalSapCode;
    return data;
  }
}

class Ally {
  String? realm;
  String? businessId;
  String? id;
  String? businessName;
  String? businessEmail;
  String? businessIdDoc;
  String? businessIdDocType;
  String? allyName;
  String? allyEmail;
  String? allyIdDoc;
  String? allyIdDocType;
  String? status;
  List<String>? paymentMethods;

  Ally({
    this.realm,
    this.businessId,
    this.id,
    this.businessName,
    this.businessEmail,
    this.businessIdDoc,
    this.businessIdDocType,
    this.allyName,
    this.allyEmail,
    this.allyIdDoc,
    this.allyIdDocType,
    this.status,
    this.paymentMethods,
  });

  Ally.fromJson(Map<String, dynamic> json) {
    realm = json['realm'];
    businessId = json['business_id'];
    id = json['id'];
    businessName = json['business_name'];
    businessEmail = json['business_email'];
    businessIdDoc = json['business_id_doc'];
    businessIdDocType = json['business_id_doc_type'];
    allyName = json['ally_name'];
    allyEmail = json['ally_email'];
    allyIdDoc = json['ally_id_doc'];
    allyIdDocType = json['ally_id_doc_type'];
    status = json['status'];
    paymentMethods = json['payment_methods'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['realm'] = realm;
    data['business_id'] = businessId;
    data['id'] = id;
    data['business_name'] = businessName;
    data['business_email'] = businessEmail;
    data['business_id_doc'] = businessIdDoc;
    data['business_id_doc_type'] = businessIdDocType;
    data['ally_name'] = allyName;
    data['ally_email'] = allyEmail;
    data['ally_id_doc'] = allyIdDoc;
    data['ally_id_doc_type'] = allyIdDocType;
    data['status'] = status;
    data['payment_methods'] = paymentMethods;
    return data;
  }
}

class FirestoreResponse {
  List<Document>? documents;

  FirestoreResponse({this.documents});

  FirestoreResponse.fromJson(Map<String, dynamic> json) {
    if (json['documents'] != null) {
      documents = <Document>[];
      json['documents'].forEach((v) {
        documents?.add(Document.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (documents != null) {
      data['documents'] = documents?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Document {
  String? name;
  Fields? fields;
  String? createTime;
  String? updateTime;

  Document({this.name, this.fields, this.createTime, this.updateTime});

  Document.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    fields = json['fields'] != null ? Fields.fromJson(json['fields']) : null;
    createTime = json['createTime'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (fields != null) {
      data['fields'] = fields?.toJson();
    }
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    print('$createTime $updateTime');
    return data;
  }
}

class Fields {
  FieldValue? first;
  FieldValue? born;
  FieldValue? last;

  Fields({this.first, this.born, this.last});

  Fields.fromJson(Map<String, dynamic> json) {
    first = json['first'] != null ? FieldValue.fromJson(json['first']) : null;
    born = json['born'] != null ? FieldValue.fromJson(json['born']) : null;
    last = json['last'] != null ? FieldValue.fromJson(json['last']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (first != null) {
      data['first'] = first?.toJson();
    }
    if (born != null) {
      data['born'] = born?.toJson();
    }
    if (last != null) {
      data['last'] = last?.toJson();
    }
    return data;
  }
}

class FieldValue {
  String? stringValue;
  String? integerValue;

  FieldValue({this.stringValue, this.integerValue});

  FieldValue.fromJson(Map<String, dynamic> json) {
    stringValue = json['stringValue'];
    integerValue = json['integerValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stringValue'] = stringValue;
    data['integerValue'] = integerValue;
    return data;
  }
}

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CollectChannel {
  String? realm;
  String? businessId;
  String? id;
  String? businessName;
  String? businessEmail;
  String? businessIdDoc;
  String? name;
  String? description;
  List<CollectMethods>? collectMethods;
  bool? active;
  Info? info;

  CollectChannel(
      {this.realm,
      this.businessId,
      this.id,
      this.businessName,
      this.businessEmail,
      this.businessIdDoc,
      this.name,
      this.description,
      this.collectMethods,
      this.active,
      this.info});

  CollectChannel.fromJson(Map<String, dynamic> json) {
    realm = json['realm'];
    businessId = json['business_id'];
    id = json['id'];
    businessName = json['business_name'];
    businessEmail = json['business_email'];
    businessIdDoc = json['business_id_doc'];
    name = json['name'];
    description = json['description'];
    if (json['collect_methods'] != null) {
      collectMethods = [];
      json['collect_methods'].forEach((v) {
        collectMethods?.add(CollectMethods.fromJson(v));
      });
    }
    active = json['active'];
    info = json['info'] != null ? Info.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['realm'] = realm;
    data['business_id'] = businessId;
    data['id'] = id;
    data['business_name'] = businessName;
    data['business_email'] = businessEmail;
    data['business_id_doc'] = businessIdDoc;
    data['name'] = name;
    data['description'] = description;
    if (collectMethods != null) {
      data['collect_methods'] = collectMethods?.map((v) => v.toJson()).toList();
    }
    data['active'] = active;
    if (info != null) {
      data['info'] = info?.toJson();
    }
    return data;
  }
}

class CollectMethods {
  String? productName;
  String? bankAccountId;
  String? id;
  BankInfo? bankInfo;
  PaymentChannel? paymentChannel;
  String? currencyCode;
  CurrencyInfo? currencyInfo;
  String? credentialOwnerId;
  String? credentialId;
  String? credentialService;
  String? credentialDescription;
  bool? allowed;
  String? state;
  String? phone;
  String? formattedPhone;
  String? idDoc;

  CollectMethods(
      {this.productName,
      this.bankAccountId,
      this.id,
      this.bankInfo,
      this.paymentChannel,
      this.currencyCode,
      this.currencyInfo,
      this.credentialOwnerId,
      this.credentialId,
      this.credentialService,
      this.credentialDescription,
      this.allowed,
      this.state,
      this.phone,
      this.idDoc});

  CollectMethods.fromJson(Map<String, dynamic> json) {
    var maskFormatter = MaskTextInputFormatter(
        mask: '(###) ###-####',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
    productName = json['product_name'];
    bankAccountId = json['bank_account_id'];
    id = json['id'];
    bankInfo =
        json['bank_info'] != null ? BankInfo.fromJson(json['bank_info']) : null;
    paymentChannel = json['payment_channel'] != null
        ? PaymentChannel.fromJson(json['payment_channel'])
        : null;
    currencyCode = json['currency_code'];
    currencyInfo = json['currency_info'] != null
        ? CurrencyInfo.fromJson(json['currency_info'])
        : null;
    credentialOwnerId = json['credential_owner_id'];
    credentialId = json['credential_id'];
    credentialService = json['credential_service'];
    credentialDescription = json['credential_description'];
    allowed = json['allowed'];
    state = json['state'];
    phone = json['phone'];
    if (phone != null) {
      formattedPhone = maskFormatter.maskText(phone!);
    }
    idDoc = json['id_doc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_name'] = productName;
    data['bank_account_id'] = bankAccountId;
    data['id'] = id;
    if (bankInfo != null) {
      data['bank_info'] = bankInfo?.toJson();
    }
    if (paymentChannel != null) {
      data['payment_channel'] = paymentChannel?.toJson();
    }
    data['currency_code'] = currencyCode;
    if (currencyInfo != null) {
      data['currency_info'] = currencyInfo?.toJson();
    }
    data['credential_owner_id'] = credentialOwnerId;
    data['credential_id'] = credentialId;
    data['credential_service'] = credentialService;
    data['credential_description'] = credentialDescription;
    data['allowed'] = allowed;
    data['state'] = state;
    data['phone'] = phone;
    data['id_doc'] = idDoc;
    return data;
  }
}

class BankInfo {
  String? code;
  String? name;
  String? acronym;
  String? thumbnail;

  BankInfo({this.code, this.name, this.acronym, this.thumbnail});

  BankInfo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    acronym = json['acronym'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['acronym'] = acronym;
    data['thumbnail'] = thumbnail;
    return data;
  }
}

class PaymentChannel {
  String? productName;
  String? type;
  String? action;

  PaymentChannel({this.productName, this.type, this.action});

  PaymentChannel.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    type = json['type'];
    action = json['action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_name'] = productName;
    data['type'] = type;
    data['action'] = action;
    return data;
  }
}

class CurrencyInfo {
  String? code;
  String? name;
  String? isoNumber;
  int? decimals;
  String? symbol;
  String? ccrOperationSymbol;

  CurrencyInfo(
      {this.code,
      this.name,
      this.isoNumber,
      this.decimals,
      this.symbol,
      this.ccrOperationSymbol});

  CurrencyInfo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    isoNumber = json['iso_number'];
    decimals = json['decimals'];
    symbol = json['symbol'];
    ccrOperationSymbol = json['ccr_operation_symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['iso_number'] = isoNumber;
    data['decimals'] = decimals;
    data['symbol'] = symbol;
    data['ccr_operation_symbol'] = ccrOperationSymbol;
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

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:geap_fit/utils/utils.dart';

class CurrencyRate {
  Rate? rate;

  CurrencyRate(
      {this.rate});

  CurrencyRate.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      json['results'].forEach((v) {
        rate = Rate.fromJson(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (rate != null) {
      data['results'] = rate?.toJson();
    }
    return data;
  }
}

class Rate {
  String? realm;
  String? id;
  String? fromCurrencyCode;
  String? toCurrencyCode;
  FromCurrency? fromCurrency;
  ToCurrency? toCurrency;
  double? rate;
  double? roundedRate;
  String? formattedRoundedRate;
  double? minRate;
  String? formattedMinRate;
  String? dateOfRate;
  String? createdAt;

  Rate(
      {this.realm,
        this.id,
        this.fromCurrencyCode,
        this.toCurrencyCode,
        this.fromCurrency,
        this.toCurrency,
        this.rate,
        this.roundedRate,
        this.formattedRoundedRate,
        this.minRate,
        this.formattedMinRate,
        this.dateOfRate,
        this.createdAt});

  Rate.fromJson(Map<String, dynamic> json) {
    var numFormatFormatted = CurrencyTextInputFormatter.currency(
        locale: 'es_VE',
        decimalDigits: 2,
        symbol: ""
    );
    realm = json['realm'];
    id = json['id'];
    fromCurrencyCode = json['from_currency_code'];
    toCurrencyCode = json['to_currency_code'];
    fromCurrency = json['from_currency'] != null
        ? FromCurrency.fromJson(json['from_currency'])
        : null;
    toCurrency = json['to_currency'] != null
        ? ToCurrency.fromJson(json['to_currency'])
        : null;
    rate = MyUtils.parseAmount(json['rate']);

    roundedRate = MyUtils.parseAmount(json['rounded_rate']);
    formattedRoundedRate = roundedRate != null ? numFormatFormatted.formatString(roundedRate?.toStringAsFixed(2) ?? "0") : null;

    if(roundedRate!=null){
      minRate = double.parse(((roundedRate ?? 1) * 10).toStringAsFixed(2));
      formattedMinRate = numFormatFormatted.formatString(minRate?.toStringAsFixed(2) ?? "0");
    }
    dateOfRate = json['date_of_rate'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['realm'] = realm;
    data['id'] = id;
    data['from_currency_code'] = fromCurrencyCode;
    data['to_currency_code'] = toCurrencyCode;
    if (fromCurrency != null) {
      data['from_currency'] = fromCurrency?.toJson();
    }
    if (toCurrency != null) {
      data['to_currency'] = toCurrency?.toJson();
    }
    data['rate'] = rate;
    data['rounded_rate'] = roundedRate;
    data['date_of_rate'] = dateOfRate;
    data['created_at'] = createdAt;
    return data;
  }
}

class FromCurrency {
  String? code;
  String? name;
  String? isoNumber;
  int? decimals;
  String? symbol;
  String? ccrOperationSymbol;
  Country? country;

  FromCurrency(
      {this.code,
        this.name,
        this.isoNumber,
        this.decimals,
        this.symbol,
        this.ccrOperationSymbol,
        this.country});

  FromCurrency.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    isoNumber = json['iso_number'];
    decimals = json['decimals'];
    symbol = json['symbol'];
    ccrOperationSymbol = json['ccr_operation_symbol'];
    country =
    json['country'] != null ? Country.fromJson(json['country']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['iso_number'] = isoNumber;
    data['decimals'] = decimals;
    data['symbol'] = symbol;
    data['ccr_operation_symbol'] = ccrOperationSymbol;
    if (country != null) {
      data['country'] = country?.toJson();
    }
    return data;
  }
}

class Country {
  String? alpha2;
  String? alpha3;
  String? isoNumber;
  String? name;
  String? shortName;
  String? flag;

  Country(
      {this.alpha2,
        this.alpha3,
        this.isoNumber,
        this.name,
        this.shortName,
        this.flag});

  Country.fromJson(Map<String, dynamic> json) {
    alpha2 = json['alpha2'];
    alpha3 = json['alpha3'];
    isoNumber = json['iso_number'];
    name = json['name'];
    shortName = json['short_name'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['alpha2'] = alpha2;
    data['alpha3'] = alpha3;
    data['iso_number'] = isoNumber;
    data['name'] = name;
    data['short_name'] = shortName;
    data['flag'] = flag;
    return data;
  }
}

class ToCurrency {
  String? code;
  String? name;
  String? isoNumber;
  int? decimals;
  String? symbol;
  String? ccrOperationSymbol;

  ToCurrency(
      {this.code,
        this.name,
        this.isoNumber,
        this.decimals,
        this.symbol,
        this.ccrOperationSymbol});

  ToCurrency.fromJson(Map<String, dynamic> json) {
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

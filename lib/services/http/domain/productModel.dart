// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers, depend_on_referenced_packages, file_names

import 'package:intl/intl.dart';
import 'package:geap_fit/utils/translate.dart';

import '../../../utils/utils.dart';

class ProductModel {
  bool? cancelable;
  String? realm;
  String? id;
  String? name;
  String? formattedName;
  String? url;
  String? company;
  String? area;
  String? category;
  bool? isCancelable;
  String? status;
  String? serviceCommissionPerTransaction;
  Schedule? schedule;
  Features? features;
  List<String>? channels;
  List<String>? collectChannelCollectMethods;

  ProductModel(
      {this.cancelable,
      this.realm,
      this.id,
      this.name,
      this.formattedName,
      this.url,
      this.company,
      this.area,
      this.category,
      this.isCancelable,
      this.status,
      this.serviceCommissionPerTransaction,
      this.schedule,
      this.features,
      this.channels,
      this.collectChannelCollectMethods});

  ProductModel.fromJson(Map<String, dynamic> json) {
    cancelable = json['cancelable'];
    realm = json['realm'];
    id = json['id'];
    name = json['name'];
    formattedName = translate(json['name'] ?? "");
    url = json['url'];
    company = json['company'];
    area = json['area'];
    category = json['category'];
    isCancelable = json['is_cancelable'];
    status = json['status'];
    serviceCommissionPerTransaction =
        json['service_commission_per_transaction'].toString();
    schedule =
        json['schedule'] != null ? Schedule.fromJson(json['schedule']) : null;
    features =
        json['features'] != null ? Features.fromJson(json['features']) : null;
    channels = json['channels'].cast<String>();
    if (json['collect_channel_collect_methods'] != null) {
      collectChannelCollectMethods = [];
      json['collect_channel_collect_methods'].map((v) {
        collectChannelCollectMethods?.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cancelable'] = cancelable;
    data['realm'] = realm;
    data['id'] = id;
    data['name'] = name;
    data['url'] = url;
    data['company'] = company;
    data['area'] = area;
    data['category'] = category;
    data['is_cancelable'] = isCancelable;
    data['status'] = status;
    data['service_commission_per_transaction'] =
        serviceCommissionPerTransaction;
    if (schedule != null) {
      data['schedule'] = schedule?.toJson();
    }
    if (features != null) {
      data["features"] = features;
    }
    data['channels'] = channels;
    if (collectChannelCollectMethods != null) {
      data['collect_channel_collect_methods'] =
          collectChannelCollectMethods?.map((v) => v).toList();
    }
    return data;
  }
}

class Features {
  int? MIN;
  int? MAX;
  int? MULTIPLE;
  String? MIN_FORMAT;
  String? MAX_FORMAT;
  String? MULTIPLE_FORMAT;

  Features({this.MIN, this.MAX, this.MULTIPLE});

  Features.fromJson(Map<String, dynamic> json) {
    final NumberFormat _formatter = NumberFormat.currency(
        locale: "es_VE",
        name: "",
        symbol: "",
        decimalDigits: 2,
        customPattern: "¤#,##0.00;¤-#,##0.00");
    MIN = MyUtils.parseAmountInt(json['MIN']);
    MIN_FORMAT = MIN != null
        ? _formatter.format(double.parse(MIN.toString()))
        : json['MIN'];

    MAX = MyUtils.parseAmountInt(json['MAX']);
    MAX_FORMAT = MAX != null
        ? _formatter.format(double.parse(MAX.toString()))
        : json['MAX'];

    MULTIPLE = MyUtils.parseAmountInt(json['MULTIPLE']);
    MULTIPLE_FORMAT = MULTIPLE != null
        ? _formatter.format(double.parse(MULTIPLE.toString()))
        : json['MULTIPLE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MIN'] = MIN;
    data['MAX'] = MAX;
    data['MULTIPLE'] = MULTIPLE;
    return data;
  }
}

class Schedule {
  String? timeZone;
  WeekSchedule? weekSchedule;

  Schedule({this.timeZone, this.weekSchedule});

  Schedule.fromJson(Map<String, dynamic> json) {
    timeZone = json['time_zone'];
    weekSchedule = json['week_schedule'] != null
        ? WeekSchedule.fromJson(json['week_schedule'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time_zone'] = timeZone;
    if (weekSchedule != null) {
      data['week_schedule'] = weekSchedule?.toJson();
    }
    return data;
  }
}

class WeekSchedule {
  MONDAY? mONDAY;
  MONDAY? tUESDAY;
  MONDAY? wEDNESDAY;
  MONDAY? tHURSDAY;
  MONDAY? fRIDAY;

  WeekSchedule(
      {this.mONDAY, this.tUESDAY, this.wEDNESDAY, this.tHURSDAY, this.fRIDAY});

  WeekSchedule.fromJson(Map<String, dynamic> json) {
    mONDAY = json['MONDAY'] != null ? MONDAY.fromJson(json['MONDAY']) : null;
    tUESDAY = json['TUESDAY'] != null ? MONDAY.fromJson(json['TUESDAY']) : null;
    wEDNESDAY =
        json['WEDNESDAY'] != null ? MONDAY.fromJson(json['WEDNESDAY']) : null;
    tHURSDAY =
        json['THURSDAY'] != null ? MONDAY.fromJson(json['THURSDAY']) : null;
    fRIDAY = json['FRIDAY'] != null ? MONDAY.fromJson(json['FRIDAY']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mONDAY != null) {
      data['MONDAY'] = mONDAY?.toJson();
    }
    if (tUESDAY != null) {
      data['TUESDAY'] = tUESDAY?.toJson();
    }
    if (wEDNESDAY != null) {
      data['WEDNESDAY'] = wEDNESDAY?.toJson();
    }
    if (tHURSDAY != null) {
      data['THURSDAY'] = tHURSDAY?.toJson();
    }
    if (fRIDAY != null) {
      data['FRIDAY'] = fRIDAY?.toJson();
    }
    return data;
  }
}

class MONDAY {
  String? beginTime;
  String? endTime;

  MONDAY({this.beginTime, this.endTime});

  MONDAY.fromJson(Map<String, dynamic> json) {
    beginTime = json['begin_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['begin_time'] = beginTime;
    data['end_time'] = endTime;
    return data;
  }
}

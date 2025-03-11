// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_device_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthDeviceRequest _$AuthDeviceRequestFromJson(Map<String, dynamic> json) =>
    AuthDeviceRequest(
      json['fingerprint'] as String,
      json['name'] as String?,
      json['type'] as String,
      json['custom_id'] as String?,
      (json['features'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$AuthDeviceRequestToJson(AuthDeviceRequest instance) =>
    <String, dynamic>{
      'fingerprint': instance.fingerprint,
      if (instance.name case final value?) 'name': value,
      'type': instance.type,
      if (instance.customId case final value?) 'custom_id': value,
      if (instance.features case final value?) 'features': value,
    };

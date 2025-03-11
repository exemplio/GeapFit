// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_grant_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PasswordGrantRequest _$PasswordGrantRequestFromJson(
  Map<String, dynamic> json,
) => PasswordGrantRequest(json['email'] as String, json['password'] as String);

Map<String, dynamic> _$PasswordGrantRequestToJson(
  PasswordGrantRequest instance,
) => <String, dynamic>{'email': instance.email, 'password': instance.password};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessTokenResponse _$AccessTokenResponseFromJson(Map<String, dynamic> json) =>
    AccessTokenResponse(
      kind: json['kind'] as String?,
      localId: json['localId'] as String?,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      idToken: json['idToken'] as String?,
      registered: json['registered'] as bool?,
      expiresIn: (json['expiresIn'] as num?)?.toInt(),
      expireDate:
          json['expireDate'] == null
              ? null
              : DateTime.parse(json['expireDate'] as String),
    );

Map<String, dynamic> _$AccessTokenResponseToJson(
  AccessTokenResponse instance,
) => <String, dynamic>{
  'kind': instance.kind,
  'localId': instance.localId,
  'email': instance.email,
  'displayName': instance.displayName,
  'idToken': instance.idToken,
  'registered': instance.registered,
  'expiresIn': instance.expiresIn,
  'expireDate': instance.expireDate?.toIso8601String(),
};

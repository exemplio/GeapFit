import 'package:json_annotation/json_annotation.dart';

part 'access_token_response.g.dart';

@JsonSerializable()
class AccessTokenResponse {
  String? kind;
  String? localId;
  String? email;
  String? displayName;
  String? idToken;
  bool? registered;
  int? expiresIn;
  DateTime? expireDate;


  AccessTokenResponse({
    required this.kind,
    required this.localId,
    required this.email,
    required this.displayName,
    required this.idToken,
    required this.registered,
    required this.expiresIn,
    required this.expireDate,
  });

  @override
  String toString() {
    return 'AccessTokenResponse{accessToken: $kind, tokenType: $localId}';
  }

  factory AccessTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenResponseFromJson(json);

  /// Connect the generated [_$AccessTokenResponseToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AccessTokenResponseToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:sports_management/domain/profile.dart';


part 'credential_response.g.dart';

@JsonSerializable()
class CredentialResponse {
  Profile? profile;

  CredentialResponse({this.profile});

  factory CredentialResponse.fromJson(Map<String, dynamic> json) =>
      _$CredentialResponseFromJson(json);

  /// Connect the generated [_$CredentialResponseToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$CredentialResponseToJson(this);
}

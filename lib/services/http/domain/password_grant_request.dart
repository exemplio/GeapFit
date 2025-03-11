import 'package:json_annotation/json_annotation.dart';

part 'password_grant_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PasswordGrantRequest {
  String email;
  String password;

  PasswordGrantRequest(
      this.email, this.password);

  factory PasswordGrantRequest.fromJson(Map<String, dynamic> json) =>
      _$PasswordGrantRequestFromJson(json);

  /// Connect the generated [_$PasswordGrantRequestToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PasswordGrantRequestToJson(this);
}

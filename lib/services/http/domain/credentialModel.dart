// ignore_for_file: file_names

import 'dart:convert';

CredentialModel credentialModelFromJson(String str) =>
    CredentialModel.fromJson(json.decode(str));

String credentialModelToJson(CredentialModel data) =>
    json.encode(data.toJson());

class CredentialModel {
  String email;
  String password;

  CredentialModel({
    required this.email,
    required this.password,
  });

  factory CredentialModel.fromJson(Map<String, dynamic> json) =>
      CredentialModel(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}

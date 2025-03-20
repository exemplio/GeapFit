class CredentialModel {
  String? email;
  String? password;

  CredentialModel({this.email, this.password});

  CredentialModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_token'] = email;
    data['expires_in'] = password;
    return data;
  }
}

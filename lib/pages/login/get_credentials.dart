import 'dart:convert';

import 'package:geap_fit/pages/login/models/credential_model.dart';
import 'package:injectable/injectable.dart';
import 'package:geap_fit/services/http/domain/password_grant_request.dart';
import 'package:geap_fit/services/http/result.dart';

import '../../services/http/api_services.dart';

@injectable
class GetCredentials {
  final ApiServices _apiServices;

  GetCredentials(this._apiServices);

  Future<Result<CredentialModel>> passwordGrant(
    String email,
    String password,
    bool isCI,
  ) {
    return _apiServices.passwordGrant(PasswordGrantRequest(email, password));
  }

  Future<Result<void>> getClients() {
    return _apiServices.getClients();
  }
}

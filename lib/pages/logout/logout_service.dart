import 'dart:async';
import 'dart:ffi';

import 'package:injectable/injectable.dart';
import 'package:sports_management/services/http/api_services.dart';
import 'package:sports_management/services/http/result.dart';
import 'package:sports_management/services/token_service.dart';

@injectable
class LogoutService {
  final ApiServices _apiServices;
  final TokenService _tokenService;

  LogoutService(this._apiServices, this._tokenService);

  Future<Result<Void>> closeSession() {
    return _tokenService.token().then((value) => value.obj).then(_close);
  }

  Future<Result<Void>> _close(String? accessToken) async {
    if (accessToken != null) {
      return _apiServices.closeSession(accessToken);
    }

    return Result.success(null);
  }
}

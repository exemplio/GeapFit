import 'dart:async';
import 'dart:ffi';

import 'package:injectable/injectable.dart';
import 'package:geap_fit/services/http/api_services.dart';
import 'package:geap_fit/services/http/result.dart';
import 'package:geap_fit/services/token_service.dart';

@injectable
class ChatService {
  final ApiServices _apiServices;
  final TokenService _tokenService;

  ChatService(this._apiServices, this._tokenService);

  Future<Result<Void>> closeSession() {
    return _tokenService.token().then((value) => value.obj).then(_close);
  }

  Future<Result<Void>> _close(String? idToken) async {
    if (idToken != null) {
      return _apiServices.closeSession(idToken);
    }

    return Result.success(null);
  }
}

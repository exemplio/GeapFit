import 'dart:async';
import 'dart:ffi';

import 'package:injectable/injectable.dart';
import 'package:geap_fit/services/http/api_services.dart';
import 'package:geap_fit/services/http/result.dart';

@injectable
class ChatService {
  final ApiServices _apiServices;

  ChatService(this._apiServices);

  // Future<Result<Void>> closeSession() {
  // return _tokenService.token().then((value) => value.obj).then(_close);
  // }

  Future<Result<Void>> _close(String? idToken) async {
    if (idToken != null) {
      return _apiServices.closeSession(idToken);
    }

    return Result.success(null);
  }
}

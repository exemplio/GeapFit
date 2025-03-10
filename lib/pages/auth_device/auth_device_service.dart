import 'package:injectable/injectable.dart';
import 'package:sports_management/domain/message.dart';
import 'package:sports_management/services/get/fingerprint_service.dart';
import 'package:sports_management/services/http/api_services.dart';
import 'package:sports_management/services/http/domain/auth_device_code_request.dart';
import 'package:sports_management/services/http/result.dart';
import 'package:sports_management/services/token_service.dart';
import 'package:sports_management/utils/utils.dart';

@injectable
class AuthDeviceService {
  final TokenService _tokenService;
  final ApiServices _apiServices;
  final FingerprintService _fingerprintService;

  AuthDeviceService(
      this._tokenService, this._apiServices, this._fingerprintService);

  Future<Result<Message>> authDevice(String authCode, String? name) {
    return _tokenService.token().then((value) =>
        MyUtils.nextResult(value, (result) {
          var accessToken = result.obj;
          if (accessToken != null) {
            return _fingerprintService
                .fingerprint()
                .then((fingerprint) =>
                    AuthDeviceCodeRequest(fingerprint, authCode, name))
                .then(
                    (value) => _apiServices.authDeviceCode(accessToken, value));
          }

          return Future.value(
              Result.failMsg("No hay access token para autorizar dispositivo"));
        }));
  }

  Future<Result<Message>> sendAuthDeviceCode() {
    return _tokenService
        .token()
        .then((value) => MyUtils.nextResult(value, (result) {
              var accessToken = result.obj;
              if (accessToken != null) {
                return _fingerprintService.fingerprint().then((value) =>
                    _apiServices.sendAuthDeviceCode(accessToken, value));
              }

              return Future.value(
                  Result.failMsg("No hay access token para reenviar codigo"));
            }));
  }
}

// ignore_for_file: depend_on_referenced_packages, file_names

import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:optional/optional.dart';
import 'package:sports_management/domain/access_token_response.dart';
import 'package:sports_management/domain/credentialModel.dart';
import 'package:sports_management/domain/profile.dart';
import 'package:sports_management/pages/client/models/initModel.dart';
import 'package:sports_management/services/http/domain/authorized_devices.dart';
import 'package:sports_management/services/http/network_connectivity.dart';
import 'package:sports_management/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/credential_response.dart';
import 'get/fingerprint_service.dart';
import 'package:device_info_plus/device_info_plus.dart';

@injectable
class Cache {

  final _logger = Logger();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  //static final _cacheData = FFCache();

  Future<void> setOtherCache(String name, String data) async {
    var prefs = await _prefs();
    await prefs.setString(name, data);
  }

  Future<void> setCacheJsonFuture(String key, dynamic data) {
    return _savePrefs(key, data);
  }

  setCacheJson(String key, data) async {
    return _savePrefs(key, data);
  }

  Future<void> setMerchantDevice(data) {
    return _savePrefs("device", data);
  }

  Future<dynamic> getCacheJson(String name) {
    return _prefsString(name).then((value) {
      if (value == null) {
        return null;
      }

      return jsonDecode(value);
    });
  }


  Future<String?> getCacheData(String name) async {
    try {
      return _prefsString(name);
    } catch (err) {
    //  print(err);
    }

    return Future.value(null);
  }

  Future<CredentialModel?> getLastCredentials() {
    return _getFromPrefs(
        "last_credentials", (s) => CredentialModel.fromJson(s));
  }


  Future<void> deleteCacheData(String name) async {
    try {
      var prefs = await _prefs();
      await prefs.remove(name);
    } catch (err) {
    //  print(err);
    }
  }

  emptyCacheData() async {
    _logger.i("Eliminando todo en cache");
    try {
      //await _cacheData.clear();

      var prefs = await _prefs();
      var accessTokenResponse = await getAccessTokenResponse();

      var fingerprint = (await _prefs()).getString(FingerprintService.key);
      var devices = await getAuthorizedDevices();

      await prefs.clear();

      await prefs.setString(FingerprintService.key, fingerprint!);
      await saveAuthorizedDevices(devices);


      if (accessTokenResponse != null) {
        await saveAccessToken(accessTokenResponse);
      }
    } catch (err) {
   //   print(err);
    }
  }

  Future<T?> getObj<T>(String key, T Function(Map<String, dynamic> json) f) {
    return getCacheJson(key).then((value) {
      if (value != null) {
        return f(value);
      }

      return null;
    });
  }

  Future<CredentialResponse?> credentialResponse() {
    return getObj("credentials", (s) => CredentialResponse.fromJson(s));
  }

  Future<bool> areCredentialsStored() async {
    var first = await credentialResponse().then((value) => value != null);
    var second = await getAccessTokenResponse().then((value) => value != null);
    var profile = await getProfile();
    var third = profile == null ? false : await isDeviceAuthorized(profile.id!);

    return first || (second && third);
  }

  Future<void> saveNetworkState(NetworkState networkState) {
    return _savePrefs("network_state", networkState);
  }

  Future<NetworkState?> getNetworkState() {
    return getObj("network_state", (s) => NetworkState.fromJson(s));
  }

  Future<bool> isOnline() async {
    return await getNetworkState().then((value) => value?.isOnline ?? true);
  }

  Future<AccessTokenResponse> saveAccessToken(
      AccessTokenResponse accessTokenResponse) async {
    var expiresIn = accessTokenResponse.expiresIn;

    if (accessTokenResponse.idToken != null && expiresIn != null) {
      accessTokenResponse.expireDate =
          DateTime.now().add(Duration(seconds: expiresIn - 10));

      return saveAccessTokenResponse(
          accessTokenResponse, const Duration(days: 365));
    } else {
      var ttl = Optional.ofNullable(expiresIn)
          .map((p0) => Duration(seconds: p0 - 10))
          .orElse(const Duration(minutes: 1));

      return saveAccessTokenResponse(accessTokenResponse, ttl);
    }
  }

  Future<AccessTokenResponse> saveAccessTokenResponse(
      AccessTokenResponse accessTokenResponse, Duration ttl) {
    return setCacheJsonFuture("access_token", accessTokenResponse)
        .then((value) => accessTokenResponse);
  }

  Future<AccessTokenResponse?> getAccessTokenResponse() {
    return _getFromPrefs(
        "access_token", (s) => AccessTokenResponse.fromJson(s));
  }

  Future<SharedPreferences> _prefs() {
    return MyUtils.prefs();
  }

  Future<void> _savePrefs(String key, Object obj) async {
    var prefs = await _prefs();
    await prefs.setString(key, jsonEncode(obj));
  }

  Future<String?> _prefsString(String key) async {
    var prefs = await _prefs();
    return prefs.getString(key);
  }

  Future<T?> _getFromPrefs<T>(
      String key, T Function(dynamic json) parseJson) async {
    var json = await _prefsString(key);
    if (json == null) {
      return null;
    }

    return parseJson(jsonDecode(json));
  }

  Future<void> saveProfile(Profile profile) {
    return _savePrefs("profile", profile);
  }

  Future<Profile?> getProfile() {
    return _getFromPrefs("profile", (json) => Profile.fromJson(json));
  }

  Future<void> saveInitData(Init init) {
    return _savePrefs("init_data", init);
  }
  Future<Init?> getInitData() {
    return _getFromPrefs("init_data",
            (json) => Init.fromJson(json));
  }

  Future<void> saveKeepLastSession(String keepData) {
    return _savePrefs("keep_session_data", keepData);
  }

  Future<String?> getKeepLastSession() async {
    var prefs = await _prefs();
    return prefs.getString("keep_session_data");
  }

  Future<void> saveLastCredentials(CredentialModel credentials) {
    return _savePrefs("last_credentials", credentials);
  }

  Future<void> saveAuthorizedDevices(AuthorizedDevices devices) {
    return _savePrefs("authorized_devices", devices);
  }

  Future<AuthorizedDevices> getAuthorizedDevices() {
    return _getFromPrefs(
            "authorized_devices", (json) => AuthorizedDevices.fromJson(json))
        .then((value) {
      if (value == null) {
        return const AuthorizedDevices(map: {});
      }
      return value;
    });
  }

  Future<void> saveDeviceIsAuthorized(String id, {bool isAuth = true}) async {
    var devices = await getAuthorizedDevices();
    Map<String, bool> newMap = {...devices.map};

    newMap.update(id, (value) => isAuth, ifAbsent: () => isAuth);
    devices = devices.copyWith(map: newMap);
    await saveAuthorizedDevices(devices);
  }

  Future<bool> isDeviceAuthorized(String id) async {
    var devices = await getAuthorizedDevices();

    return devices.map[id] ?? false;
  }

  Future<void> deleteAccessToken() {
    return deleteCacheData("access_token");
  }

  Future<void> saveDeviceModel(String model) async{
    return _savePrefs("device_model", model);
  }

  Future<String> getModel() async {
    var prefs = await _prefs();
    String replaceAllDevice= prefs.getString("device_model")!.replaceAll('"', '');
    return replaceAllDevice;
  }

}

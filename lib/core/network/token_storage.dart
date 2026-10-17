import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _accessKey = 'access_token';
  static const String _refreshKey = 'refresh_token';

  static String? accessToken;
  static String? refreshToken;

  static Future<void> load() async {
    accessToken = await _storage.read(key: _accessKey);
    refreshToken = await _storage.read(key: _refreshKey);
  }

  static Future<void> save({
    required String accessToken,
    required String refreshToken,
  }) async {
    TokenStorage.accessToken = accessToken;
    TokenStorage.refreshToken = refreshToken;
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
  }

  static void clear() {
    accessToken = null;
    refreshToken = null;
    unawaited(_storage.delete(key: _accessKey));
    unawaited(_storage.delete(key: _refreshKey));
  }
}
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageManager {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final String tokenKey = "token";
  final String refreshTokenKey = "refreshToken";
  final String user = "user";
  final String email = 'email';
  final String pass = 'pass';
  final String rememberMe = 'rememberMe';

  SecureStorageManager._();

  static final SecureStorageManager _singleton = SecureStorageManager._();

  static SecureStorageManager get sharedInstance => _singleton;

  // Helper methods for sensitive data
  Future<void> storeToken(String token) => _storage.write(key: tokenKey, value: token);
  Future<void> storeRefreshToken(String token) => _storage.write(key: refreshTokenKey, value: token);
  Future<void> storeUser(String userData) => _storage.write(key: user, value: userData);
  Future<void> storeEmail(String text) => _storage.write(key: email, value: text);
  Future<void> storePass(String text) => _storage.write(key: pass, value: text);
  Future<void> setRememberMe(bool chk) => _storage.write(key: rememberMe, value: chk.toString());

  Future<String?> getToken() => _storage.read(key: tokenKey);
  Future<String?> getRefreshToken() => _storage.read(key: refreshTokenKey);
  Future<String?> getUserData() => _storage.read(key: user);
  Future<String?> getSavedEmail() => _storage.read(key: email);
  Future<String?> getSavedPassword() => _storage.read(key: pass);
  Future<bool> getRememberMe() async {
    String? value = await _storage.read(key: rememberMe);
    return value == 'true';
  }

  Future<bool> hasToken() async {
    String? token = await getToken();
    return token != null;
  }

  Future<void> clearToken() => _storage.delete(key: tokenKey);
  Future<void> clearRefreshToken() => _storage.delete(key: refreshTokenKey);
  Future<void> clearUser() => _storage.delete(key: user);
  Future<void> clearEmail() => _storage.delete(key: email);
  Future<void> clearPass() => _storage.delete(key: pass);
  Future<void> clearRememberMe() => _storage.delete(key: rememberMe);

  Future<void> clearAll() async {
    await clearRefreshToken();
    await clearToken();
    await clearUser();
    // await clearEmail();
    // await clearPass();
    // await clearRememberMe();
  }
}

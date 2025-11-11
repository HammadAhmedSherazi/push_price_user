import 'dart:convert';

import '../export_all.dart';

class SharedPreferenceManager {
  final String profileKey = "profile";
  final String firstLoginKey = "first_login";
  final String isDark = "isDark";
  final String url = "url";
  final String languageIndex = 'selected_Language_index';
  final String langCode = 'lang_code';
  final String getStarted = 'get_started';
  final String cartListKey = 'cart_list';




  static late final SharedPreferences instance;

  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();

  SharedPreferenceManager._();

  static final SharedPreferenceManager _singleton = SharedPreferenceManager._();

  static SharedPreferenceManager get sharedInstance => _singleton;

  // Helper methods for non-sensitive data
  Future<bool> storeUrL(String urlString) => instance.setString(url, urlString);
  Future<bool> savedLanguageIndex(int index) => instance.setInt(languageIndex, index);
  Future<bool> storeLangCode(String code) => instance.setString(langCode, code);
  Future<bool> storeGetStarted(bool chk) => instance.setBool(getStarted, chk);
  Future<bool> storeDarkTheme(bool isDarkValue) => instance.setBool(isDark, isDarkValue);

  // Helper methods to get non-sensitive data
  bool getStartedCheck() => instance.getBool(getStarted) ?? false;
  String? getUrl() => instance.getString(url);
  bool isDarkTheme() => instance.getBool(isDark) ?? false;
  int getSavedLanguageIndex() => instance.getInt(languageIndex) ?? 0;
  String getLangCode() => instance.getString(langCode) ?? "en";

  // Helper method to store any string
  Future<bool> storeString(String key, String value) => instance.setString(key, value);

  // Helper method to get any string
  String? getString(String key) => instance.getString(key);

  // Helper method to store any integer
  Future<bool> storeInt(String key, int value) => instance.setInt(key, value);

  // Helper method to get any integer
  int? getInteger(String key) => instance.getInt(key);

  // Helper method to store any bool
  Future<bool> storeBool(String key, bool value) => instance.setBool(key, value);

  // Helper method to get any bool
  bool? getBool(String key) => instance.getBool(key);

  bool hasUser() => instance.getString(profileKey) != null;

  Future<bool> firstLogin() => instance.setBool(firstLoginKey, false);

  bool isFirstLogin() => instance.getBool(firstLoginKey) ?? true;

  Future<bool> clearKey(String key) => instance.remove(key);

  Future<bool> clearPref() => instance.clear();

  // Cart list methods
  Future<bool> storeCartList(List<ProductPurchasingDataModel> cartList) async {
    final cartJson = cartList.map((e) => e.toJson()).toList();
    return instance.setStringList(cartListKey, cartJson.map((e) => jsonEncode(e)).toList());
  }

  List<ProductPurchasingDataModel> getCartList() {
    final cartJson = instance.getStringList(cartListKey) ?? [];
    return cartJson.map((e) {
      final json = jsonDecode(e);
      return ProductPurchasingDataModel.fromJson(json,quantity: json['select_quantity'] ?? 0, discount: json['discountAmount'] ?? 0 );
    }).toList();
  }

  Future<bool> clearCartList() => instance.remove(cartListKey);

}

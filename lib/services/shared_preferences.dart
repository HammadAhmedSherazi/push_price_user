import '../export_all.dart';

class SharedPreferenceManager {
  final String tokenKey = "token";
  final String refreshTokenKey = "refreshToken";

  final String profileKey = "profile";
  final String firstLoginKey = "first_login";
  final String isDark = "isDark";
  final String user = "user";
  final String url = "url";
  final String languageIndex = 'selected_Language_index';
  final String langCode = 'lang_code';
  final String email = 'email';
  final String pass = 'pass';
  final String rememberMe = 'rememberMe';
  final String getStarted = 'get_started';
  



  static late final SharedPreferences instance;

  static Future<SharedPreferences>  init() async =>
      instance = await SharedPreferences.getInstance();

  SharedPreferenceManager._();

  static final SharedPreferenceManager _singleton = SharedPreferenceManager._();

  static SharedPreferenceManager get sharedInstance => _singleton;

  // helper method to store token
  Future<bool> storeToken(String token) => instance.setString(tokenKey, token);
  Future<bool> storeRefreshToken(String token) => instance.setString(refreshTokenKey, token);
  Future<bool> storeUrL(String urlString)=> instance.setString(url, urlString);
  Future<bool> savedLanguageIndex(int index)=> instance.setInt(languageIndex, index);
  Future<bool> storeLangCode(String code)=> instance.setString(langCode, code);
  Future<bool> setRemberMe(bool chk)=> instance.setBool(rememberMe, chk);
  Future<bool> storeEmail(String text)=> instance.setString(email,text);
  Future<bool> storePass(String text)=> instance.setString(pass,text);
  Future<bool> storeGetStarted(bool chk)=> instance.setBool(getStarted,chk);



  Future<bool> storeDarkTheme(bool isDarkValue) => instance.setBool(isDark, isDarkValue);

  Future<bool> storeUser(String userData) => instance.setString(user, userData);


  //helper method to get token
  String? getToken() => instance.getString(tokenKey);
  String? getRefreshToken() => instance.getString(refreshTokenKey);
  bool? getRemberMe()=> instance.getBool(rememberMe);
  bool getStartedCheck()=> instance.getBool(getStarted) ?? false;

  String? getSavedEmail() => instance.getString(email);
  String? getSavedPassword() => instance.getString(pass);
  String? getUserData() => instance.getString(user);

  String? getUrl() => instance.getString(url);


  bool hasToken() => instance.getString(tokenKey) != null;

  bool isDarkTheme()=> instance.getBool(isDark) ?? false;

  int getSavedLanguageIndex()=> instance.getInt(languageIndex) ?? 0;
  String getLangCode()=> instance.getString(langCode) ?? "en";

  //helper method to store any string
  Future<bool> storeString(String key, String value) => instance.setString(key, value);

  //helper method to get any string
  String? getString(String key) => instance.getString(key);

  //helper method to store any integer
  Future<bool> storeInt(String key, int value) => instance.setInt(key, value);

  //helper method to get any integer
  int? getInteger(String key) => instance.getInt(key);

  //helper method to store any bool
  Future<bool> storeBool(String key, bool value) => instance.setBool(key, value);

  



  //helper method to get any bool
  bool? getBool(String key) => instance.getBool(key);

  bool hasUser() => instance.getString(profileKey) != null;

  Future<bool> firstLogin() => instance.setBool(firstLoginKey, false);

  bool isFirstLogin() => instance.getBool(firstLoginKey) ?? true;

  Future<bool> clearKey(String key) => instance.remove(key);

  Future<bool> clearPref() => instance.clear();

  Future<bool> clearUser() => instance.remove(user);

  Future<bool> clearToken() => instance.remove(tokenKey);
  Future<bool> clearRefreshToken() => instance.remove(refreshTokenKey);
  void clearAll(){
    clearRefreshToken();
    clearToken();
    clearUser();

  }


}
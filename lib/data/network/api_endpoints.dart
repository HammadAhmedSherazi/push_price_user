class ApiEndpoints {
  static const String userAuth = "users/auth/";
  static const String login = "${userAuth}login";
  static const String logout = "${userAuth}logout";
  static const String verifyOtp = "${userAuth}verify-otp";
  static const String resendOtp = "${userAuth}resend-otp";
  static const String completeProfile = "${userAuth}complete-profile";
  static const String refresh = "${userAuth}refresh";
  static const String register = "${userAuth}register";
  static const String getUser = "${userAuth}me";

  static const String getProducts = "admin/products/";
  static const String getCatrgories = "${getProducts}categories";



}
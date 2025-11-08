class ApiEndpoints {
  
  static const String user = "users/";
  static const String admin = "admin/";
  static const String userAuth = "${user}auth/";

  static const String imageUpload = "${admin}upload/upload";
  static const String imageDelete = "${admin}upload/delete";

  static const String login = "${userAuth}login";
  static const String logout = "${userAuth}logout";
  static const String verifyOtp = "${userAuth}verify-otp";
  static const String resendOtp = "${userAuth}resend-otp";
  static const String completeProfile = "${userAuth}complete-profile";
  static const String refresh = "${userAuth}refresh";
  static const String register = "${userAuth}register";
  static const String getUser = "${userAuth}me";
  static const String updateProfile = "${userAuth}update-profile";

  static const String getProducts = "admin/products/";
  static const String getCatrgories = "${user}categories";
  static const String getStores = "${user}stores";
  static String getStoreProducts(int id)=> "$getStores/$id/products";
  static String getProductDetail(int productId)=> "${user}products/$productId";
  static const String getNearbyStores = "${user}nearby-stores";
  static const String getAddresses = "${user}addresses";
  static String activateAddress(int addressId) => "${getAddresses}/$addressId/activate";

}

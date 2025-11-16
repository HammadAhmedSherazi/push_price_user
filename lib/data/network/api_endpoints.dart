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
  static const String forgotPassword = "${userAuth}forgot-password";
  static const String resetPassword = "${userAuth}reset-password";
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
  static String activateAddress(int addressId) => "$getAddresses/$addressId/activate";
  static String address(int addressId) => "$getAddresses/$addressId";
  static const String orders = "${user}orders";
  static String getOrderDetail(int orderId) => "$orders/$orderId";
  static String cancelOrder(int orderId) => "$orders/$orderId/cancel";
  static String updateOrder(int orderId) => "$orders/$orderId";
  static String paymentIntent(int orderId) => "$orders/$orderId/payment-intent";
  static String confirmPayment(int orderId) => "$orders/$orderId/confirm-payment";
  static const String validateVoucher = "${user}vouchers/validate";
  static const String products = "${user}products";
  static String getFavouriteProductDetail(int productId) => "$products/$productId";
  static String getProductByBarCode(String barcode) => "$products/barcode/$barcode";
  static const String favourites = "${user}favorites";
  static String updateFavourite(int favouriteId) => "$favourites/$favouriteId";
  static String deleteFavourite(int favouriteId) => "$favourites/$favouriteId";
  static const String notifications = "${user}notifications";
  static const String unreadNotificationCount = "${notifications}/unread-count";
  static String markAsRead(int notificationId) => "$notifications/$notificationId/read";
  static const String googleMapApi = "https://maps.googleapis.com/maps/api/";

}

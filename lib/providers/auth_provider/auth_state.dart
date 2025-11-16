import 'package:push_price_user/data/network/api_response.dart';
import 'package:push_price_user/export_all.dart';

class AuthState {
  final ApiResponse loginApiResponse;
  final ApiResponse logoutApiResponse;
  final ApiResponse registrationApiResponse;
  final ApiResponse verifyOtpApiResponse;
  final ApiResponse resendOtpApiResponse;
  final ApiResponse completeProfileApiResponse;
  final ApiResponse forgotPasswordApiResponse;
  final ApiResponse resetPasswordApiResponse;
  final ApiResponse getUserApiResponse;
  final ApiResponse getStoresApiRes;
  final ApiResponse getCategoriesApiResponse;
  final ApiResponse uploadImageApiResponse;
  final ApiResponse removeImageApiResponse;
  final ApiResponse updateProfileApiResponse;

  final UserDataModel? userData;
  final String? imageUrl;
  final StaffModel? staffInfo;
  final List<CategoryDataModel>? categories;
  final int? categoriesSkip;
  AuthState({
    required this.loginApiResponse,
    required this.registrationApiResponse,
    required this.verifyOtpApiResponse,
    required this.resendOtpApiResponse,
    required this.completeProfileApiResponse,
    required this.forgotPasswordApiResponse,
    required this.resetPasswordApiResponse,
    required this.getUserApiResponse,
    required this.getStoresApiRes,
    required this.getCategoriesApiResponse,
    required this.uploadImageApiResponse,
    required this.removeImageApiResponse,
    required this.updateProfileApiResponse,
    required this.logoutApiResponse,
    this.userData,
    this.imageUrl,
    this.staffInfo,
    this.categories,
    this.categoriesSkip,
  });

  AuthState copyWith({
    ApiResponse? loginApiResponse,
    ApiResponse? registrationApiResponse,
    ApiResponse? verifyOtpApiResponse,
    ApiResponse? resendOtpApiResponse,
    ApiResponse? completeProfileApiResponse,
    ApiResponse? forgotPasswordApiResponse,
    ApiResponse? resetPasswordApiResponse,
    ApiResponse? getUserApiResponse,
    ApiResponse? getStoresApiRes,
    ApiResponse? getCategoriesApiResponse,
    ApiResponse? uploadImageApiResponse,
    ApiResponse? removeImageApiResponse,
    ApiResponse? updateProfileApiResponse,
    ApiResponse? logoutApiResponse,
    UserDataModel? userData,
    String? imageUrl,
    StaffModel? staffInfo,
    List<CategoryDataModel>? categories,
    int? categoriesSkip,
  }) => AuthState(
    logoutApiResponse: logoutApiResponse ?? this.logoutApiResponse,
    loginApiResponse: loginApiResponse ?? this.loginApiResponse,
    registrationApiResponse: registrationApiResponse ?? this.registrationApiResponse,
    verifyOtpApiResponse: verifyOtpApiResponse ?? this.verifyOtpApiResponse,
    resendOtpApiResponse: resendOtpApiResponse ?? this.resendOtpApiResponse,
    completeProfileApiResponse: completeProfileApiResponse ?? this.completeProfileApiResponse,
    forgotPasswordApiResponse: forgotPasswordApiResponse ?? this.forgotPasswordApiResponse,
    resetPasswordApiResponse: resetPasswordApiResponse ?? this.resetPasswordApiResponse,
    getUserApiResponse: getUserApiResponse ?? this.getUserApiResponse,
    getStoresApiRes:  getStoresApiRes ?? this.getStoresApiRes,
    getCategoriesApiResponse: getCategoriesApiResponse ?? this.getCategoriesApiResponse,
    uploadImageApiResponse: uploadImageApiResponse ?? this.uploadImageApiResponse,
    removeImageApiResponse: removeImageApiResponse ?? this.removeImageApiResponse,
    updateProfileApiResponse: updateProfileApiResponse ?? this.updateProfileApiResponse,
    userData: userData ?? this.userData,
    staffInfo: staffInfo ?? this.staffInfo,
    imageUrl: imageUrl ?? this.imageUrl,
    categories: categories ?? this.categories,
    categoriesSkip: categoriesSkip ?? this.categoriesSkip,
  );
}

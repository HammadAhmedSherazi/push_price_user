import 'dart:async';
import 'dart:convert';

import 'package:push_price_user/data/network/api_response.dart';
import 'package:push_price_user/export_all.dart';
import 'package:push_price_user/providers/auth_provider/auth_state.dart';
import 'package:push_price_user/views/auth/otp_view.dart';

class AuthProvider  extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState(
      loginApiResponse: ApiResponse.undertermined(),
      registrationApiResponse: ApiResponse.undertermined(),
      verifyOtpApiResponse: ApiResponse.undertermined(),
      resendOtpApiResponse: ApiResponse.undertermined(),
      completeProfileApiResponse: ApiResponse.undertermined(),
      getUserApiResponse: ApiResponse.undertermined(),
      getStoresApiRes: ApiResponse.undertermined(),
      getCategoriesApiResponse: ApiResponse.undertermined(),

      categories: [],
      categoriesSkip: 0,
    );
  }
  String emailText = "";
  FutureOr<void> login({required String email, required String password})async{
    emailText = email;
    if (!ref.mounted) return;
    try {
      state = state.copyWith(loginApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.post(ApiEndpoints.login, {
  "username": email,
  "password": password
}, isToken: false);
      if (!ref.mounted) return;

      // Add condition check
      if(response != null && !(response is Map && response.containsKey('detail'))){
        Helper.showMessage( AppRouter.navKey.currentContext!,message: AppRouter.navKey.currentContext!.tr("successfully_login"));

        state = state.copyWith(loginApiResponse: ApiResponse.completed(response['data']));
        final Map<String, dynamic>? user = response["user"];
        if(user != null){
          savedUserData(user);
        }
        SharedPreferenceManager.sharedInstance.storeToken(response['access_token'] ?? "");
        SharedPreferenceManager.sharedInstance.storeRefreshToken(response['refresh_access_token'] ?? "");
        AppRouter.pushAndRemoveUntil(NavigationView());

      }
      else{
        // Show error message if condition is false
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("something_went_wrong_try_again"),
        );
        state = state.copyWith(loginApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      // Show error message for exceptions
      Helper.showMessage(
        AppRouter.navKey.currentContext!,
        message: AppRouter.navKey.currentContext!.tr("something_went_wrong_try_again"),
      );
      state = state.copyWith(loginApiResponse: ApiResponse.error());
    }
  }

  FutureOr<void> logout()async{
    if (!ref.mounted) return;

    try {
      // Make API call to logout
      await MyHttpClient.instance.post(ApiEndpoints.logout, {});
      // Clear local data
      SharedPreferenceManager.sharedInstance.clearAll();

      AppRouter.pushAndRemoveUntil(LoginView());
    } catch (e) {
      if (!ref.mounted) return;
      // Even if API call fails, clear local data and logout
      SharedPreferenceManager.sharedInstance.clearAll();
      AppRouter.pushAndRemoveUntil(LoginView());
    }
  }

  FutureOr<void> registration({required String email, required String password})async{
    emailText = email;
    if (!ref.mounted) return;
    try {
      state = state.copyWith(registrationApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.post(ApiEndpoints.register, {
        "email": email,
        "password": password
      }, isToken: false);
      if (!ref.mounted) return;

      // Add condition check
      if(response != null && !(response is Map && response.containsKey('detail'))){
        Helper.showMessage( AppRouter.navKey.currentContext!,message: AppRouter.navKey.currentContext!.tr("registration_successful"));

        state = state.copyWith(registrationApiResponse: ApiResponse.completed(response['data']));
       
                // Navigate to OTP verification or next step
        AppRouter.push(OtpView(isSignup: true,)); // Assuming such a view exists

      }
      else{
        // Show error message if condition is false
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("something_went_wrong_try_again"),
        );
        state = state.copyWith(registrationApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      // Show error message for exceptions
      Helper.showMessage(
        AppRouter.navKey.currentContext!,
        message: AppRouter.navKey.currentContext!.tr("something_went_wrong_try_again"),
      );
      state = state.copyWith(registrationApiResponse: ApiResponse.error());
    }
  }

  FutureOr<void> verifyOtp({required String otp})async{
    if (!ref.mounted) return;
    try {
      state = state.copyWith(verifyOtpApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.post(ApiEndpoints.verifyOtp, {
  "email": emailText,
  "otp_code": otp
}, isToken: false);
      if (!ref.mounted) return;

      if(response != null && !(response is Map && response.containsKey('detail'))){
        Helper.showMessage( AppRouter.navKey.currentContext!,message: AppRouter.navKey.currentContext!.tr("otp_verified"));

        state = state.copyWith(verifyOtpApiResponse: ApiResponse.completed(response['data']));
        // Navigate to complete profile or next step
        // AppRouter.push(CompleteProfileView());

      }
      else{
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("invalid_otp"),
        );
        state = state.copyWith(verifyOtpApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      Helper.showMessage(
        AppRouter.navKey.currentContext!,
        message: AppRouter.navKey.currentContext!.tr("something_went_wrong_try_again"),
      );
      state = state.copyWith(verifyOtpApiResponse: ApiResponse.error());
    }
  }

  FutureOr<void> resendOtp()async{
    if (!ref.mounted) return;
    try {
      // Show full screen loader dialog
      Helper.showFullScreenLoader(AppRouter.navKey.currentContext!, dismissible: false);
      state = state.copyWith(resendOtpApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.post(ApiEndpoints.resendOtp, {
  "email": emailText
}, isToken: false);
      // Dismiss the loader
      Navigator.of(AppRouter.navKey.currentContext!).pop();
      if (!ref.mounted) return;

      if(response != null && !(response is Map && response.containsKey('detail'))){
        Helper.showMessage( AppRouter.navKey.currentContext!,message: AppRouter.navKey.currentContext!.tr("otp_resent"));

        state = state.copyWith(resendOtpApiResponse: ApiResponse.completed(response['data']));

      }
      else{
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_resend_otp"),
        );
        state = state.copyWith(resendOtpApiResponse: ApiResponse.error());
      }
    } catch (e) {
      // Dismiss the loader on error
      Navigator.of(AppRouter.navKey.currentContext!).pop();
      if (!ref.mounted) return;
      Helper.showMessage(
        AppRouter.navKey.currentContext!,
        message: AppRouter.navKey.currentContext!.tr("something_went_wrong_try_again"),
      );
      state = state.copyWith(resendOtpApiResponse: ApiResponse.error());
    }
  }

  FutureOr<void> completeProfile({required Map<String, dynamic> profileData})async{
    if (!ref.mounted) return;
    try {
      state = state.copyWith(completeProfileApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.post(ApiEndpoints.completeProfile, profileData);
      if (!ref.mounted) return;

      if(response != null && !(response is Map && response.containsKey('detail'))){
        Helper.showMessage( AppRouter.navKey.currentContext!,message: AppRouter.navKey.currentContext!.tr("profile_completed"));

        state = state.copyWith(completeProfileApiResponse: ApiResponse.completed(response['data']));
        final Map<String, dynamic>? user = response["user"];
        if(user != null){
          savedUserData(user);
        }
        AppRouter.pushAndRemoveUntil(NavigationView());

      }
      else{
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_complete_profile"),
        );
        state = state.copyWith(completeProfileApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      Helper.showMessage(
        AppRouter.navKey.currentContext!,
        message: AppRouter.navKey.currentContext!.tr("something_went_wrong_try_again"),
      );
      state = state.copyWith(completeProfileApiResponse: ApiResponse.error());
    }
  }

  FutureOr<void> getUser()async{
    if (!ref.mounted) return;
    try {
      state = state.copyWith(getUserApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.get(ApiEndpoints.getUser);
      if (!ref.mounted) return;

      if(response != null){
        state = state.copyWith(getUserApiResponse: ApiResponse.completed(response));
        final Map<String, dynamic>? user = response["user"];
        if(user != null){
          savedUserData(user);
        }

      }
      else{
        state = state.copyWith(getUserApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(getUserApiResponse: ApiResponse.error());
    }
  }
 
 
  void savedUserData(Map<String, dynamic> userMap) {
    String user = jsonEncode(userMap);
    SharedPreferenceManager.sharedInstance.storeUser(user);
    userSet();
  }

  void userSet() {

    Map<String, dynamic> userJson =
        jsonDecode(SharedPreferenceManager.sharedInstance.getUserData()!);

   state = state.copyWith(userData: UserDataModel.fromJson(userJson));


  }

  FutureOr<void> getCategories({
    required int limit,
    required int skip,
    String? searchText,
  }) async {
    if (!ref.mounted) return;
    if (skip == 0 && state.categories!.isNotEmpty) {
      state = state.copyWith(categories: [], categoriesSkip: 0);
    }
    Map<String, dynamic> params = {'limit': limit, 'skip': skip};
    if (searchText != null) {
      params['search'] = searchText;
    }

    try {
      state = state.copyWith(
        getCategoriesApiResponse: skip == 0
            ? ApiResponse.loading()
            : ApiResponse.loadingMore(),
      );
      final response = await MyHttpClient.instance.get(
        ApiEndpoints.getCatrgories,
        params: params,
      );

      if (!ref.mounted) return;

      if (response != null) {
        List temp = response ?? [];
        final List<CategoryDataModel> list = List.from(
          temp.map((e) => CategoryDataModel.fromJson(e)),
        );
        state = state.copyWith(
          getCategoriesApiResponse: ApiResponse.completed(response),
          categories: skip == 0 && state.categories!.isEmpty
              ? list
              : [...state.categories!, ...list],
          categoriesSkip: list.length >= limit ? skip + limit : 0,
        );
      } else {
        state = state.copyWith(
          getCategoriesApiResponse: skip == 0
              ? ApiResponse.error()
              : ApiResponse.undertermined(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        getCategoriesApiResponse: skip == 0
            ? ApiResponse.error()
            : ApiResponse.undertermined(),
      );
    }
  }
}
final authProvider = NotifierProvider<AuthProvider, AuthState>(
  AuthProvider.new,
);
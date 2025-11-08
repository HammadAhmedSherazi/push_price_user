import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
      uploadImageApiResponse: ApiResponse.undertermined(),
      removeImageApiResponse: ApiResponse.undertermined(),
      updateProfileApiResponse: ApiResponse.undertermined(),
      logoutApiResponse: ApiResponse.undertermined(),

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
  "email": email,
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
        await SecureStorageManager.sharedInstance.storeToken(response['access_token'] ?? "");
        await SecureStorageManager.sharedInstance.storeRefreshToken(response['refresh_token'] ?? "");
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
      state = state.copyWith(logoutApiResponse:  ApiResponse.loading());
      String? refreshToken = await SecureStorageManager.sharedInstance.getRefreshToken();
      final response = await MyHttpClient.instance.post(ApiEndpoints.logout, {
        "refresh_token": refreshToken ?? ""
      });
      AppRouter.back();
      if(response != null &&  !(response is Map && response.containsKey('detail'))){
           state = state.copyWith(logoutApiResponse:  ApiResponse.completed(response));
      // Clear local data
      await SecureStorageManager.sharedInstance.clearAll();
      AppRouter.pushAndRemoveUntil(LoginView());
      }
      else{
         Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("something_went_wrong_try_again"),
        );
        state = state.copyWith(logoutApiResponse: ApiResponse.error());
      }
    

      
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(logoutApiResponse:  ApiResponse.error());
      // Even if API call fails, clear local data and logout
      await SecureStorageManager.sharedInstance.clearAll();
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
    imageUnset();
     Helper.showFullScreenLoader(AppRouter.navKey.currentContext!, dismissible: false);
     
    if (!ref.mounted) return;
    try {
      state = state.copyWith(verifyOtpApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.post(ApiEndpoints.verifyOtp, {
  "email": emailText,
  "otp_code": otp
}, isToken: false);
 Navigator.of(AppRouter.navKey.currentContext!).pop();
      if (!ref.mounted) return;

      if(response != null && !(response is Map && response.containsKey('detail'))){
        Helper.showMessage( AppRouter.navKey.currentContext!,message: AppRouter.navKey.currentContext!.tr("otp_verified"));

        state = state.copyWith(verifyOtpApiResponse: ApiResponse.completed(response['data']));
        // Navigate to complete profile or next step
        await SecureStorageManager.sharedInstance.storeToken(response['access_token'] ?? "");
        AppRouter.push(CreateProfileView());

      }
      else{
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("invalid_otp"),
        );
        state = state.copyWith(verifyOtpApiResponse: ApiResponse.error());
      }
    } catch (e) {
       Navigator.of(AppRouter.navKey.currentContext!).pop();
      if (!ref.mounted) return;
      Helper.showMessage(
        AppRouter.navKey.currentContext!,
        message: AppRouter.navKey.currentContext!.tr("something_went_wrong_try_again"),
      );
      state = state.copyWith(verifyOtpApiResponse: ApiResponse.error());
    }
  }

  FutureOr<void> resendOtp({required bool isSignup})async{
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
        AppRouter.pushReplacement(OtpView(isSignup: isSignup,));

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
      final response = await MyHttpClient.instance.post(ApiEndpoints.completeProfile, profileData,);
      if (!ref.mounted) return;

      if(response != null && !(response is Map && response.containsKey('detail'))){
        Helper.showMessage( AppRouter.navKey.currentContext!,message: AppRouter.navKey.currentContext!.tr("profile_completed"));

        state = state.copyWith(completeProfileApiResponse: ApiResponse.completed(response['data']));
        final Map<String, dynamic>? user = response["user"];
        if(user != null){
          savedUserData(user);
        }
        await SecureStorageManager.sharedInstance.storeToken(response['access_token'] ?? "");
        await SecureStorageManager.sharedInstance.storeRefreshToken(response['refresh_token'] ?? "");
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
        final Map<String, dynamic>? user = response;
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

  FutureOr<void> updateProfile({required UserDataModel userDataModel, bool? onBackground = false, bool? showMessage = false})async{
   
    if(!onBackground!){
      if (!ref.mounted) return;
       try {
      state = state.copyWith(updateProfileApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.put(ApiEndpoints.updateProfile, userDataModel.toJson());


      if(response != null && !(response is Map && response.containsKey('detail'))){
        if(showMessage!){
        Helper.showMessage( AppRouter.navKey.currentContext!,message: AppRouter.navKey.currentContext!.tr("profile_updated_successfully"));

        }

        state = state.copyWith(updateProfileApiResponse: ApiResponse.completed(response));
        final Map<String, dynamic>? user = response['user'];
        if(user != null){
          savedUserData(user);
        }

      }
      else{
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_update_profile"),
        );
        state = state.copyWith(updateProfileApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      Helper.showMessage(
        AppRouter.navKey.currentContext!,
        message: AppRouter.navKey.currentContext!.tr("something_went_wrong_try_again"),
      );
      state = state.copyWith(updateProfileApiResponse: ApiResponse.error());
    }
    }
    else{
      
       try {
        final response = await MyHttpClient.instance.put(ApiEndpoints.updateProfile, userDataModel.toJson());
      if(response != null && (response is Map && response.containsKey('user'))){
         final Map<String, dynamic>? user = response['user'];
        if(user != null){
          savedUserData(user,isSet: false);
        }
      }
    } catch (e) {
      throw Exception(e);
       }
    }
   
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

  FutureOr<void> uploadImage({required File file}) async {
    if (!ref.mounted) return;
    try {
      state = state.copyWith(uploadImageApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.post(ApiEndpoints.imageUpload, {"files": file, "folder" : "profile_image"}, variableName: 'file', isMultipartRequest: true);
      if (!ref.mounted) return;

      if (response != null && !(response is Map && response.containsKey('detail'))) {
        try {
          String imageUrl = response['url'];
          Helper.showMessage(AppRouter.navKey.currentContext!, message: AppRouter.navKey.currentContext!.tr("image_uploaded_successfully"));
          state = state.copyWith(uploadImageApiResponse: ApiResponse.completed(response), imageUrl: imageUrl);
        } catch (e) {
          Helper.showMessage(
            AppRouter.navKey.currentContext!,
            message: AppRouter.navKey.currentContext!.tr("something_went_wrong_try_again"),
          );
          state = state.copyWith(uploadImageApiResponse: ApiResponse.error());
        }
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_upload_image"),
        );
        state = state.copyWith(uploadImageApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(uploadImageApiResponse: ApiResponse.error());
    }
  }

  FutureOr<void> removeImage({required String imageUrl}) async {
    if (!ref.mounted) return;
    try {
      state = state.copyWith(removeImageApiResponse: ApiResponse.loading(), imageUrl: "");
      final response = await MyHttpClient.instance.delete(ApiEndpoints.imageDelete, {"url": imageUrl});
      if (!ref.mounted) return;

      if (response != null && !(response is Map && response.containsKey('detail'))) {
        try {
          // Assuming success response structure
          
          Helper.showMessage(AppRouter.navKey.currentContext!, message: AppRouter.navKey.currentContext!.tr("image_removed_successfully"));
          state = state.copyWith(removeImageApiResponse: ApiResponse.completed(response,), userData: state.userData!.profileImage != ""? state.userData!.copyWith(
            profileImage: ""
          ) : null);
        } catch (e) {
          Helper.showMessage(
            AppRouter.navKey.currentContext!,
            message: AppRouter.navKey.currentContext!.tr("something_went_wrong_try_again"),
          );
          state = state.copyWith(removeImageApiResponse: ApiResponse.error());
        }
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_remove_image"),
        );
        state = state.copyWith(removeImageApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(removeImageApiResponse: ApiResponse.error());
    }
  }

  FutureOr<void> refreshToken()async{
    try {
      final refreshToken = await SecureStorageManager.sharedInstance.getRefreshToken() ?? ""  ;
      if(refreshToken != ""){
         final response = await MyHttpClient.instance.post(ApiEndpoints.refresh, {
  "refresh_token": refreshToken
});
  SecureStorageManager.sharedInstance.clearRefreshToken();
      if(response != null){
        await SecureStorageManager.sharedInstance.storeToken(response['access_token'] ?? "");
        await SecureStorageManager.sharedInstance.storeRefreshToken(response['refresh_token'] ?? "");

      }
      }
      else{
        SecureStorageManager.sharedInstance.clearAll();

          AppRouter.pushAndRemoveUntil(const LoginView());
          Helper.showMessage( AppRouter.navKey.currentContext!,message: AppRouter.navKey.currentContext!.tr("please_login_again"));
        
      }
     
    } catch (e) {
      SecureStorageManager.sharedInstance.clearAll();

          AppRouter.pushAndRemoveUntil(const LoginView());
          Helper.showMessage( AppRouter.navKey.currentContext!,message: AppRouter.navKey.currentContext!.tr("please_login_again"));
        
      throw Exception(e);
      
    }
  }
  
   
  Future<void> savedUserData(Map<String, dynamic> userMap, {bool? isSet = true}) async {
    String user = jsonEncode(userMap);
    await SecureStorageManager.sharedInstance.storeUser(user);
    if(isSet!){
    await userSet();

    }
  }

  Future<void> userSet() async {

    String? userData = await SecureStorageManager.sharedInstance.getUserData();
    if (userData != null) {
      Map<String, dynamic> userJson = jsonDecode(userData);
      state = state.copyWith(userData: UserDataModel.fromJson(userJson));
    }

  }
  void toggleTravelMode(bool chk){
    state = state.copyWith(userData:state.userData!.copyWith(isTravelMode: chk));
  }
  
  void imageUnset(){
    state = state.copyWith(imageUrl: "");
  }


}
final authProvider = NotifierProvider<AuthProvider, AuthState>(
  AuthProvider.new,
);
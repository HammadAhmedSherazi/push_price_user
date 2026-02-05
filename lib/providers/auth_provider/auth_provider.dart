import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:push_price_user/data/network/api_response.dart';
import 'package:push_price_user/export_all.dart';
import 'package:push_price_user/models/subscription_plan_data_model.dart';
import 'package:push_price_user/providers/auth_provider/auth_state.dart';
import 'package:push_price_user/views/auth/otp_view.dart';

class AuthProvider extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState(
      loginApiResponse: ApiResponse.undertermined(),
      registrationApiResponse: ApiResponse.undertermined(),
      verifyOtpApiResponse: ApiResponse.undertermined(),
      resendOtpApiResponse: ApiResponse.undertermined(),
      completeProfileApiResponse: ApiResponse.undertermined(),
      forgotPasswordApiResponse: ApiResponse.undertermined(),
      resetPasswordApiResponse: ApiResponse.undertermined(),
      getUserApiResponse: ApiResponse.undertermined(),
      getStoresApiRes: ApiResponse.undertermined(),
      getCategoriesApiResponse: ApiResponse.undertermined(),
      uploadImageApiResponse: ApiResponse.undertermined(),
      removeImageApiResponse: ApiResponse.undertermined(),
      updateProfileApiResponse: ApiResponse.undertermined(),
      logoutApiResponse: ApiResponse.undertermined(),
      subscriptionPlanApiRes: ApiResponse.undertermined(),
      subcribeNow: ApiResponse.undertermined(),
      mySubcribePlanRes: ApiResponse.undertermined(),

      categories: [],
      categoriesSkip: 0,
    );
  }

  String emailText = "";
  FutureOr<void> login({
    required String email,
    required String password,
  }) async {
    emailText = email;
    if (!ref.mounted) return;
    try {
      state = state.copyWith(loginApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.post(ApiEndpoints.login, {
        "email": email,
        "password": password,
      }, isToken: false);
      if (!ref.mounted) return;

      // Add condition check
      if (response != null &&
          !(response is Map && response.containsKey('detail'))) {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: AppRouter.navKey.currentContext!.tr("successfully_login"),
        );

        state = state.copyWith(
          loginApiResponse: ApiResponse.completed(response['data']),
        );
        final Map<String, dynamic>? user = response["user"];
        if (user != null) {
          savedUserData(user);
        }
        await SecureStorageManager.sharedInstance.storeToken(
          response['access_token'] ?? "",
        );
        await SecureStorageManager.sharedInstance.storeRefreshToken(
          response['refresh_token'] ?? "",
        );
        AppRouter.pushAndRemoveUntil(NavigationView());
      } else {
        // Show error message if condition is false
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail'))
              ? response['detail'] as String
              : AppRouter.navKey.currentContext!.tr(
                  "something_went_wrong_try_again",
                ),
        );
        state = state.copyWith(loginApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      // Show error message for exceptions
      Helper.showMessage(
        AppRouter.navKey.currentContext!,
        message: AppRouter.navKey.currentContext!.tr(
          "something_went_wrong_try_again",
        ),
      );
      state = state.copyWith(loginApiResponse: ApiResponse.error());
    }
  }

  FutureOr<void> logout() async {
    if (!ref.mounted) return;

    try {
      // Make API call to logout
      state = state.copyWith(logoutApiResponse: ApiResponse.loading());
      String? refreshToken = await SecureStorageManager.sharedInstance
          .getRefreshToken();
      final response = await MyHttpClient.instance.post(ApiEndpoints.logout, {
        "refresh_token": refreshToken ?? "",
      });
      AppRouter.back();
      if (response != null &&
          !(response is Map && response.containsKey('detail'))) {
        state = state.copyWith(
          logoutApiResponse: ApiResponse.completed(response),
        );
        // Clear local data
        await SecureStorageManager.sharedInstance.clearAll();
        AppRouter.pushAndRemoveUntil(LoginView());
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail'))
              ? response['detail'] as String
              : AppRouter.navKey.currentContext!.tr(
                  "something_went_wrong_try_again",
                ),
        );
        state = state.copyWith(logoutApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(logoutApiResponse: ApiResponse.error());
      // Even if API call fails, clear local data and logout
      await SecureStorageManager.sharedInstance.clearAll();
      AppRouter.pushAndRemoveUntil(LoginView());
    }
  }

  FutureOr<void> registration({
    required String email,
    required String password,
  }) async {
    emailText = email;
    if (!ref.mounted) return;
    try {
      state = state.copyWith(registrationApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.post(ApiEndpoints.register, {
        "email": email,
        "password": password,
      }, isToken: false);
      if (!ref.mounted) return;

      // Add condition check
      if (response != null &&
          !(response is Map && response.containsKey('detail'))) {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: AppRouter.navKey.currentContext!.tr(
            "registration_successful",
          ),
        );

        state = state.copyWith(
          registrationApiResponse: ApiResponse.completed(response['data']),
        );

        // Navigate to OTP verification or next step
        AppRouter.push(OtpView(isSignup: true)); // Assuming such a view exists
      } else {
        // Show error message if condition is false
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail'))
              ? response['detail'] as String
              : AppRouter.navKey.currentContext!.tr(
                  "something_went_wrong_try_again",
                ),
        );
        state = state.copyWith(registrationApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;

      // Show error message for exceptions
      Helper.showMessage(
        AppRouter.navKey.currentContext!,
        message: AppRouter.navKey.currentContext!.tr(
          "something_went_wrong_try_again",
        ),
      );
      state = state.copyWith(registrationApiResponse: ApiResponse.error());
    }
  }

  FutureOr<void> verifyOtp({required String otp}) async {
    imageUnset();
    Helper.showFullScreenLoader(
      AppRouter.navKey.currentContext!,
      dismissible: false,
    );

    if (!ref.mounted) return;
    try {
      state = state.copyWith(verifyOtpApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.post(
        ApiEndpoints.verifyOtp,
        {"email": emailText, "otp_code": otp},
        isToken: false,
      );
      Navigator.of(AppRouter.navKey.currentContext!).pop();
      if (!ref.mounted) return;

      if (response != null &&
          !(response is Map && response.containsKey('detail'))) {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: AppRouter.navKey.currentContext!.tr("otp_verified"),
        );

        state = state.copyWith(
          verifyOtpApiResponse: ApiResponse.completed(response['data']),
        );
        // Navigate to complete profile or next step
      
          await SecureStorageManager.sharedInstance.storeToken(
            response['access_token'] ?? "",
          );
          AppRouter.push(CreateProfileView());
        
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail'))
              ? response['detail'] as String
              : AppRouter.navKey.currentContext!.tr("invalid_otp"),
        );
        state = state.copyWith(verifyOtpApiResponse: ApiResponse.error());
      }
    } catch (e) {
      Navigator.of(AppRouter.navKey.currentContext!).pop();
      if (!ref.mounted) return;
      Helper.showMessage(
        AppRouter.navKey.currentContext!,
        message: AppRouter.navKey.currentContext!.tr(
          "something_went_wrong_try_again",
        ),
      );
      state = state.copyWith(verifyOtpApiResponse: ApiResponse.error());
    }
  }

  FutureOr<void> resendOtp({required bool isSignup}) async {
    if (!ref.mounted) return;
    try {
      // Show full screen loader dialog
      Helper.showFullScreenLoader(
        AppRouter.navKey.currentContext!,
        dismissible: false,
      );
      state = state.copyWith(resendOtpApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.post(
        ApiEndpoints.resendOtp,
        {"email": emailText},
        isToken: false,
      );
      // Dismiss the loader
      Navigator.of(AppRouter.navKey.currentContext!).pop();
      if (!ref.mounted) return;

      if (response != null &&
          !(response is Map && response.containsKey('detail'))) {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: AppRouter.navKey.currentContext!.tr("otp_resent"),
        );

        state = state.copyWith(
          resendOtpApiResponse: ApiResponse.completed(response['data']),
        );
        AppRouter.pushReplacement(OtpView(isSignup: isSignup));
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail'))
              ? response['detail'] as String
              : AppRouter.navKey.currentContext!.tr("failed_to_resend_otp"),
        );
        state = state.copyWith(resendOtpApiResponse: ApiResponse.error());
      }
    } catch (e) {
      // Dismiss the loader on error
      Navigator.of(AppRouter.navKey.currentContext!).pop();
      if (!ref.mounted) return;
      Helper.showMessage(
        AppRouter.navKey.currentContext!,
        message: AppRouter.navKey.currentContext!.tr(
          "something_went_wrong_try_again",
        ),
      );
      state = state.copyWith(resendOtpApiResponse: ApiResponse.error());
    }
  }

  FutureOr<void> completeProfile({
    required Map<String, dynamic> profileData,
  }) async {
    if (!ref.mounted) return;
    // AppRouter.push(SubscriptionPlanView(isPro: true,));
    try {
      state = state.copyWith(completeProfileApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.post(
        ApiEndpoints.completeProfile,
        profileData,
      );
      if (!ref.mounted) return;

      if (response != null &&
          !(response is Map && response.containsKey('detail'))) {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: AppRouter.navKey.currentContext!.tr("profile_completed"),
        );

        state = state.copyWith(
          completeProfileApiResponse: ApiResponse.completed(response['data']),
        );
        final Map<String, dynamic>? user = response["user"];
        if (user != null) {
          savedUserData(user);
        }
        await SecureStorageManager.sharedInstance.storeToken(
          response['access_token'] ?? "",
        );
        await SecureStorageManager.sharedInstance.storeRefreshToken(
          response['refresh_token'] ?? "",
        );
        AppRouter.push(SubscriptionPlanView(isPro: true, fromSignup: true));
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail'))
              ? response['detail'] as String
              : AppRouter.navKey.currentContext!.tr(
                  "failed_to_complete_profile",
                ),
        );
        state = state.copyWith(completeProfileApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      Helper.showMessage(
        AppRouter.navKey.currentContext!,
        message: AppRouter.navKey.currentContext!.tr(
          "something_went_wrong_try_again",
        ),
      );
      state = state.copyWith(completeProfileApiResponse: ApiResponse.error());
    }
  }

  FutureOr<void> forgotPassword({required String email, required String password}) async {
    emailText = email;
    if (!ref.mounted) return;
    try {
      state = state.copyWith(forgotPasswordApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.post(
        ApiEndpoints.forgotPassword,
        {"email": email},
        isToken: false,
      );
      if (!ref.mounted) return;

      if (response != null &&
          !(response is Map && response.containsKey('detail'))) {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: AppRouter.navKey.currentContext!.tr("otp_sent_to_email"),
        );

        state = state.copyWith(
          forgotPasswordApiResponse: ApiResponse.completed(response['data']),
        );
        AppRouter.push(OtpView(passWord: password));
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail'))
              ? response['detail'] as String
              : AppRouter.navKey.currentContext!.tr(
                  "something_went_wrong_try_again",
                ),
        );
        state = state.copyWith(forgotPasswordApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      Helper.showMessage(
        AppRouter.navKey.currentContext!,
        message: AppRouter.navKey.currentContext!.tr(
          "something_went_wrong_try_again",
        ),
      );
      state = state.copyWith(forgotPasswordApiResponse: ApiResponse.error());
    }
  }

  FutureOr<void> resetPassword({
    required String password,
    required String otp,
  }) async {
    if (!ref.mounted) return;
    try {
      state = state.copyWith(resetPasswordApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.post(
        ApiEndpoints.resetPassword,
        {"email": emailText, "otp_code": otp, "new_password": password},
        isToken: false,
      );
      if (!ref.mounted) return;

      if (response != null &&
          !(response is Map && response.containsKey('detail'))) {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: AppRouter.navKey.currentContext!.tr(
            "password_reset_successfully",
          ),
        );

        state = state.copyWith(
          resetPasswordApiResponse: ApiResponse.completed(response['data']),
        );
        AppRouter.customback(times: 2);
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail'))
              ? response['detail'] as String
              : AppRouter.navKey.currentContext!.tr("failed_to_reset_password"),
        );
        state = state.copyWith(resetPasswordApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      Helper.showMessage(
        AppRouter.navKey.currentContext!,
        message: AppRouter.navKey.currentContext!.tr(
          "something_went_wrong_try_again",
        ),
      );
      state = state.copyWith(resetPasswordApiResponse: ApiResponse.error());
    }
  }

  FutureOr<void> getUser() async {
    if (!ref.mounted) return;
    try {
      state = state.copyWith(getUserApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.get(ApiEndpoints.getUser);
      if (!ref.mounted) return;

      if (response != null) {
        state = state.copyWith(
          getUserApiResponse: ApiResponse.completed(response),
        );
        final Map<String, dynamic>? user = response;
        if (user != null) {
          savedUserData(user);
        }
      } else {
        state = state.copyWith(getUserApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(getUserApiResponse: ApiResponse.error());
    }
  }

  FutureOr<void> updateProfile({
    required UserDataModel userDataModel,
    bool? onBackground = false,
    bool? showMessage = false,
  }) async {
    if (!onBackground!) {
      if (!ref.mounted) return;
      try {
        state = state.copyWith(updateProfileApiResponse: ApiResponse.loading());

        final response = await MyHttpClient.instance.put(
          ApiEndpoints.updateProfile,
          userDataModel.toJson(),
        );

        if (response != null &&
            !(response is Map && response.containsKey('detail'))) {
          if (showMessage!) {
            Helper.showMessage(
              AppRouter.navKey.currentContext!,
              message: AppRouter.navKey.currentContext!.tr(
                "profile_updated_successfully",
              ),
            );
          }

          state = state.copyWith(
            updateProfileApiResponse: ApiResponse.completed(response),
          );
          final Map<String, dynamic>? user = response['user'];
          if (user != null) {
            savedUserData(user);
          }
        } else {
          Helper.showMessage(
            AppRouter.navKey.currentContext!,
            message: (response is Map && response.containsKey('detail'))
                ? response['detail'] as String
                : AppRouter.navKey.currentContext!.tr(
                    "failed_to_update_profile",
                  ),
          );
          state = state.copyWith(updateProfileApiResponse: ApiResponse.error());
        }
      } catch (e) {
        if (!ref.mounted) return;
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: AppRouter.navKey.currentContext!.tr(
            "something_went_wrong_try_again",
          ),
        );
        state = state.copyWith(updateProfileApiResponse: ApiResponse.error());
      }
    } else {
      try {
        final response = await MyHttpClient.instance.put(
          ApiEndpoints.updateProfile,
          userDataModel.toJson(),
        );
        if (response != null &&
            (response is Map && response.containsKey('user'))) {
          final Map<String, dynamic>? user = response['user'];
          if (user != null) {
            savedUserData(user, isSet: false);
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

      if (response != null &&
          !(response is Map && response.containsKey('detail'))) {
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
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail'))
              ? response['detail'] as String
              : AppRouter.navKey.currentContext!.tr("failed_to_get_categories"),
        );
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
      final response = await MyHttpClient.instance.post(
        ApiEndpoints.imageUpload,
        {"files": file, "folder": "profile_image"},
        variableName: 'file',
        isMultipartRequest: true,
      );
      if (!ref.mounted) return;

      if (response != null &&
          !(response is Map && response.containsKey('detail'))) {
        try {
          String imageUrl = response['url'];
          Helper.showMessage(
            AppRouter.navKey.currentContext!,
            message: AppRouter.navKey.currentContext!.tr(
              "image_uploaded_successfully",
            ),
          );
          state = state.copyWith(
            uploadImageApiResponse: ApiResponse.completed(response),
            imageUrl: imageUrl,
          );
        } catch (e) {
          Helper.showMessage(
            AppRouter.navKey.currentContext!,
            message: AppRouter.navKey.currentContext!.tr(
              "something_went_wrong_try_again",
            ),
          );
          state = state.copyWith(uploadImageApiResponse: ApiResponse.error());
        }
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail'))
              ? response['detail'] as String
              : AppRouter.navKey.currentContext!.tr("failed_to_upload_image"),
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
      state = state.copyWith(
        removeImageApiResponse: ApiResponse.loading(),
        imageUrl: "",
      );
      final response = await MyHttpClient.instance.delete(
        ApiEndpoints.imageDelete,
        {"url": imageUrl},
      );
      if (!ref.mounted) return;

      if (response != null &&
          !(response is Map && response.containsKey('detail'))) {
        try {
          // Assuming success response structure

          Helper.showMessage(
            AppRouter.navKey.currentContext!,
            message: AppRouter.navKey.currentContext!.tr(
              "image_removed_successfully",
            ),
          );
          state = state.copyWith(
            removeImageApiResponse: ApiResponse.completed(response),
            userData: state.userData!.profileImage != ""
                ? state.userData!.copyWith(profileImage: "")
                : null,
          );
        } catch (e) {
          Helper.showMessage(
            AppRouter.navKey.currentContext!,
            message: AppRouter.navKey.currentContext!.tr(
              "something_went_wrong_try_again",
            ),
          );
          state = state.copyWith(removeImageApiResponse: ApiResponse.error());
        }
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail'))
              ? response['detail'] as String
              : AppRouter.navKey.currentContext!.tr("failed_to_remove_image"),
        );
        state = state.copyWith(removeImageApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(removeImageApiResponse: ApiResponse.error());
    }
  }

  static Completer<void>? _refreshCompleter;

  /// Refresh fail / session invalid — SecureStorage (token, userData) + SharedPreference (profile, cart) clear, phir login.
  Future<void> _clearUserSessionAndGoToLogin() async {
    await SecureStorageManager.sharedInstance.clearAll();
    await SharedPreferenceManager.sharedInstance.clearUserSession();
    AppRouter.pushAndRemoveUntil(const LoginView());
    Helper.showMessage(
      AppRouter.navKey.currentContext!,
      message: AppRouter.navKey.currentContext!.tr("please_login_again"),
    );
  }

  /// Refresh token — ek time par sirf ek refresh chalti hai; baaki callers usi ka wait karte hain.
  /// Refresh token tab hi clear hota hai jab response valid ho ya hum login pe bhej rahe hon.
  FutureOr<void> refreshToken() async {
    if (_refreshCompleter != null) {
      await _refreshCompleter!.future;
      return;
    }
    _refreshCompleter = Completer<void>();
    try {
      final refreshTokenValue =
          await SecureStorageManager.sharedInstance.getRefreshToken() ?? "";
      if (refreshTokenValue.isNotEmpty) {
        final response = await MyHttpClient.instance.post(
          ApiEndpoints.refresh,
          {"refresh_token": refreshTokenValue},
          isToken: false,
        );
        if (response != null &&
            response['access_token'] != null &&
            (response['access_token'] as String).isNotEmpty) {
          await SecureStorageManager.sharedInstance.storeToken(
            response['access_token'] ?? "",
          );
          await SecureStorageManager.sharedInstance.storeRefreshToken(
            response['refresh_token'] ?? "",
          );
        } else {
          await _clearUserSessionAndGoToLogin();
        }
      } else {
        await _clearUserSessionAndGoToLogin();
      }
    } catch (e) {
      await _clearUserSessionAndGoToLogin();
      throw Exception(e);
    } finally {
      _refreshCompleter?.complete();
      _refreshCompleter = null;
    }
  }

  Future<void> savedUserData(
    Map<String, dynamic> userMap, {
    bool? isSet = true,
  }) async {
    String user = jsonEncode(userMap);
    await SecureStorageManager.sharedInstance.storeUser(user);
    if (isSet!) {
      await userSet();
    }
  }

  Future<void> userSet() async {
    String? userData = await SecureStorageManager.sharedInstance.getUserData();
    if (userData != null) {
      Map<String, dynamic> userJson = jsonDecode(userData);
      final UserDataModel user = UserDataModel.fromJson(userJson);
      state = state.copyWith(userData: user);
      if ((user.deviceToken == "" && FirebaseService.fcmToken != "" )|| user.deviceToken != FirebaseService.fcmToken) {
        updateProfile(
          userDataModel: user.copyWith(deviceToken: FirebaseService.fcmToken),
        );
      }
    }
  }

  /// Restores auth state from SecureStorage (token + userData). Call after app open when user has valid token.
  Future<void> restoreUserFromCache() async {
    await userSet();
  }

  FutureOr<void> getSubscriptionPlan() async {
    if (!ref.mounted) return;
    try {
      state = state.copyWith(subscriptionPlanApiRes: ApiResponse.loading());
      final response = await MyHttpClient.instance.get(ApiEndpoints.subscriptionPlan, isToken: false);
      if (!ref.mounted) return;

      if (response != null) {
        List temp = response;
        state = state.copyWith(
          subscriptionPlanApiRes: ApiResponse.completed(List.from(temp.map((e)=>SubscriptionPlanModel.fromJson(e))),),
        );
        
      } else {
        state = state.copyWith(subscriptionPlanApiRes: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(subscriptionPlanApiRes: ApiResponse.error());
    }
  }

  FutureOr<void> getMySubscriptionPlan() async {
    if (!ref.mounted) return;
    try {
      state = state.copyWith(mySubcribePlanRes: ApiResponse.loading());
      final response = await MyHttpClient.instance.get(ApiEndpoints.mySubscriptionPlan);
      if (!ref.mounted) return;

      if (response != null) {
        
        state = state.copyWith(
          mySubcribePlanRes: ApiResponse.completed(SubscriptionModel.fromJson(response)),
        );
        
      } else {
        state = state.copyWith(mySubcribePlanRes: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(mySubcribePlanRes: ApiResponse.error());
    }
  }


  FutureOr<void> subcribeNow({
    required String type,
    bool fromSignUp = false,
  }) async {
    if (!ref.mounted) return;
   

    try {
      state = state.copyWith(subcribeNow: ApiResponse.loading());
      

      // Create payment intent
      final intentResponse = await MyHttpClient.instance.post(
        ApiEndpoints.subscriptionIntent,
        {
  "plan_type": type
},
      );

      if (!ref.mounted) return;

      if (intentResponse != null &&
          !(intentResponse is Map && intentResponse.containsKey('detail'))) {
        String clientSecret = intentResponse['client_secret'];
        final paymentIntentId = intentResponse['payment_intent_id'];
        if(type == "PRO"){
           await makePayment(clientSecret);
        // state = state.copyWith(payNowApiResponse: ApiResponse.completed(intentResponse));

          confirmPayment(paymentIntentId, fromSignUp: fromSignUp);
        }
        else{
           state = state.copyWith(
          subcribeNow: ApiResponse.completed(intentResponse),
        );
        if (fromSignUp) AppRouter.pushReplacement(AddFavouriteView());
        }
        // Make payment with Stripe
       
      } else {
        state = state.copyWith(subcribeNow: ApiResponse.error());
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message:
              (intentResponse is Map && intentResponse.containsKey('detail'))
              ? intentResponse['detail'] as String
              : AppRouter.navKey.currentContext!.tr(
                  "payment_intent_creation_failed",
                ),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(subcribeNow: ApiResponse.error());
      Helper.showMessage(
        AppRouter.navKey.currentContext!,
        message: AppRouter.navKey.currentContext!.tr('unable_to_process_payment'),
      );
    }
  }

  Future<void> confirmPayment(String paymentIntentId, {bool fromSignUp = false}) async {
    try {
      if (!ref.mounted) return;
      // Confirm payment
      final confirmResponse = await MyHttpClient.instance.post(
        ApiEndpoints.subscriptionConfirm,
        {"payment_intent_id": paymentIntentId},
      );
      if (confirmResponse != null &&
          !(confirmResponse is Map && confirmResponse.containsKey('detail'))) {
        state = state.copyWith(
          subcribeNow: ApiResponse.completed(confirmResponse),
        );
        if (fromSignUp) AppRouter.pushReplacement(AddFavouriteView());
      } else {
        state = state.copyWith(subcribeNow: ApiResponse.error());
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message:
              (confirmResponse is Map && confirmResponse.containsKey('detail'))
              ? confirmResponse['detail'] as String
              : AppRouter.navKey.currentContext!.tr(
                  "payment_confirmation_failed",
                ),
        );
      }
    } catch (e) {
      state = state.copyWith(subcribeNow: ApiResponse.error());
    }
  }

  Future<void> makePayment(String clientSecret) async {
    try {
      // Optionally collect card details
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Your App Name',
        ),
      );

      // Present the payment sheet
      await Stripe.instance.presentPaymentSheet();

    } catch (e) {
      rethrow; // Rethrow to handle in payNow
    }
  }


  void toggleTravelMode(bool chk) {
    state = state.copyWith(
      userData: state.userData!.copyWith(isTravelMode: chk),
    );
  }

  void imageUnset() {
    state = state.copyWith(imageUrl: "");
  }
}

final authProvider = NotifierProvider<AuthProvider, AuthState>(
  AuthProvider.new,
);

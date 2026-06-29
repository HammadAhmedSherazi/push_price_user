import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../data/network/api_endpoints.dart';
import '../models/user_data_model.dart';
import '../services/base_api_services.dart';
import '../services/secure_storage.dart';

class BackgroundLocationUpdateInput {
  final String token;
  final String url;
  final Map<String, dynamic> userPayload;

  const BackgroundLocationUpdateInput({
    required this.token,
    required this.url,
    required this.userPayload,
  });
}

@pragma('vm:entry-point')
Future<String?> updateOnBackgroundProfileUpdate(
  BackgroundLocationUpdateInput input,
) async {
  try {
    final response = await http
        .put(
          Uri.parse(input.url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${input.token}',
          },
          body: jsonEncode(input.userPayload),
        )
        .timeout(const Duration(seconds: 35));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return utf8.decode(response.bodyBytes);
    }
  } catch (_) {}
  return null;
}

@pragma('vm:entry-point')
UserDataModel parseUserJson(String jsonStr) =>
    UserDataModel.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);

class BackgroundLocationService {
  BackgroundLocationService._();

  static Future<void> updateTravelModeLocation({
    required UserDataModel userData,
    required double latitude,
    required double longitude,
  }) async {
    final token = await SecureStorageManager.sharedInstance.getToken();
    if (token == null || token.isEmpty) return;

    final payload = userData
        .copyWith(
          latitude: latitude,
          longitude: longitude,
        )
        .toJson();

    final responseBody = await compute(
      updateOnBackgroundProfileUpdate,
      BackgroundLocationUpdateInput(
        token: token,
        url: '${BaseApiServices.baseURL}${ApiEndpoints.updateProfile}',
        userPayload: payload,
      ),
    );

    if (responseBody == null) return;

    final response = jsonDecode(responseBody) as Map<String, dynamic>;
    final user = response['user'];
    if (user is Map<String, dynamic>) {
      await SecureStorageManager.sharedInstance.storeUser(jsonEncode(user));
    }
  }
}

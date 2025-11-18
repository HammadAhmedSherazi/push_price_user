class UserDataModel {
  final int userId;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String address;
  final String? profileImage, deviceToken;
  final bool isVerified;
  final bool isActive;
  final bool isTravelMode;
  final String createdAt;
  final String updatedAt;
  final num latitude, longitude;
  final bool isEnableNotification;

  const UserDataModel({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    this.profileImage,
    this.deviceToken,
    required this.isVerified,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.isTravelMode,
    required this.latitude,
    required this.longitude,
    required this.isEnableNotification,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      userId: json['user_id'] ?? 0,
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      address: json['address'] ?? '',
      profileImage: json['profile_image'],
      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      isTravelMode: json['is_travel_enabled'] ?? false,
      longitude: json['longitude'] ?? 0,
      latitude: json['latitude'] ?? 0,
      deviceToken: json['device_token'] ?? "",
      isEnableNotification: json['enable_notification'] ?? false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'address': address,
      'profile_image': profileImage,
      'is_verified': isVerified,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_travel_enabled' : isTravelMode,
      'longitude' : longitude,
      'latitude' : latitude,
      'device_token' : deviceToken,
      'enable_notification' : isEnableNotification
    };
    
  }



  UserDataModel copyWith({
    int? userId,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? address,
    String? profileImage,
    bool? isVerified,
    bool? isActive,
    String? createdAt,
    String? updatedAt,
    num? latitude, longitude,
    bool? isTravelMode,
    String? deviceToken,
    bool? isEnableNotification,
  }) {
    return UserDataModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      profileImage: profileImage ?? this.profileImage,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isTravelMode: isTravelMode ?? this.isTravelMode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      deviceToken: deviceToken ?? this.deviceToken,
      isEnableNotification: isEnableNotification ?? this.isEnableNotification
    );
  }

  // @override
  // String toString() {
  //   return 'UserDataModel(userId: $userId, email: $email, fullName: $fullName, phoneNumber: $phoneNumber, address: $address, profileImage: $profileImage, isVerified: $isVerified, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, deviceToken : $deviceToken)';
  // }
}
  
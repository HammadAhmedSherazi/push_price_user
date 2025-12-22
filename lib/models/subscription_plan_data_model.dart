class SubscriptionPlanModel {
  final int planId;
  final String planType;
  final String name;
  final double price;
  final String billingPeriod;
  final List<BenefitModel> benefits;

  const SubscriptionPlanModel({
    required this.planId,
    required this.planType,
    required this.name,
    required this.price,
    required this.billingPeriod,
    required this.benefits,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      planId: json['plan_id'] ?? 0,
      planType: json['plan_type'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      billingPeriod: json['billing_period'] ?? '',
      benefits: (json['benefits'] as List<dynamic>?)
              ?.map((e) => BenefitModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plan_id': planId,
      'plan_type': planType,
      'name': name,
      'price': price,
      'billing_period': billingPeriod,
      'benefits': benefits.map((e) => e.toJson()).toList(),
    };
  }
}

class BenefitModel {
  final String title;
  final String subtitle;

  const BenefitModel({
    required this.title,
    required this.subtitle,
  });

  factory BenefitModel.fromJson(Map<String, dynamic> json) {
    return BenefitModel(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
    };
  }
}
class SubscriptionModel {
  final int subscriptionId;
  final String planType;
  final bool isPro;
  final String status;
  final DateTime startedAt;
  final DateTime expiresAt;
  final bool autoRenew;
  final double price;
  final String billingPeriod;
  final List<BenefitModel> benefits;

  const SubscriptionModel({
    required this.subscriptionId,
    required this.planType,
    required this.isPro,
    required this.status,
    required this.startedAt,
    required this.expiresAt,
    required this.autoRenew,
    required this.benefits,
    required this.price,
    required this.billingPeriod,
  });

  /// FROM JSON
  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      subscriptionId: json['subscription_id'] as int,
      planType: json['plan_type'] as String,
      isPro: json['is_pro'] as bool,
      status: json['status'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
      autoRenew: json['auto_renew'] as bool,
        price: (json['price'] ?? 0).toDouble(),
      billingPeriod: json['billing_period'] ?? '',
      benefits: (json['benefits'] as List<dynamic>?)
              ?.map((e) => BenefitModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  /// TO JSON
  Map<String, dynamic> toJson() {
    return {
      'subscription_id': subscriptionId,
      'plan_type': planType,
      'is_pro': isPro,
      'status': status,
      'started_at': startedAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'auto_renew': autoRenew,
      'benefits': benefits.map((e) => e.toJson()).toList(),
    };
  }

  /// COPY WITH
  SubscriptionModel copyWith({
    int? subscriptionId,
    String? planType,
    bool? isPro,
    String? status,
    DateTime? startedAt,
    DateTime? expiresAt,
    bool? autoRenew,
    double? price,
  String? billingPeriod,
   List<BenefitModel>? benefits
  }) {
    return SubscriptionModel(
      subscriptionId: subscriptionId ?? this.subscriptionId,
      planType: planType ?? this.planType,
      isPro: isPro ?? this.isPro,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      autoRenew: autoRenew ?? this.autoRenew,
      benefits: benefits ?? this.benefits,
      price: price ?? this.price,
      billingPeriod: billingPeriod ?? this.billingPeriod
    );
  }
}

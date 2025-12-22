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

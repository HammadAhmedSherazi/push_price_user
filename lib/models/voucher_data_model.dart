import 'package:flutter/material.dart';

import '../utils/localization_service.dart';

class VoucherModel {
  final String code;
  final String description;
  final String discountType;
  final num discountValue;
  final num discountAmount;
  final num finalAmount;
  final int maxUses;
  final int usedCount;
  final num minOrderAmount;
  final DateTime validFrom;
  final DateTime validTo;
  final bool isActive;

  const VoucherModel({
    required this.code,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.discountAmount,
    required this.finalAmount,
    required this.maxUses,
    required this.usedCount,
    required this.minOrderAmount,
    required this.validFrom,
    required this.validTo,
    required this.isActive,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      discountType: json['discount_type'] ?? '',
      discountValue: json['discount_value'] ?? 0,
      discountAmount: json['discount_amount'] ?? 0,
      finalAmount: json['final_amount'] ?? 0,
      maxUses: json['max_uses'] ?? 0,
      usedCount: json['used_count'] ?? 0,
      minOrderAmount: json['min_order_amount'] ?? 0,
      validFrom: DateTime.tryParse(json['valid_from']) ?? DateTime.now(),
      validTo: DateTime.tryParse(json['valid_to']) ?? DateTime.now(),
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'description': description,
      'discount_type': discountType,
      'discount_value': discountValue,
      'discount_amount': discountAmount,
      'final_amount': finalAmount,
      'max_uses': maxUses,
      'used_count': usedCount,
      'min_order_amount': minOrderAmount,
      'valid_from': validFrom.toIso8601String(),
      'valid_to': validTo.toIso8601String(),
      'is_active': isActive,
    };
  }

  String getDiscountDescription(BuildContext context) {
    if (discountType == 'PERCENT') {
      return LocalizationService.of_(context, "get_percent_off_your_next_order").replaceFirst('%s', discountValue.toString());
    } else if (discountType == 'FLAT') {
      return LocalizationService.of_(context, "get_flat_off_your_next_order").replaceFirst('%s', discountValue.toString());
    }
    return '';
  }

  String getMinimumSpend(BuildContext context) {
    return LocalizationService.of_(context, "minimum_spend").replaceFirst('%s', minOrderAmount.toString());
  }

  String getExpiry(BuildContext context) {
    final formattedDate = '${validTo.month}/${validTo.day}/${validTo.year}';
    return LocalizationService.of_(context, "expires_on").replaceFirst('%s', formattedDate);
  }
}

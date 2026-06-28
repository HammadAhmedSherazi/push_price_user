import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }

  static String get stripePublishableKey =>
      dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';

  static String get stripeMerchantDisplayName =>
      dotenv.env['STRIPE_MERCHANT_DISPLAY_NAME'] ?? 'Push Price';
}

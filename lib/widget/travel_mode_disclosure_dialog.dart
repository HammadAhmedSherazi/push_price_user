import 'package:push_price_user/utils/extension.dart';

import '../export_all.dart';

class TravelModeDisclosure {
  static bool _acceptedThisSession = false;

  static bool get isAcceptedThisSession => _acceptedThisSession;

  static void markAccepted() => _acceptedThisSession = true;

  static void clearAccepted() => _acceptedThisSession = false;

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: context.isTablet ? 48 : 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFF2F7FA),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.dialogMaxWidth),
            child: Padding(
              padding: EdgeInsets.all(AppTheme.horizontalPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44.iw,
                        height: 44.iw,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.location_on_outlined,
                          color: AppColors.secondaryColor,
                          size: 24.iw,
                        ),
                      ),
                      12.pw,
                      Expanded(
                        child: Text(
                          dialogContext.tr('travel_mode_disclosure_title'),
                          style: dialogContext.textStyle.displayMedium!.copyWith(
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  16.ph,
                  Text(
                    dialogContext.tr('travel_mode_disclosure_body'),
                    style: dialogContext.textStyle.bodyMedium!.copyWith(
                      color: AppColors.primaryTextColor,
                      height: 1.45,
                    ),
                  ),
                  12.ph,
                  Text(
                    dialogContext.tr('travel_mode_disclosure_points'),
                    style: dialogContext.textStyle.bodyMedium!.copyWith(
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                  24.ph,
                  CustomButtonWidget(
                    title: dialogContext.tr('travel_mode_disclosure_allow'),
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                  ),
                  10.ph,
                  CustomOutlineButtonWidget(
                    title: dialogContext.tr('travel_mode_disclosure_not_now'),
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    return result ?? false;
  }
}

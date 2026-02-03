import 'package:push_price_user/utils/extension.dart';

import '../export_all.dart';
import '../providers/notification_provider/notification_provider.dart';

class CustomAppBarWidget extends ConsumerWidget implements PreferredSizeWidget {
  final double height;
  final String title;
  final List<Widget> children;
  final double? radius;
  final Color? backgroundColor;

  const CustomAppBarWidget({
    super.key,
    required this.height,
    required this.title,
    required this.children,
    this.backgroundColor,
    this.radius,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(notificationProvider.select((e) => e.unreadCount ?? 0));
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: Container(
        padding: EdgeInsets.only(
          top: 40.r,
          left: AppTheme.horizontalPadding,
          right: AppTheme.horizontalPadding,
          bottom: 20.r,
        ),
        width: double.infinity,
        height: double.infinity,

        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.primaryAppBarColor,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(radius ?? 35.r),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                SizedBox(
                  width: context.screenwidth * 0.15,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // AppRouter.closeKeyboard();
                          // AppRouter.closeKeyboard();
                          await Future.delayed(
                            const Duration(milliseconds: 150),
                          );

                          if (AppRouter
                                  .scaffoldkey
                                  ?.currentState
                                  ?.isDrawerOpen !=
                              true) {
                            AppRouter.scaffoldkey?.currentState?.openDrawer();
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: Color.fromRGBO(234, 241, 255, 0.6),
                          radius: 20.r,
                          child: SvgPicture.asset(Assets.menuNavIcon),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Text(
                    title,
                    style: context.textStyle.displayMedium,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),

                SizedBox(
                  width: context.screenwidth * 0.15,
                  child: GestureDetector(
                    onTap: () {
                      AppRouter.push(NotificationView());
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color.fromRGBO(234, 241, 255, 0.6),
                          radius: 20.r,
                          child: SvgPicture.asset(Assets.notificationIcon),
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            right: 10,
                            top: 0,
                            child: Container(
                              width: 16.r,
                              height: 16.r,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                unreadCount > 99 ? '99+' : unreadCount.toString(),
                                style: context.textStyle.bodySmall!.copyWith(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

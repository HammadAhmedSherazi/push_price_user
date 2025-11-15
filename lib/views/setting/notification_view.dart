import 'package:push_price_user/utils/extension.dart';

import '../../export_all.dart';
import '../../providers/notification_provider/notification_provider.dart';

class NotificationView extends ConsumerStatefulWidget {
  const NotificationView({super.key});

  @override
  ConsumerState<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends ConsumerState<NotificationView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(notificationProvider.notifier).getNotifications(limit: 10, skip: 0);
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      final state = ref.read(notificationProvider);
      if (state.notificationsSkip != 0) {
        ref.read(notificationProvider.notifier).getNotifications(
          limit: 10,
          skip: state.notificationsSkip!,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(
      title: context.tr("notifications"),
      child: Consumer(
        builder: (context, ref, child) {
          final data = ref.watch(
            notificationProvider.select(
              (e) => (e.notifications ?? [], e.getNotificationsApiResponse),
            ),
          );

          return AsyncStateHandler(
            status: data.$2.status,
            dataList: data.$1,
            itemBuilder: null,
            onRetry: () => ref.read(notificationProvider.notifier).getNotifications(limit: 10, skip: 0),
            customSuccessWidget: ListView.separated(
              controller: _scrollController,
              padding: EdgeInsets.all(AppTheme.horizontalPadding),
              itemBuilder: (context, index) {
                final notification = data.$1[index];
                return NotificationTile(
                  ref: ref,
                  notification: notification,
                  onTap: () {
                    if (!notification.isRead) {
                      ref.read(notificationProvider.notifier).markAsRead(notificationId: notification.id);
                    }
                  },
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: data.$1.length,
            ),
          );
        },
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationDataModel notification;
  final VoidCallback? onTap;
  final WidgetRef ref;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.ref,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:notification.store != null ?null :  onTap,
      child: notification.store != null? Container(
        padding:notification.isRead ? null : EdgeInsets.symmetric(
          horizontal: 8, vertical: 5
        ) ,
        color: notification.isRead ? null : AppColors.secondaryColor.withValues(alpha: 0.1),
        child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 0.0
            ),
            leading: Container(
              width: 40.r,
              height: 40.r,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2,
                  color: Colors.white.withValues(alpha: 0.5)
                ),
                color: AppColors.secondaryColor
              ),
              child: SvgPicture.asset(Assets.notificationWhiteIcon),
            ),
            title: Text(notification.title, style: context.textStyle.displayMedium!.copyWith(
              color: AppColors.secondaryColor,
              height: 1.0,
              fontSize: 16.sp
           
            ), ),
            subtitle: Row(
              children: [
                Expanded(
                  child: Text("${notification.store?.storeName}\n${notification.store?.address}", 
                  maxLines: 3,
                  style: context.textStyle.displayMedium!.copyWith(
                    color: Color(0xff5B5B5B)
                  ),),
                  
                ),
                GestureDetector(
                  onTap: (){
                    if (!notification.isRead) {
                      ref.read(notificationProvider.notifier).markAsRead(notificationId: notification.id);
                    }
                    AppRouter.push(StoreView(storeData: notification.store!, productId: notification.productId, ), fun: (){
                      ref.read(notificationProvider.notifier).getNotifications(limit: 10, skip: 0);
                      
                    });
                  },
                  child: Container(
                    height: 35.h,
                    // width: 90.w,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.r
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: AppColors.primaryColor
                    ),
                    child: Text("Visit Store", style: context.textStyle.displayMedium!.copyWith(
                      color: Colors.white
                    ),),
                  ),
                )
              ],
            ),
          
          ),
      ): ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
        leading: Container(
          width: 40.r,
          height: 40.r,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 2,
              color: Colors.white.withValues(alpha: 0.5)
            ),
            color: AppColors.secondaryColor
          ),
          child: SvgPicture.asset(Assets.notificationWhiteIcon),
        ),
        title: Text(
          notification.title,
          style: context.textStyle.displayMedium!.copyWith(
            color: AppColors.secondaryColor,
            fontSize: 16.sp
          ),
        ),
        subtitle: Text(
          notification.body,
          style: context.textStyle.displayMedium!.copyWith(
            color: Color(0xff5B5B5B)
          ),
        ),
        trailing: notification.isRead ? null : Container(
            width: 20.r,
            height: 20.r,
            alignment: Alignment.center,
           
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 1,
                color: Colors.white.withValues(alpha: 0.5)
              ),
              color: AppColors.secondaryColor
            ),
            child: Text(1.toString(), style: context.textStyle.bodySmall!.copyWith(
              color: Colors.white
            ),),
          ),
      ),
    );
  }
}

import 'dart:async';

import 'package:push_price_user/data/network/api_response.dart';
import 'package:push_price_user/export_all.dart';
import 'package:push_price_user/providers/notification_provider/notification_state.dart';

class NotificationProvider extends Notifier<NotificationState> {
  @override
  NotificationState build() {
    return NotificationState(
      getNotificationsApiResponse: ApiResponse.undertermined(),
      getUnreadCountApiResponse: ApiResponse.undertermined(),
      markAsReadApiResponse: ApiResponse.undertermined(),
      notifications: [],
      notificationsSkip: 0,
      unreadCount: 0,
    );
  }

  FutureOr<void> getNotifications({
    required int limit,
    required int skip,
  }) async {
    if (!ref.mounted) return;
    if (skip == 0 && state.notifications!.isNotEmpty) {
      state = state.copyWith(notifications: [], notificationsSkip: 0);
    }
    Map<String, dynamic> params = {'limit': limit, 'skip': skip};

    try {
      state = state.copyWith(
        getNotificationsApiResponse: skip == 0
            ? ApiResponse.loading()
            : ApiResponse.loadingMore(),
      );
      final response = await MyHttpClient.instance.get(
        ApiEndpoints.notifications,
        params: params,
      );

      if (!ref.mounted) return;

      if (response != null && !(response is Map && response.containsKey('detail'))) {
        List temp = response['notifications'] ?? [];
        final List<NotificationDataModel> list = List.from(
          temp.map((e) => NotificationDataModel.fromJson(e)),
        );
        state = state.copyWith(
          getNotificationsApiResponse: ApiResponse.completed(response),
          notifications: skip == 0 && state.notifications!.isEmpty
              ? list
              : [...state.notifications!, ...list],
          notificationsSkip: list.length >= limit ? skip + limit : 0,
        );
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_get_notifications"),
        );
        state = state.copyWith(
          getNotificationsApiResponse: skip == 0
              ? ApiResponse.error()
              : ApiResponse.undertermined(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        getNotificationsApiResponse: skip == 0
            ? ApiResponse.error()
            : ApiResponse.undertermined(),
      );
    }
  }

  FutureOr<void> getUnreadNotificationCount() async {
    if (!ref.mounted) return;
    try {
      state = state.copyWith(getUnreadCountApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.get(ApiEndpoints.unreadNotificationCount);
      if (!ref.mounted) return;

      if (response != null && !(response is Map && response.containsKey('detail'))) {
        int count = response['unread_count'] ?? 0;
        state = state.copyWith(
          getUnreadCountApiResponse: ApiResponse.completed(response),
          unreadCount: count,
        );
      } else {
        state = state.copyWith(getUnreadCountApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(getUnreadCountApiResponse: ApiResponse.error());
    }
  }

  FutureOr<void> markAsRead({required int notificationId}) async {
    if (!ref.mounted) return;
    try {
      state = state.copyWith(markAsReadApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.put(
        ApiEndpoints.markAsRead(notificationId),
        null,
        isJsonEncode: false,
      );
      if (!ref.mounted) return;

      if (response != null && !(response is Map && response.containsKey('detail'))) {
        state = state.copyWith(markAsReadApiResponse: ApiResponse.completed(response));
        // Update the notification in the list if it exists
        final updatedNotifications = state.notifications?.map((notification) {
          if (notification.id == notificationId) {
            return notification.copyWith(isRead: true);
          }
          return notification;
        }).toList();
        state = state.copyWith(notifications: updatedNotifications);
        // Refresh unread count
        await getUnreadNotificationCount();
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_mark_as_read"),
        );
        state = state.copyWith(markAsReadApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(markAsReadApiResponse: ApiResponse.error());
    }
  }
}

final notificationProvider = NotifierProvider<NotificationProvider, NotificationState>(
  NotificationProvider.new,
);

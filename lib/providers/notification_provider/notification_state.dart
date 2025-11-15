import 'package:push_price_user/data/network/api_response.dart';
import 'package:push_price_user/export_all.dart';

class NotificationState {
  final ApiResponse getNotificationsApiResponse;
  final ApiResponse getUnreadCountApiResponse;
  final ApiResponse markAsReadApiResponse;

  final List<NotificationDataModel>? notifications;
  final int? notificationsSkip;
  final int? unreadCount;

  NotificationState({
    required this.getNotificationsApiResponse,
    required this.getUnreadCountApiResponse,
    required this.markAsReadApiResponse,
    this.notifications,
    this.notificationsSkip,
    this.unreadCount,
  });

  NotificationState copyWith({
    ApiResponse? getNotificationsApiResponse,
    ApiResponse? getUnreadCountApiResponse,
    ApiResponse? markAsReadApiResponse,
    List<NotificationDataModel>? notifications,
    int? notificationsSkip,
    int? unreadCount,
  }) => NotificationState(
    getNotificationsApiResponse: getNotificationsApiResponse ?? this.getNotificationsApiResponse,
    getUnreadCountApiResponse: getUnreadCountApiResponse ?? this.getUnreadCountApiResponse,
    markAsReadApiResponse: markAsReadApiResponse ?? this.markAsReadApiResponse,
    notifications: notifications ?? this.notifications,
    notificationsSkip: notificationsSkip ?? this.notificationsSkip,
    unreadCount: unreadCount ?? this.unreadCount,
  );
}

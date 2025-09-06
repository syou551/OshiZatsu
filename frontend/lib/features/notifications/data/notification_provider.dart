import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oshizatsu_frontend/generated/oshizatsu.pb.dart' as pb;
import '../../../core/services/backend_notification_service.dart';
import '../../auth/data/auth_provider.dart';

// 通知一覧の状態管理
class NotificationState {
  final List<pb.Notification> notifications;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final bool hasMore;

  const NotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.hasMore = true,
  });

  NotificationState copyWith({
    List<pb.Notification>? notifications,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    bool? hasMore,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

// 通知一覧のNotifier
class NotificationNotifier extends StateNotifier<NotificationState> {
  final BackendNotificationService? _service;
  static const int _pageSize = 20;

  NotificationNotifier(this._service) : super(const NotificationState());

  /// 通知一覧を取得
  Future<void> loadNotifications({bool refresh = false}) async {
    if (_service == null) {
      state = state.copyWith(
        hasError: true,
        errorMessage: '認証が必要です',
      );
      return;
    }

    if (refresh) {
      state = state.copyWith(
        notifications: [],
        hasMore: true,
        hasError: false,
        errorMessage: null,
      );
    }

    if (state.isLoading || (!state.hasMore && !refresh)) {
      return;
    }

    state = state.copyWith(isLoading: true, hasError: false, errorMessage: null);

    try {
      final offset = refresh ? 0 : state.notifications.length;
      final newNotifications = await _service!.getNotifications(
        limit: _pageSize,
        offset: offset,
      );

      final updatedNotifications = refresh
          ? newNotifications
          : [...state.notifications, ...newNotifications];

      state = state.copyWith(
        notifications: updatedNotifications,
        isLoading: false,
        hasMore: newNotifications.length == _pageSize,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      );
    }
  }

  /// 通知を既読にする
  Future<void> markAsRead(String notificationId) async {
    if (_service == null) {
      state = state.copyWith(
        hasError: true,
        errorMessage: '認証が必要です',
      );
      return;
    }

    try {
      final success = await _service!.markNotificationAsRead(notificationId);
      if (success) {
        // ローカル状態を更新
        final updatedNotifications = state.notifications.map((notification) {
          if (notification.id == notificationId) {
            return pb.Notification()
              ..id = notification.id
              ..title = notification.title
              ..body = notification.body
              ..channelId = notification.channelId
              ..channelName = notification.channelName
              ..type = notification.type
              ..createdAt = notification.createdAt
              ..isRead = true;
          }
          return notification;
        }).toList();

        state = state.copyWith(notifications: updatedNotifications);
      }
    } catch (e) {
      state = state.copyWith(
        hasError: true,
        errorMessage: e.toString(),
      );
    }
  }

  /// 通知を削除
  Future<void> deleteNotification(String notificationId) async {
    if (_service == null) {
      state = state.copyWith(
        hasError: true,
        errorMessage: '認証が必要です',
      );
      return;
    }

    try {
      final success = await _service!.deleteNotification(notificationId);
      if (success) {
        // ローカル状態を更新
        final updatedNotifications = state.notifications
            .where((notification) => notification.id != notificationId)
            .toList();

        state = state.copyWith(notifications: updatedNotifications);
      }
    } catch (e) {
      state = state.copyWith(
        hasError: true,
        errorMessage: e.toString(),
      );
    }
  }

  /// すべての通知を削除
  Future<void> clearAllNotifications() async {
    // TODO: 全削除APIが実装されたら呼び出す
    // 現在はローカル状態のみ更新
    state = state.copyWith(notifications: []);
  }

  /// エラー状態をクリア
  void clearError() {
    state = state.copyWith(hasError: false, errorMessage: null);
  }
}

// 通知一覧のProvider
final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  final service = ref.watch(backendNotificationServiceProvider);
  return NotificationNotifier(service);
});

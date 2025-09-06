import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/theme_service.dart';
import '../../data/notification_provider.dart';
import '../widgets/notification_list_item.dart';
import '../widgets/empty_notifications_widget.dart';
import '../widgets/error_notifications_widget.dart';
import '../widgets/loading_notifications_widget.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    // 初期データを読み込み
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationProvider.notifier).loadNotifications(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationProvider);
    final notificationNotifier = ref.read(notificationProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('通知'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => notificationNotifier.loadNotifications(refresh: true),
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () => _clearAllNotifications(notificationNotifier),
          ),
        ],
      ),
      body: _buildBody(notificationState, notificationNotifier),
    );
  }

  Widget _buildBody(NotificationState state, NotificationNotifier notifier) {
    if (state.isLoading && state.notifications.isEmpty) {
      return const LoadingNotificationsWidget();
    }

    if (state.hasError && state.notifications.isEmpty) {
      return ErrorNotificationsWidget(
        errorMessage: state.errorMessage,
        onRetry: () => notifier.loadNotifications(refresh: true),
      );
    }

    if (state.notifications.isEmpty) {
      return const EmptyNotificationsWidget();
    }

    return RefreshIndicator(
      onRefresh: () => notifier.loadNotifications(refresh: true),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.notifications.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.notifications.length) {
            // ローディングインジケーター
            if (state.isLoading) {
              final themeState = ref.watch(themeServiceProvider);
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(themeState.selectedColor.primaryColor),
                  ),
                ),
              );
            } else {
              // さらに読み込む
              WidgetsBinding.instance.addPostFrameCallback((_) {
                notifier.loadNotifications();
              });
              return const SizedBox.shrink();
            }
          }

          final notification = state.notifications[index];
          return NotificationListItem(
            notification: notification,
            onTap: () => _onNotificationTap(notification, notifier),
            onMarkAsRead: () => notifier.markAsRead(notification.id),
            onDelete: () => _deleteNotification(notification.id, notifier),
          );
        },
      ),
    );
  }

  void _onNotificationTap(notification, NotificationNotifier notifier) {
    // 未読の場合は既読にする
    if (!notification.isRead) {
      notifier.markAsRead(notification.id);
    }
    
    // TODO: 通知詳細またはチャンネルページに遷移
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${notification.channelName}の詳細'),
      ),
    );
  }

  void _deleteNotification(String id, NotificationNotifier notifier) {
    notifier.deleteNotification(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('通知を削除しました'),
        backgroundColor: Color(0xFFDC3545), // エラー色は固定
      ),
    );
  }

  void _clearAllNotifications(NotificationNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('すべての通知を削除'),
        content: const Text('すべての通知を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              notifier.clearAllNotifications();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('すべての通知を削除しました'),
                  backgroundColor: Color(0xFFDC3545), // エラー色は固定
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC3545), // エラー色は固定
            ),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }
}

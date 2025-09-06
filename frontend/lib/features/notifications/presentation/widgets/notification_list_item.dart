import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oshizatsu_frontend/generated/oshizatsu.pb.dart' as pb;
import '../../../../core/services/theme_service.dart';

class NotificationListItem extends ConsumerWidget {
  final pb.Notification notification;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsRead;
  final VoidCallback? onDelete;

  const NotificationListItem({
    super.key,
    required this.notification,
    this.onTap,
    this.onMarkAsRead,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeServiceProvider);
    final isRead = notification.isRead;
    final type = notification.type;
    final createdAt = notification.createdAt.toDateTime();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isRead ? 2 : 4,
      color: isRead ? null : themeState.selectedColor.primaryColor.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 通知アイコン
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getNotificationColor(type),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  _getNotificationIcon(type),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              
              // 通知内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: themeState.selectedColor.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            notification.channelName,
                            style: TextStyle(
                              fontSize: 12,
                              color: themeState.selectedColor.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatDateTime(createdAt),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: themeState.isDarkMode ? Colors.grey : const Color(0xFF6C757D),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // メニューボタン
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'mark_read':
                      onMarkAsRead?.call();
                      break;
                    case 'delete':
                      onDelete?.call();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  if (!isRead)
                    const PopupMenuItem(
                      value: 'mark_read',
                      child: Row(
                        children: [
                          Icon(Icons.mark_email_read),
                          SizedBox(width: 8),
                          Text('既読にする'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Color(0xFFDC3545)), // エラー色は固定
                        SizedBox(width: 8),
                        Text('削除'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getNotificationColor(pb.NotificationType type) {
    switch (type) {
      case pb.NotificationType.STARTED:
        return const Color(0xFFDC3545); // エラー色は固定
      case pb.NotificationType.SCHEDULED:
        return const Color(0xFF6B9DFF); // セカンダリ色は固定
      default:
        return const Color(0xFFFF6B9D); // デフォルトのプライマリ色
    }
  }

  IconData _getNotificationIcon(pb.NotificationType type) {
    switch (type) {
      case pb.NotificationType.STARTED:
        return Icons.live_tv;
      case pb.NotificationType.SCHEDULED:
        return Icons.schedule;
      default:
        return Icons.notifications;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}日前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}時間前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分前';
    } else {
      return '今';
    }
  }
}

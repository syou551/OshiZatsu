import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  // ダミーデータ
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'ライブ配信が予約されました',
      'body': '推しチャンネル1のライブ配信が予約されました',
      'channelName': '推しチャンネル1',
      'type': 'scheduled',
      'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
      'isRead': false,
    },
    {
      'id': '2',
      'title': 'ライブ配信が開始されました',
      'body': '推しチャンネル2のライブ配信が開始されました',
      'channelName': '推しチャンネル2',
      'type': 'started',
      'createdAt': DateTime.now().subtract(const Duration(minutes: 30)),
      'isRead': true,
    },
    {
      'id': '3',
      'title': 'ライブ配信が予約されました',
      'body': '推しチャンネル3のライブ配信が予約されました',
      'channelName': '推しチャンネル3',
      'type': 'scheduled',
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
      'isRead': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('通知'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearAllNotifications,
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Icon(
                      Icons.notifications_none,
                      size: 60,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '通知がありません',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '推しのライブ配信通知が\nここに表示されます',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                final isRead = notification['isRead'] as bool;
                final type = notification['type'] as String;
                final createdAt = notification['createdAt'] as DateTime;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: isRead ? 2 : 4,
                  color: isRead ? null : AppTheme.primaryColor.withOpacity(0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      _markAsRead(notification['id']);
                      // TODO: 通知詳細またはチャンネルページに遷移
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${notification['channelName']}の詳細'),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // 通知アイコン
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: type == 'started'
                                  ? AppTheme.errorColor
                                  : AppTheme.secondaryColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Icon(
                              type == 'started' ? Icons.live_tv : Icons.schedule,
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
                                  notification['title'],
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notification['body'],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        notification['channelName'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      _formatDateTime(createdAt),
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.textSecondaryColor,
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
                              if (value == 'mark_read') {
                                _markAsRead(notification['id']);
                              } else if (value == 'delete') {
                                _deleteNotification(notification['id']);
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
                                    Icon(Icons.delete, color: AppTheme.errorColor),
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
              },
            ),
    );
  }

  void _markAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n['id'] == id);
      if (index != -1) {
        _notifications[index]['isRead'] = true;
      }
    });
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((n) => n['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('通知を削除しました'),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }

  void _clearAllNotifications() {
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
              setState(() {
                _notifications.clear();
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('すべての通知を削除しました'),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('削除'),
          ),
        ],
      ),
    );
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';

class ChannelsPage extends ConsumerStatefulWidget {
  const ChannelsPage({super.key});

  @override
  ConsumerState<ChannelsPage> createState() => _ChannelsPageState();
}

class _ChannelsPageState extends ConsumerState<ChannelsPage> {
  final _channelIdController = TextEditingController();
  final _channelNameController = TextEditingController();

  // ダミーデータ
  final List<Map<String, dynamic>> _channels = [
    {
      'id': '1',
      'name': '推しチャンネル1',
      'channelId': 'UC-lHJZR3Gqxm24_Vd_AJ5Yw',
      'isLive': false,
      'lastLiveScheduled': null,
    },
    {
      'id': '2',
      'name': '推しチャンネル2',
      'channelId': 'UC-2',
      'isLive': true,
      'lastLiveScheduled': DateTime.now().add(const Duration(hours: 1)),
    },
  ];

  @override
  void dispose() {
    _channelIdController.dispose();
    _channelNameController.dispose();
    super.dispose();
  }

  void _showAddChannelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.add,
                color: AppTheme.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text('チャンネルを追加'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _channelNameController,
              decoration: const InputDecoration(
                labelText: 'チャンネル名',
                hintText: '推しのチャンネル名を入力',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _channelIdController,
              decoration: const InputDecoration(
                labelText: 'チャンネルID',
                hintText: 'YouTubeチャンネルIDを入力',
                prefixIcon: Icon(Icons.link),
                helperText: '例: UC-lHJZR3Gqxm24_Vd_AJ5Yw',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_channelNameController.text.isNotEmpty &&
                  _channelIdController.text.isNotEmpty) {
                setState(() {
                  _channels.add({
                    'id': DateTime.now().toString(),
                    'name': _channelNameController.text,
                    'channelId': _channelIdController.text,
                    'isLive': false,
                    'lastLiveScheduled': null,
                  });
                });
                _channelNameController.clear();
                _channelIdController.clear();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 8),
                        const Text('チャンネルを追加しました'),
                      ],
                    ),
                    backgroundColor: AppTheme.primaryColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }
            },
            child: const Text('追加'),
          ),
        ],
      ),
    );
  }

  void _removeChannel(String id) {
    setState(() {
      _channels.removeWhere((channel) => channel['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('チャンネルを削除しました'),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('チャンネル'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddChannelDialog,
          ),
        ],
      ),
      body: _channels.isEmpty
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
                      Icons.subscriptions_outlined,
                      size: 60,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '登録されたチャンネルがありません',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '推しのYouTubeチャンネルを追加して\nライブ配信通知を受け取りましょう',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _showAddChannelDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('チャンネルを追加'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _channels.length,
              itemBuilder: (context, index) {
                final channel = _channels[index];
                final isLive = channel['isLive'] as bool;
                final lastLiveScheduled = channel['lastLiveScheduled'] as DateTime?;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      // TODO: チャンネル詳細ページに遷移
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${channel['name']}の詳細'),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // チャンネルアイコン
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: isLive
                                  ? AppTheme.errorColor
                                  : AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              isLive ? Icons.live_tv : Icons.subscriptions,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // チャンネル情報
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  channel['name'],
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'ID: ${channel['channelId']}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (isLive)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppTheme.errorColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: AppTheme.errorColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'ライブ配信中',
                                          style: TextStyle(
                                            color: AppTheme.errorColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else if (lastLiveScheduled != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppTheme.secondaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.schedule,
                                          size: 12,
                                          color: AppTheme.secondaryColor,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '次回配信: ${_formatDateTime(lastLiveScheduled)}',
                                          style: TextStyle(
                                            color: AppTheme.secondaryColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          
                          // メニューボタン
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'remove') {
                                _removeChannel(channel['id']);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'remove',
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

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inDays > 0) {
      return '${difference.inDays}日後';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}時間後';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分後';
    } else {
      return 'まもなく';
    }
  }
}

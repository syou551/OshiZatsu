import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/backend_client.dart';
import '../../../../core/services/theme_service.dart';
import '../../../../generated/oshizatsu.pb.dart' as pb;
import 'package:webview_flutter/webview_flutter.dart';

class ChannelsPage extends ConsumerStatefulWidget {
  const ChannelsPage({super.key});

  @override
  ConsumerState<ChannelsPage> createState() => _ChannelsPageState();
}

class _ChannelsPageState extends ConsumerState<ChannelsPage> {
  final _channelIdController = TextEditingController();
  final _channelNameController = TextEditingController();
  final AuthService _authService = AuthService();

  List<pb.Channel> _channels = [];
  bool _isLoading = true;
  bool _isAddingChannel = false;

  @override
  void initState() {
    super.initState();
    _loadChannels();
  }

  @override
  void dispose() {
    _channelIdController.dispose();
    _channelNameController.dispose();
    super.dispose();
  }

  // 安全なSnackBar表示メソッド
  void _showSnackBar(String message, {bool isError = false, bool isInfo = false}) {
    if (!mounted) return;
    
    final themeState = ref.read(themeServiceProvider);
    Color backgroundColor;
    IconData icon;
    
    if (isError) {
      backgroundColor = const Color(0xFFDC3545); // エラー色は固定
      icon = Icons.error;
    } else if (isInfo) {
      backgroundColor = const Color(0xFF6B9DFF); // セカンダリ色は固定
      icon = Icons.info;
    } else {
      backgroundColor = themeState.selectedColor.primaryColor;
      icon = Icons.check_circle;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _loadChannels() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final accessToken = await _authService.getAccessToken();
      if (accessToken == null) {
        context.go('/login');
        return;
      }

      final channel = BackendClientFactory.createChannel(
        host: AuthService.backendHost,
        port: AuthService.backendPort,
        useTls: false,
      );
      final client = BackendClientFactory.createChannelClient(channel);

      try {
        final response = await client.getSubscribedChannels(
          pb.GetSubscribedChannelsRequest(accessToken: accessToken),
        );
        
        setState(() {
          _channels = response.channels;
          _isLoading = false;
        });
      } finally {
        await channel.shutdown();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // 少し遅延してからSnackBarを表示
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _showSnackBar('チャンネル一覧の取得に失敗しました: $e', isError: true);
          }
        });
      }
    }
  }

  Future<void> _addChannel({Function(String message, bool isSuccess)? onComplete}) async {
    if (_channelNameController.text.isEmpty || _channelIdController.text.isEmpty) {
      _showSnackBar('チャンネル名とチャンネルIDを入力してください', isError: true);
      return;
    }

    setState(() {
      _isAddingChannel = true;
    });

    try {
      final accessToken = await _authService.getAccessToken();
      if (accessToken == null) {
        if (mounted) {
          context.go('/login');
        }
        return;
      }

      final channel = BackendClientFactory.createChannel(
        host: AuthService.backendHost,
        port: AuthService.backendPort,
        useTls: false,
      );
      final client = BackendClientFactory.createChannelClient(channel);

      try {
        final response = await client.subscribeChannel(
                      pb.SubscribeChannelRequest(
              accessToken: accessToken,
              channelId: _channelIdController.text.trim(),
              channelName: _channelNameController.text.trim(),
            ),
        );

        _channelNameController.clear();
        _channelIdController.clear();
        
        // チャンネル一覧を再読み込み
        await _loadChannels();
        
        // コールバックで結果を通知
        if (onComplete != null) {
          onComplete(
            response.success ? 'チャンネルを追加しました' : response.message,
            response.success,
          );
        }
      } finally {
        await channel.shutdown();
      }
    } catch (e) {
      if (onComplete != null) {
        onComplete('チャンネルの追加に失敗しました: $e', false);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAddingChannel = false;
        });
      }
    }
  }

  Future<void> _removeChannel(String channelId) async {
    try {
      final accessToken = await _authService.getAccessToken();
      if (accessToken == null) {
        context.go('/login');
        return;
      }

      final channel = BackendClientFactory.createChannel(
        host: AuthService.backendHost,
        port: AuthService.backendPort,
        useTls: false,
      );
      final client = BackendClientFactory.createChannelClient(channel);

      try {
        await client.unsubscribeChannel(
          pb.UnsubscribeChannelRequest(
            accessToken: accessToken,
            channelId: channelId,
          ),
        );

        // チャンネル一覧を再読み込み
        await _loadChannels();
        
        if (mounted) {
          // 少し遅延してからSnackBarを表示
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              _showSnackBar('チャンネルを削除しました', isInfo: true);
            }
          });
        }
      } finally {
        await channel.shutdown();
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('チャンネルの削除に失敗しました: $e', isError: true);
      }
    }
  }

  Future<bool> _isChannelAlreadySubscribed(String channelId) async {
    try {
      final accessToken = await _authService.getAccessToken();
      if (accessToken == null) return false;

      final channel = BackendClientFactory.createChannel(
        host: AuthService.backendHost,
        port: AuthService.backendPort,
        useTls: false,
      );
      final client = BackendClientFactory.createChannelClient(channel);

      try {
        final response = await client.getSubscribedChannels(
          pb.GetSubscribedChannelsRequest(accessToken: accessToken),
        );
        
        return response.channels.any((channel) => channel.channelId == channelId);
      } finally {
        await channel.shutdown();
      }
    } catch (e) {
      return false;
    }
  }

  void _showAddChannelDialog() {
    final themeState = ref.read(themeServiceProvider);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: themeState.selectedColor.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.add,
                color: themeState.selectedColor.primaryColor,
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
              onChanged: (value) async {
                if (value.isNotEmpty && mounted) {
                  final isSubscribed = await _isChannelAlreadySubscribed(value.trim());
                  if (isSubscribed && mounted) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(
                        content: Text('このチャンネルは既に登録されています'),
                        backgroundColor: Color(0xFF6B9DFF), // セカンダリ色は固定
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _isAddingChannel ? null : () {
              if (mounted) {
                Navigator.of(dialogContext).pop();
              }
            },
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: _isAddingChannel ? null : () async {
              await _addChannel(
                onComplete: (message, isSuccess) {
                  // ダイアログを閉じる
                  if (mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                  
                  // ダイアログが閉じられた後にSnackBarを表示
                  Future.delayed(const Duration(milliseconds: 200), () {
                    if (mounted) {
                      _showSnackBar(
                        message,
                        isError: !isSuccess,
                        isInfo: !isSuccess,
                      );
                    }
                  });
                },
              );
            },
            child: _isAddingChannel
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('追加'),
          ),
        ],
      ),
    );
  }

  Future<void> _openChannelUrl(String channelId, String channelName) async {
    final url = 'https://www.youtube.com/channel/$channelId';
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChannelWebViewPage(title: channelName, initialUrl: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeServiceProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('チャンネル'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadChannels,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddChannelDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _channels.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: themeState.selectedColor.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Icon(
                          Icons.subscriptions_outlined,
                          size: 60,
                          color: themeState.selectedColor.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '登録されたチャンネルがありません',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: themeState.isDarkMode ? Colors.grey : const Color(0xFF6C757D),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '推しのYouTubeチャンネルを追加して\nライブ配信通知を受け取りましょう',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: themeState.isDarkMode ? Colors.grey : const Color(0xFF6C757D),
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
              : RefreshIndicator(
                  onRefresh: _loadChannels,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _channels.length,
                    itemBuilder: (context, index) {
                      final channel = _channels[index];
                      final isLive = channel.isLive;
                      final lastLiveScheduled = channel.lastLiveScheduled != null 
                          ? DateTime.fromMillisecondsSinceEpoch(
                              (channel.lastLiveScheduled!.seconds.toInt() * 1000) + 
                              (channel.lastLiveScheduled!.nanos ~/ 1000000)
                            )
                          : null;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            //_showSnackBar('${channel.name}の詳細', isInfo: true);
                            _openChannelUrl(channel.channelId, channel.name);
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
                                        ? const Color(0xFFDC3545) // エラー色は固定
                                        : themeState.selectedColor.primaryColor,
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
                                        channel.name,
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'ID: ${channel.channelId}',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: themeState.isDarkMode ? Colors.grey : const Color(0xFF6C757D),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      if (_isLive(channel))
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFDC3545).withOpacity(0.1), // エラー色は固定
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFDC3545), // エラー色は固定
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'ライブ配信中',
                                                style: TextStyle(
                                                  color: const Color(0xFFDC3545), // エラー色は固定
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
                                            color: const Color(0xFF6B9DFF).withOpacity(0.1), // セカンダリ色は固定
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.schedule,
                                                size: 12,
                                                color: const Color(0xFF6B9DFF), // セカンダリ色は固定
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '次回配信: ${_formatDateTime(lastLiveScheduled)}',
                                                style: TextStyle(
                                                  color: const Color(0xFF6B9DFF), // セカンダリ色は固定
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
                                
                                // Actions: open in-app WebView + menu
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      tooltip: 'アプリ内で開く',
                                      icon: const Icon(Icons.open_in_browser),
                                      onPressed: () => _openChannelUrl(channel.channelId, channel.name),
                                    ),
                                    PopupMenuButton<String>(
                                      onSelected: (value) {
                                        if (value == 'remove') {
                                          _removeChannel(channel.channelId);
                                        }
                                      },
                                      itemBuilder: (context) => const [
                                        PopupMenuItem(
                                          value: 'remove',
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete, color: const Color(0xFFDC3545)), // エラー色は固定
                                              SizedBox(width: 8),
                                              Text('削除'),
                                            ],
                                          ),
                                        ),
                                      ],
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
      return '枠なし';
    }
  }

  bool _isLive(pb.Channel channel) {
    final now = DateTime.now();
    final lastLiveScheduled = channel.lastLiveScheduled != null 
                          ? DateTime.fromMillisecondsSinceEpoch(
                              (channel.lastLiveScheduled!.seconds.toInt() * 1000) + 
                              (channel.lastLiveScheduled!.nanos ~/ 1000000)
                            )
                          : null;
    final difference = lastLiveScheduled!.difference(now);
    final isLive = difference.inMinutes < 0 && difference.inMinutes > -15;
    if(!channel.isLive && isLive) {
      return true;
    }
    return channel.isLive;
  }
}

class ChannelWebViewPage extends StatefulWidget {
  const ChannelWebViewPage({super.key, required this.title, required this.initialUrl});

  final String title;
  final String initialUrl;

  @override
  State<ChannelWebViewPage> createState() => _ChannelWebViewPageState();
}

class _ChannelWebViewPageState extends State<ChannelWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

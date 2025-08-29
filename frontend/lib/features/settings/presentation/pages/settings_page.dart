import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/auth_service.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _scheduledNotificationsEnabled = true;
  bool _startedNotificationsEnabled = true;
  bool _darkModeEnabled = false;

  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ListView(
        children: [
          // 通知設定
          _buildSectionHeader('通知設定'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: SwitchListTile(
              title: const Text('通知を有効にする'),
              subtitle: const Text('プッシュ通知の受信を有効にします'),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: SwitchListTile(
              title: const Text('配信予約通知'),
              subtitle: const Text('ライブ配信が予約された時の通知'),
              value: _scheduledNotificationsEnabled && _notificationsEnabled,
              onChanged: _notificationsEnabled
                  ? (value) {
                      setState(() {
                        _scheduledNotificationsEnabled = value;
                      });
                    }
                  : null,
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: SwitchListTile(
              title: const Text('配信開始通知'),
              subtitle: const Text('ライブ配信が開始された時の通知'),
              value: _startedNotificationsEnabled && _notificationsEnabled,
              onChanged: _notificationsEnabled
                  ? (value) {
                      setState(() {
                        _startedNotificationsEnabled = value;
                      });
                    }
                  : null,
            ),
          ),

          const Divider(),

          // アプリ設定
          _buildSectionHeader('アプリ設定'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: SwitchListTile(
              title: const Text('ダークモード'),
              subtitle: const Text('ダークテーマを有効にします'),
              value: _darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _darkModeEnabled = value;
                });
                // TODO: テーマ切り替えを実装
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.info,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              title: const Text('アプリについて'),
              subtitle: const Text('バージョン情報とライセンス'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showAboutDialog();
              },
            ),
          ),

          const Divider(),

          // アカウント設定
          _buildSectionHeader('アカウント設定'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.person,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              title: const Text('プロフィール'),
              subtitle: const Text('ユーザー情報の編集'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.push('/profile/edit');
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.security,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              title: const Text('プライバシー設定'),
              subtitle: const Text('データの管理とプライバシー'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: プライバシー設定ページに遷移
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('プライバシー設定は準備中です'),
                  ),
                );
              },
            ),
          ),

          const Divider(),

          // データ管理
          _buildSectionHeader('データ管理'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.download,
                  color: AppTheme.secondaryColor,
                  size: 20,
                ),
              ),
              title: const Text('データのエクスポート'),
              subtitle: const Text('登録チャンネルと通知履歴をエクスポート'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: データエクスポート機能を実装
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('データエクスポートは準備中です'),
                  ),
                );
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.delete_forever,
                  color: AppTheme.errorColor,
                  size: 20,
                ),
              ),
              title: const Text('データの削除'),
              subtitle: const Text('すべてのデータを削除'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showDeleteDataDialog();
              },
            ),
          ),

          const Divider(),

          // ログアウト
          _buildSectionHeader('アカウント'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.logout,
                  color: AppTheme.errorColor,
                  size: 20,
                ),
              ),
              title: const Text('ログアウト'),
              subtitle: const Text('アカウントからログアウト'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showLogoutDialog();
              },
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: '推し雑',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.favorite,
          color: Colors.white,
          size: 24,
        ),
      ),
      children: const [
        Text(
          '推しの雑談配信通知アプリ\n\n'
          '推しのYouTubeチャンネルを登録しておくと、'
          '雑談配信が予約されたときと開始されたときに'
          '通知を受け取ることができます。',
        ),
      ],
    );
  }

  void _showDeleteDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('データの削除'),
        content: const Text(
          'すべてのデータ（登録チャンネル、通知履歴、設定など）を削除します。\n\n'
          'この操作は取り消すことができません。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: データ削除処理を実装
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('すべてのデータを削除しました'),
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ログアウト'),
        content: const Text('アカウントからログアウトしますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              // ログアウトを実行する
              final authService = AuthService();
              authService.logout();
              Navigator.of(context).pop();
              context.go('/login');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ログアウトしました'),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('ログアウト'),
          ),
        ],
      ),
    );
  }
}

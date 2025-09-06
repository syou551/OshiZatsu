import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/theme_service.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loginWithOIDC() async {
    setState(() { _isLoading = true; });
    try {
      final auth = AuthService();
      await auth.loginWithOIDC();
      if (mounted) {
        context.go('/channels');
      }
    } catch (e) {
      print('Login error: $e');
      if (mounted) {
        String errorMessage = 'OIDCログインに失敗しました';
        if (e.toString().contains('only https connections are permitted')) {
          errorMessage = 'OAuth認証エラー: HTTPS接続が必要です';
        } else if (e.toString().contains('FIS_AUTH_ERROR')) {
          errorMessage = 'Firebase認証エラー: 開発環境では正常です';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: const Color(0xFFDC3545), // エラー色は固定
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  Future<void> _createAccountWithOIDC() async {
    await _loginWithOIDC();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeServiceProvider);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              themeState.selectedColor.primaryColor,
              themeState.selectedColor.primaryLightColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // アプリアイコン
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                themeState.selectedColor.primaryColor,
                                themeState.selectedColor.primaryLightColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: themeState.selectedColor.primaryColor.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // アプリタイトル
                        Text(
                          '推し雑',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: themeState.selectedColor.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '推しの雑談配信通知アプリ',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: themeState.isDarkMode ? Colors.grey : const Color(0xFF6C757D),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // syou551.dev(Keycloak)でログイン
                        Container(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _isLoading ? null : _loginWithOIDC,
                            icon: const Icon(Icons.security),
                            label: const Text('syou551.devでログイン'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: themeState.selectedColor.primaryColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _createAccountWithOIDC,
                            icon: const Icon(Icons.person_add_alt_1),
                            label: const Text('syou551.devでアカウント作成'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

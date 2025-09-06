import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/backend_client.dart';
import '../../../core/services/backend_notification_service.dart';

// AuthServiceのProvider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// 認証状態の管理
class AuthState {
  final bool isAuthenticated;
  final String? accessToken;
  final UserInfo? userInfo;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.isAuthenticated = false,
    this.accessToken,
    this.userInfo,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? accessToken,
    UserInfo? userInfo,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      accessToken: accessToken ?? this.accessToken,
      userInfo: userInfo ?? this.userInfo,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// 認証状態のNotifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState()) {
    _checkAuthStatus();
  }

  /// 認証状態をチェック
  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final accessToken = await _authService.getAccessToken();
      if (accessToken != null) {
        final userInfo = await _authService.getUserInfo();
        state = state.copyWith(
          isAuthenticated: true,
          accessToken: accessToken,
          userInfo: userInfo,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isAuthenticated: false,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// ログイン
  Future<bool> login() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      final result = await _authService.loginWithOIDC();
      final userInfo = await _authService.getUserInfo();
      
      state = state.copyWith(
        isAuthenticated: true,
        accessToken: result.accessToken,
        userInfo: userInfo,
        isLoading: false,
      );
      
      return true;
    } catch (e) {
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// ログアウト
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await _authService.logout();
      state = state.copyWith(
        isAuthenticated: false,
        accessToken: null,
        userInfo: null,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// ユーザー情報を更新
  Future<bool> updateUserProfile({required String name, String? picture}) async {
    try {
      final success = await _authService.updateUserProfile(name: name, picture: picture);
      if (success) {
        final userInfo = await _authService.getUserInfo();
        state = state.copyWith(userInfo: userInfo);
      }
      return success;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  /// エラーをクリア
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// 認証状態のProvider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

// BackendNotificationServiceのProvider（認証状態に依存）
final backendNotificationServiceProvider = Provider<BackendNotificationService?>((ref) {
  final authState = ref.watch(authProvider);
  
  if (!authState.isAuthenticated || authState.accessToken == null) {
    return null;
  }

  final channel = BackendClientFactory.createChannel(
    host: AuthService.backendHost,
    port: AuthService.backendPort,
    useTls: false,
  );
  
  final client = BackendClientFactory.createNotificationClient(channel);
  
  return BackendNotificationService(
    client: client,
    accessToken: authState.accessToken!,
  );
});

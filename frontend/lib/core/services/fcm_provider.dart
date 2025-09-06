import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'fcm_service.dart';
import 'backend_notification_service.dart';
import '../../features/auth/data/auth_provider.dart';

// FCMサービスの初期化状態を管理
class FCMState {
  final bool isInitialized;
  final String? errorMessage;

  const FCMState({
    this.isInitialized = false,
    this.errorMessage,
  });

  FCMState copyWith({
    bool? isInitialized,
    String? errorMessage,
  }) {
    return FCMState(
      isInitialized: isInitialized ?? this.isInitialized,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// FCMサービスのNotifier
class FCMNotifier extends StateNotifier<FCMState> {
  FCMNotifier() : super(const FCMState());

  /// FCMサービスを初期化
  Future<void> initialize(BackendNotificationService? backendService) async {
    try {
      await FCMService.initialize(backendService);
      state = state.copyWith(isInitialized: true, errorMessage: null);
    } catch (e) {
      state = state.copyWith(
        isInitialized: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// FCMサービスを再初期化
  Future<void> reinitialize(BackendNotificationService? backendService) async {
    await initialize(backendService);
  }

  /// エラーをクリア
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// FCMサービスのProvider
final fcmProvider = StateNotifierProvider<FCMNotifier, FCMState>((ref) {
  return FCMNotifier();
});

// FCMサービスを自動初期化するProvider
final fcmInitializerProvider = Provider<void>((ref) {
  final authState = ref.watch(authProvider);
  final backendService = ref.watch(backendNotificationServiceProvider);
  final fcmNotifier = ref.read(fcmProvider.notifier);

  // 認証状態が変わったときにFCMサービスを初期化/再初期化
  if (authState.isAuthenticated && backendService != null) {
    fcmNotifier.reinitialize(backendService);
  }
});

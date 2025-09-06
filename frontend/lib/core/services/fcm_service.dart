import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'backend_notification_service.dart';
import 'notification_service.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static BackendNotificationService? _backendService;

  /// FCMサービスを初期化
  static Future<void> initialize(BackendNotificationService? backendService) async {
    _backendService = backendService;

    // 通知権限をリクエスト
    await _requestPermission();

    // トークンを取得して登録
    await _registerToken();

    // トークン更新のリスナーを設定
    _messaging.onTokenRefresh.listen((token) {
      _registerTokenWithBackend(token);
    });

    // フォアグラウンドメッセージのハンドラーを設定
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // バックグラウンドメッセージのハンドラーを設定
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // アプリが終了状態から通知タップで起動された場合のハンドラー
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }
  }

  /// 通知権限をリクエスト
  static Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('FCM Permission status: ${settings.authorizationStatus}');
    }
  }

  /// トークンを取得して登録
  static Future<void> _registerToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _registerTokenWithBackend(token);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get FCM token: $e');
      }
    }
  }

  /// バックエンドにトークンを登録
  static Future<void> _registerTokenWithBackend(String token) async {
    if (_backendService == null) {
      if (kDebugMode) {
        print('Backend service not available for FCM token registration');
      }
      return;
    }

    try {
      final success = await _backendService!.registerFCMToken(token);
      if (kDebugMode) {
        print('FCM token registration: ${success ? "success" : "failed"}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to register FCM token with backend: $e');
      }
    }
  }

  /// フォアグラウンドメッセージをハンドル
  static void _handleForegroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('Received foreground message: ${message.messageId}');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Data: ${message.data}');
    }

    // ローカル通知として表示
    NotificationService.showNotification(
      title: message.notification?.title ?? '通知',
      body: message.notification?.body ?? '',
      payload: message.data.toString(),
    );
  }

  /// 通知タップ時のハンドル
  static void _handleMessageOpenedApp(RemoteMessage message) {
    if (kDebugMode) {
      print('Message opened app: ${message.messageId}');
      print('Data: ${message.data}');
    }

    // TODO: 通知の種類に応じて適切なページに遷移
    // 例: チャンネル詳細ページ、配信ページなど
  }

  /// トークンを削除
  static Future<void> unregisterToken() async {
    if (_backendService == null) return;

    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _backendService!.unregisterFCMToken(token);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to unregister FCM token: $e');
      }
    }
  }

  /// トークンを取得
  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:oshizatsu_frontend/core/services/backend_client.dart';
import 'package:oshizatsu_frontend/generated/oshizatsu.pb.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oshizatsu_frontend/core/services/auth_service.dart';

class FirebaseService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static Future<void> initialize() async {
    try {
      // 通知権限をリクエスト
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }

      // FCMトークンを取得
      try {
        String? token = await _messaging.getToken();
        print('FCM Token: $token');
      } catch (e) {
        print('Failed to get FCM token: $e');
        // FIS_AUTH_ERRORは一般的なエラーで、アプリの動作には影響しない
        if (e.toString().contains('FIS_AUTH_ERROR')) {
          print('Firebase authentication error - this is normal for development builds');
        }
        // トークン取得に失敗してもアプリは動作を続ける
      }

      // ローカル通知の初期化
      await _initializeLocalNotifications();

      // フォアグラウンドメッセージハンドラー
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // バックグラウンドメッセージハンドラー
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // 通知タップハンドラー
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // バックエンドにFCMトークンを登録
      await _registerFCMToken();
    } catch (e) {
      print('Firebase Service initialization error: $e');
      // 初期化に失敗してもアプリは動作を続ける
    }
  }

  // gRPCのBackendClientを使用してFCMトークンを登録
  static Future<void> _registerFCMToken() async {
    try {
      final token = await _messaging.getToken();
      final accessToken = await _secureStorage.read(key: 'access_token');
      
      if (token == null || accessToken == null) {
        print('FCM Token or access token is null, skipping registration');
        return;
      }
      
      print('FCM Token: $token');
      final channel = BackendClientFactory.createChannel(host: AuthService.backendHost, port: AuthService.backendPort, useTls: false);
      final backendClient = BackendClientFactory.createNotificationClient(channel);
      
      // uuidなど適切にリクエストを形成して登録を行う
      final resp = await backendClient.registerFCMToken(RegisterFCMTokenRequest(fcmToken: token, accessToken: accessToken));
      print('FCM Token registered: $resp');
    } catch (e) {
      print('Failed to register FCM token: $e');
    }
  }

  static Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Android通知チャンネルの作成
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'oshizatsu_notifications',
      '推し雑通知',
      description: '推しのライブ配信通知',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      _showLocalNotification(message);
    }
  }

  static void _handleNotificationTap(RemoteMessage message) {
    print('Notification tapped: ${message.data}');
    // TODO: 通知タップ時の処理を実装
    // アプリを開く
    // FlutterApp.app.then((app) => app.navigate('/channels'));
  }

  static void _onNotificationTapped(NotificationResponse response) {
    print('Local notification tapped: ${response.payload}');
    // TODO: ローカル通知タップ時の処理を実装
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'oshizatsu_notifications',
      '推し雑通知',
      channelDescription: '推しのライブ配信通知',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? '推し雑',
      message.notification?.body ?? '',
      platformChannelSpecifics,
      payload: message.data.toString(),
    );
  }

  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  static Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }
}

// バックグラウンドメッセージハンドラー
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  print('Message data: ${message.data}');
  print('Message notification: ${message.notification?.title}');
}

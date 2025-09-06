import 'package:grpc/grpc.dart' as grpc;
import 'package:oshizatsu_frontend/generated/oshizatsu.pb.dart' as pb;
import 'package:oshizatsu_frontend/generated/oshizatsu.pbgrpc.dart' as pbgrpc;

class BackendNotificationService {
  final pbgrpc.NotificationServiceClient _client;
  final String _accessToken;

  BackendNotificationService({
    required pbgrpc.NotificationServiceClient client,
    required String accessToken,
  })  : _client = client,
        _accessToken = accessToken;

  /// 通知一覧を取得
  Future<List<pb.Notification>> getNotifications({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final request = pb.GetNotificationsRequest()
        ..accessToken = _accessToken
        ..limit = limit
        ..offset = offset;

      final response = await _client.getNotifications(request);
      return response.notifications;
    } on grpc.GrpcError catch (e) {
      throw BackendNotificationException(
        'Failed to get notifications: ${e.message}',
        0,
      );
    } catch (e) {
      throw BackendNotificationException(
        'Unexpected error while getting notifications: $e',
        0,
      );
    }
  }

  /// FCMトークンを登録
  Future<bool> registerFCMToken(String fcmToken) async {
    try {
      final request = pb.RegisterFCMTokenRequest()
        ..fcmToken = fcmToken
        ..accessToken = _accessToken;

      final response = await _client.registerFCMToken(request);
      return response.success;
    } on grpc.GrpcError catch (e) {
      throw BackendNotificationException(
        'Failed to register FCM token: ${e.message}',
        0,
      );
    } catch (e) {
      throw BackendNotificationException(
        'Unexpected error while registering FCM token: $e',
        0,
      );
    }
  }

  /// FCMトークンを削除
  Future<bool> unregisterFCMToken(String fcmToken) async {
    try {
      final request = pb.UnregisterFCMTokenRequest()
        ..fcmToken = fcmToken
        ..accessToken = _accessToken;

      final response = await _client.unregisterFCMToken(request);
      return response.success;
    } on grpc.GrpcError catch (e) {
      throw BackendNotificationException(
        'Failed to unregister FCM token: ${e.message}',
        0,
      );
    } catch (e) {
      throw BackendNotificationException(
        'Unexpected error while unregistering FCM token: $e',
        0,
      );
    }
  }

  /// 通知を既読にする
  Future<bool> markNotificationAsRead(String notificationId) async {
    try {
      final request = pb.MarkNotificationAsReadRequest()
        ..notificationId = notificationId
        ..accessToken = _accessToken;

      final response = await _client.markNotificationAsRead(request);
      return response.success;
    } on grpc.GrpcError catch (e) {
      throw BackendNotificationException(
        'Failed to mark notification as read: ${e.message}',
        0,
      );
    } catch (e) {
      throw BackendNotificationException(
        'Unexpected error while marking notification as read: $e',
        0,
      );
    }
  }

  /// 通知を削除
  Future<bool> deleteNotification(String notificationId) async {
    try {
      final request = pb.DeleteNotificationRequest()
        ..notificationId = notificationId
        ..accessToken = _accessToken;

      final response = await _client.deleteNotification(request);
      return response.success;
    } on grpc.GrpcError catch (e) {
      throw BackendNotificationException(
        'Failed to delete notification: ${e.message}',
        0,
      );
    } catch (e) {
      throw BackendNotificationException(
        'Unexpected error while deleting notification: $e',
        0,
      );
    }
  }
}

class BackendNotificationException implements Exception {
  final String message;
  final int code;

  BackendNotificationException(this.message, this.code);

  @override
  String toString() => 'BackendNotificationException: $message (Code: $code)';
}

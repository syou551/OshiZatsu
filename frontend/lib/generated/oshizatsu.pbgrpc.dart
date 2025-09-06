//
//  Generated code. Do not modify.
//  source: oshizatsu.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'oshizatsu.pb.dart' as $0;

export 'oshizatsu.pb.dart';

@$pb.GrpcServiceName('oshizatsu.AuthService')
class AuthServiceClient extends $grpc.Client {
  static final _$login = $grpc.ClientMethod<$0.LoginRequest, $0.LoginResponse>(
      '/oshizatsu.AuthService/Login',
      ($0.LoginRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.LoginResponse.fromBuffer(value));
  static final _$logout = $grpc.ClientMethod<$0.LogoutRequest, $0.LogoutResponse>(
      '/oshizatsu.AuthService/Logout',
      ($0.LogoutRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.LogoutResponse.fromBuffer(value));
  static final _$getUserInfo = $grpc.ClientMethod<$0.GetUserInfoRequest, $0.GetUserInfoResponse>(
      '/oshizatsu.AuthService/GetUserInfo',
      ($0.GetUserInfoRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.GetUserInfoResponse.fromBuffer(value));
  static final _$updateUserInfo = $grpc.ClientMethod<$0.UpdateUserInfoRequest, $0.UpdateUserInfoResponse>(
      '/oshizatsu.AuthService/UpdateUserInfo',
      ($0.UpdateUserInfoRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.UpdateUserInfoResponse.fromBuffer(value));

  AuthServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.LoginResponse> login($0.LoginRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$login, request, options: options);
  }

  $grpc.ResponseFuture<$0.LogoutResponse> logout($0.LogoutRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$logout, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetUserInfoResponse> getUserInfo($0.GetUserInfoRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getUserInfo, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateUserInfoResponse> updateUserInfo($0.UpdateUserInfoRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateUserInfo, request, options: options);
  }
}

@$pb.GrpcServiceName('oshizatsu.AuthService')
abstract class AuthServiceBase extends $grpc.Service {
  $core.String get $name => 'oshizatsu.AuthService';

  AuthServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.LoginRequest, $0.LoginResponse>(
        'Login',
        login_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LoginRequest.fromBuffer(value),
        ($0.LoginResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LogoutRequest, $0.LogoutResponse>(
        'Logout',
        logout_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LogoutRequest.fromBuffer(value),
        ($0.LogoutResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetUserInfoRequest, $0.GetUserInfoResponse>(
        'GetUserInfo',
        getUserInfo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetUserInfoRequest.fromBuffer(value),
        ($0.GetUserInfoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateUserInfoRequest, $0.UpdateUserInfoResponse>(
        'UpdateUserInfo',
        updateUserInfo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UpdateUserInfoRequest.fromBuffer(value),
        ($0.UpdateUserInfoResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.LoginResponse> login_Pre($grpc.ServiceCall call, $async.Future<$0.LoginRequest> request) async {
    return login(call, await request);
  }

  $async.Future<$0.LogoutResponse> logout_Pre($grpc.ServiceCall call, $async.Future<$0.LogoutRequest> request) async {
    return logout(call, await request);
  }

  $async.Future<$0.GetUserInfoResponse> getUserInfo_Pre($grpc.ServiceCall call, $async.Future<$0.GetUserInfoRequest> request) async {
    return getUserInfo(call, await request);
  }

  $async.Future<$0.UpdateUserInfoResponse> updateUserInfo_Pre($grpc.ServiceCall call, $async.Future<$0.UpdateUserInfoRequest> request) async {
    return updateUserInfo(call, await request);
  }

  $async.Future<$0.LoginResponse> login($grpc.ServiceCall call, $0.LoginRequest request);
  $async.Future<$0.LogoutResponse> logout($grpc.ServiceCall call, $0.LogoutRequest request);
  $async.Future<$0.GetUserInfoResponse> getUserInfo($grpc.ServiceCall call, $0.GetUserInfoRequest request);
  $async.Future<$0.UpdateUserInfoResponse> updateUserInfo($grpc.ServiceCall call, $0.UpdateUserInfoRequest request);
}
@$pb.GrpcServiceName('oshizatsu.ChannelService')
class ChannelServiceClient extends $grpc.Client {
  static final _$subscribeChannel = $grpc.ClientMethod<$0.SubscribeChannelRequest, $0.SubscribeChannelResponse>(
      '/oshizatsu.ChannelService/SubscribeChannel',
      ($0.SubscribeChannelRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SubscribeChannelResponse.fromBuffer(value));
  static final _$unsubscribeChannel = $grpc.ClientMethod<$0.UnsubscribeChannelRequest, $0.UnsubscribeChannelResponse>(
      '/oshizatsu.ChannelService/UnsubscribeChannel',
      ($0.UnsubscribeChannelRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.UnsubscribeChannelResponse.fromBuffer(value));
  static final _$getSubscribedChannels = $grpc.ClientMethod<$0.GetSubscribedChannelsRequest, $0.GetSubscribedChannelsResponse>(
      '/oshizatsu.ChannelService/GetSubscribedChannels',
      ($0.GetSubscribedChannelsRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.GetSubscribedChannelsResponse.fromBuffer(value));

  ChannelServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.SubscribeChannelResponse> subscribeChannel($0.SubscribeChannelRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$subscribeChannel, request, options: options);
  }

  $grpc.ResponseFuture<$0.UnsubscribeChannelResponse> unsubscribeChannel($0.UnsubscribeChannelRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$unsubscribeChannel, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetSubscribedChannelsResponse> getSubscribedChannels($0.GetSubscribedChannelsRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getSubscribedChannels, request, options: options);
  }
}

@$pb.GrpcServiceName('oshizatsu.ChannelService')
abstract class ChannelServiceBase extends $grpc.Service {
  $core.String get $name => 'oshizatsu.ChannelService';

  ChannelServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SubscribeChannelRequest, $0.SubscribeChannelResponse>(
        'SubscribeChannel',
        subscribeChannel_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SubscribeChannelRequest.fromBuffer(value),
        ($0.SubscribeChannelResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UnsubscribeChannelRequest, $0.UnsubscribeChannelResponse>(
        'UnsubscribeChannel',
        unsubscribeChannel_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UnsubscribeChannelRequest.fromBuffer(value),
        ($0.UnsubscribeChannelResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetSubscribedChannelsRequest, $0.GetSubscribedChannelsResponse>(
        'GetSubscribedChannels',
        getSubscribedChannels_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetSubscribedChannelsRequest.fromBuffer(value),
        ($0.GetSubscribedChannelsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.SubscribeChannelResponse> subscribeChannel_Pre($grpc.ServiceCall call, $async.Future<$0.SubscribeChannelRequest> request) async {
    return subscribeChannel(call, await request);
  }

  $async.Future<$0.UnsubscribeChannelResponse> unsubscribeChannel_Pre($grpc.ServiceCall call, $async.Future<$0.UnsubscribeChannelRequest> request) async {
    return unsubscribeChannel(call, await request);
  }

  $async.Future<$0.GetSubscribedChannelsResponse> getSubscribedChannels_Pre($grpc.ServiceCall call, $async.Future<$0.GetSubscribedChannelsRequest> request) async {
    return getSubscribedChannels(call, await request);
  }

  $async.Future<$0.SubscribeChannelResponse> subscribeChannel($grpc.ServiceCall call, $0.SubscribeChannelRequest request);
  $async.Future<$0.UnsubscribeChannelResponse> unsubscribeChannel($grpc.ServiceCall call, $0.UnsubscribeChannelRequest request);
  $async.Future<$0.GetSubscribedChannelsResponse> getSubscribedChannels($grpc.ServiceCall call, $0.GetSubscribedChannelsRequest request);
}
@$pb.GrpcServiceName('oshizatsu.NotificationService')
class NotificationServiceClient extends $grpc.Client {
  static final _$registerFCMToken = $grpc.ClientMethod<$0.RegisterFCMTokenRequest, $0.RegisterFCMTokenResponse>(
      '/oshizatsu.NotificationService/RegisterFCMToken',
      ($0.RegisterFCMTokenRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.RegisterFCMTokenResponse.fromBuffer(value));
  static final _$unregisterFCMToken = $grpc.ClientMethod<$0.UnregisterFCMTokenRequest, $0.UnregisterFCMTokenResponse>(
      '/oshizatsu.NotificationService/UnregisterFCMToken',
      ($0.UnregisterFCMTokenRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.UnregisterFCMTokenResponse.fromBuffer(value));
  static final _$getNotifications = $grpc.ClientMethod<$0.GetNotificationsRequest, $0.GetNotificationsResponse>(
      '/oshizatsu.NotificationService/GetNotifications',
      ($0.GetNotificationsRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.GetNotificationsResponse.fromBuffer(value));
  static final _$markNotificationAsRead = $grpc.ClientMethod<$0.MarkNotificationAsReadRequest, $0.MarkNotificationAsReadResponse>(
      '/oshizatsu.NotificationService/MarkNotificationAsRead',
      ($0.MarkNotificationAsReadRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MarkNotificationAsReadResponse.fromBuffer(value));
  static final _$deleteNotification = $grpc.ClientMethod<$0.DeleteNotificationRequest, $0.DeleteNotificationResponse>(
      '/oshizatsu.NotificationService/DeleteNotification',
      ($0.DeleteNotificationRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.DeleteNotificationResponse.fromBuffer(value));

  NotificationServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.RegisterFCMTokenResponse> registerFCMToken($0.RegisterFCMTokenRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$registerFCMToken, request, options: options);
  }

  $grpc.ResponseFuture<$0.UnregisterFCMTokenResponse> unregisterFCMToken($0.UnregisterFCMTokenRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$unregisterFCMToken, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetNotificationsResponse> getNotifications($0.GetNotificationsRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getNotifications, request, options: options);
  }

  $grpc.ResponseFuture<$0.MarkNotificationAsReadResponse> markNotificationAsRead($0.MarkNotificationAsReadRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$markNotificationAsRead, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteNotificationResponse> deleteNotification($0.DeleteNotificationRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteNotification, request, options: options);
  }
}

@$pb.GrpcServiceName('oshizatsu.NotificationService')
abstract class NotificationServiceBase extends $grpc.Service {
  $core.String get $name => 'oshizatsu.NotificationService';

  NotificationServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.RegisterFCMTokenRequest, $0.RegisterFCMTokenResponse>(
        'RegisterFCMToken',
        registerFCMToken_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RegisterFCMTokenRequest.fromBuffer(value),
        ($0.RegisterFCMTokenResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UnregisterFCMTokenRequest, $0.UnregisterFCMTokenResponse>(
        'UnregisterFCMToken',
        unregisterFCMToken_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UnregisterFCMTokenRequest.fromBuffer(value),
        ($0.UnregisterFCMTokenResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetNotificationsRequest, $0.GetNotificationsResponse>(
        'GetNotifications',
        getNotifications_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetNotificationsRequest.fromBuffer(value),
        ($0.GetNotificationsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MarkNotificationAsReadRequest, $0.MarkNotificationAsReadResponse>(
        'MarkNotificationAsRead',
        markNotificationAsRead_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.MarkNotificationAsReadRequest.fromBuffer(value),
        ($0.MarkNotificationAsReadResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteNotificationRequest, $0.DeleteNotificationResponse>(
        'DeleteNotification',
        deleteNotification_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DeleteNotificationRequest.fromBuffer(value),
        ($0.DeleteNotificationResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.RegisterFCMTokenResponse> registerFCMToken_Pre($grpc.ServiceCall call, $async.Future<$0.RegisterFCMTokenRequest> request) async {
    return registerFCMToken(call, await request);
  }

  $async.Future<$0.UnregisterFCMTokenResponse> unregisterFCMToken_Pre($grpc.ServiceCall call, $async.Future<$0.UnregisterFCMTokenRequest> request) async {
    return unregisterFCMToken(call, await request);
  }

  $async.Future<$0.GetNotificationsResponse> getNotifications_Pre($grpc.ServiceCall call, $async.Future<$0.GetNotificationsRequest> request) async {
    return getNotifications(call, await request);
  }

  $async.Future<$0.MarkNotificationAsReadResponse> markNotificationAsRead_Pre($grpc.ServiceCall call, $async.Future<$0.MarkNotificationAsReadRequest> request) async {
    return markNotificationAsRead(call, await request);
  }

  $async.Future<$0.DeleteNotificationResponse> deleteNotification_Pre($grpc.ServiceCall call, $async.Future<$0.DeleteNotificationRequest> request) async {
    return deleteNotification(call, await request);
  }

  $async.Future<$0.RegisterFCMTokenResponse> registerFCMToken($grpc.ServiceCall call, $0.RegisterFCMTokenRequest request);
  $async.Future<$0.UnregisterFCMTokenResponse> unregisterFCMToken($grpc.ServiceCall call, $0.UnregisterFCMTokenRequest request);
  $async.Future<$0.GetNotificationsResponse> getNotifications($grpc.ServiceCall call, $0.GetNotificationsRequest request);
  $async.Future<$0.MarkNotificationAsReadResponse> markNotificationAsRead($grpc.ServiceCall call, $0.MarkNotificationAsReadRequest request);
  $async.Future<$0.DeleteNotificationResponse> deleteNotification($grpc.ServiceCall call, $0.DeleteNotificationRequest request);
}

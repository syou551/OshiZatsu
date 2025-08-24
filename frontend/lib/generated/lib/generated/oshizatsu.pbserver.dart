//
//  Generated code. Do not modify.
//  source: lib/generated/oshizatsu.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'oshizatsu.pb.dart' as $1;
import 'oshizatsu.pbjson.dart';

export 'oshizatsu.pb.dart';

abstract class AuthServiceBase extends $pb.GeneratedService {
  $async.Future<$1.LoginResponse> login($pb.ServerContext ctx, $1.LoginRequest request);
  $async.Future<$1.LogoutResponse> logout($pb.ServerContext ctx, $1.LogoutRequest request);
  $async.Future<$1.GetUserInfoResponse> getUserInfo($pb.ServerContext ctx, $1.GetUserInfoRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'Login': return $1.LoginRequest();
      case 'Logout': return $1.LogoutRequest();
      case 'GetUserInfo': return $1.GetUserInfoRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'Login': return this.login(ctx, request as $1.LoginRequest);
      case 'Logout': return this.logout(ctx, request as $1.LogoutRequest);
      case 'GetUserInfo': return this.getUserInfo(ctx, request as $1.GetUserInfoRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => AuthServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => AuthServiceBase$messageJson;
}

abstract class ChannelServiceBase extends $pb.GeneratedService {
  $async.Future<$1.SubscribeChannelResponse> subscribeChannel($pb.ServerContext ctx, $1.SubscribeChannelRequest request);
  $async.Future<$1.UnsubscribeChannelResponse> unsubscribeChannel($pb.ServerContext ctx, $1.UnsubscribeChannelRequest request);
  $async.Future<$1.GetSubscribedChannelsResponse> getSubscribedChannels($pb.ServerContext ctx, $1.GetSubscribedChannelsRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'SubscribeChannel': return $1.SubscribeChannelRequest();
      case 'UnsubscribeChannel': return $1.UnsubscribeChannelRequest();
      case 'GetSubscribedChannels': return $1.GetSubscribedChannelsRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'SubscribeChannel': return this.subscribeChannel(ctx, request as $1.SubscribeChannelRequest);
      case 'UnsubscribeChannel': return this.unsubscribeChannel(ctx, request as $1.UnsubscribeChannelRequest);
      case 'GetSubscribedChannels': return this.getSubscribedChannels(ctx, request as $1.GetSubscribedChannelsRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ChannelServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => ChannelServiceBase$messageJson;
}

abstract class NotificationServiceBase extends $pb.GeneratedService {
  $async.Future<$1.RegisterFCMTokenResponse> registerFCMToken($pb.ServerContext ctx, $1.RegisterFCMTokenRequest request);
  $async.Future<$1.UnregisterFCMTokenResponse> unregisterFCMToken($pb.ServerContext ctx, $1.UnregisterFCMTokenRequest request);
  $async.Future<$1.GetNotificationsResponse> getNotifications($pb.ServerContext ctx, $1.GetNotificationsRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'RegisterFCMToken': return $1.RegisterFCMTokenRequest();
      case 'UnregisterFCMToken': return $1.UnregisterFCMTokenRequest();
      case 'GetNotifications': return $1.GetNotificationsRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'RegisterFCMToken': return this.registerFCMToken(ctx, request as $1.RegisterFCMTokenRequest);
      case 'UnregisterFCMToken': return this.unregisterFCMToken(ctx, request as $1.UnregisterFCMTokenRequest);
      case 'GetNotifications': return this.getNotifications(ctx, request as $1.GetNotificationsRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => NotificationServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => NotificationServiceBase$messageJson;
}


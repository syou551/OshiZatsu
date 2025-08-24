//
//  Generated code. Do not modify.
//  source: lib/generated/oshizatsu.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../google/protobuf/timestamp.pbjson.dart' as $0;

@$core.Deprecated('Use notificationTypeDescriptor instead')
const NotificationType$json = {
  '1': 'NotificationType',
  '2': [
    {'1': 'SCHEDULED', '2': 0},
    {'1': 'STARTED', '2': 1},
  ],
};

/// Descriptor for `NotificationType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List notificationTypeDescriptor = $convert.base64Decode(
    'ChBOb3RpZmljYXRpb25UeXBlEg0KCVNDSEVEVUxFRBAAEgsKB1NUQVJURUQQAQ==');

@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = {
  '1': 'LoginRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSFAoFZW1haWwYASABKAlSBWVtYWlsEhoKCHBhc3N3b3JkGAIgASgJUg'
    'hwYXNzd29yZA==');

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = {
  '1': 'LoginResponse',
  '2': [
    {'1': 'access_token', '3': 1, '4': 1, '5': 9, '10': 'accessToken'},
    {'1': 'refresh_token', '3': 2, '4': 1, '5': 9, '10': 'refreshToken'},
    {'1': 'user_info', '3': 3, '4': 1, '5': 11, '6': '.oshizatsu.UserInfo', '10': 'userInfo'},
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEiEKDGFjY2Vzc190b2tlbhgBIAEoCVILYWNjZXNzVG9rZW4SIwoNcm'
    'VmcmVzaF90b2tlbhgCIAEoCVIMcmVmcmVzaFRva2VuEjAKCXVzZXJfaW5mbxgDIAEoCzITLm9z'
    'aGl6YXRzdS5Vc2VySW5mb1IIdXNlckluZm8=');

@$core.Deprecated('Use logoutRequestDescriptor instead')
const LogoutRequest$json = {
  '1': 'LogoutRequest',
  '2': [
    {'1': 'access_token', '3': 1, '4': 1, '5': 9, '10': 'accessToken'},
  ],
};

/// Descriptor for `LogoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutRequestDescriptor = $convert.base64Decode(
    'Cg1Mb2dvdXRSZXF1ZXN0EiEKDGFjY2Vzc190b2tlbhgBIAEoCVILYWNjZXNzVG9rZW4=');

@$core.Deprecated('Use logoutResponseDescriptor instead')
const LogoutResponse$json = {
  '1': 'LogoutResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `LogoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutResponseDescriptor = $convert.base64Decode(
    'Cg5Mb2dvdXRSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');

@$core.Deprecated('Use getUserInfoRequestDescriptor instead')
const GetUserInfoRequest$json = {
  '1': 'GetUserInfoRequest',
  '2': [
    {'1': 'access_token', '3': 1, '4': 1, '5': 9, '10': 'accessToken'},
  ],
};

/// Descriptor for `GetUserInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserInfoRequestDescriptor = $convert.base64Decode(
    'ChJHZXRVc2VySW5mb1JlcXVlc3QSIQoMYWNjZXNzX3Rva2VuGAEgASgJUgthY2Nlc3NUb2tlbg'
    '==');

@$core.Deprecated('Use getUserInfoResponseDescriptor instead')
const GetUserInfoResponse$json = {
  '1': 'GetUserInfoResponse',
  '2': [
    {'1': 'user_info', '3': 1, '4': 1, '5': 11, '6': '.oshizatsu.UserInfo', '10': 'userInfo'},
  ],
};

/// Descriptor for `GetUserInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserInfoResponseDescriptor = $convert.base64Decode(
    'ChNHZXRVc2VySW5mb1Jlc3BvbnNlEjAKCXVzZXJfaW5mbxgBIAEoCzITLm9zaGl6YXRzdS5Vc2'
    'VySW5mb1IIdXNlckluZm8=');

@$core.Deprecated('Use userInfoDescriptor instead')
const UserInfo$json = {
  '1': 'UserInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'picture', '3': 4, '4': 1, '5': 9, '10': 'picture'},
  ],
};

/// Descriptor for `UserInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userInfoDescriptor = $convert.base64Decode(
    'CghVc2VySW5mbxIOCgJpZBgBIAEoCVICaWQSFAoFZW1haWwYAiABKAlSBWVtYWlsEhIKBG5hbW'
    'UYAyABKAlSBG5hbWUSGAoHcGljdHVyZRgEIAEoCVIHcGljdHVyZQ==');

@$core.Deprecated('Use subscribeChannelRequestDescriptor instead')
const SubscribeChannelRequest$json = {
  '1': 'SubscribeChannelRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'channel_name', '3': 2, '4': 1, '5': 9, '10': 'channelName'},
    {'1': 'access_token', '3': 3, '4': 1, '5': 9, '10': 'accessToken'},
  ],
};

/// Descriptor for `SubscribeChannelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeChannelRequestDescriptor = $convert.base64Decode(
    'ChdTdWJzY3JpYmVDaGFubmVsUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSW'
    'QSIQoMY2hhbm5lbF9uYW1lGAIgASgJUgtjaGFubmVsTmFtZRIhCgxhY2Nlc3NfdG9rZW4YAyAB'
    'KAlSC2FjY2Vzc1Rva2Vu');

@$core.Deprecated('Use subscribeChannelResponseDescriptor instead')
const SubscribeChannelResponse$json = {
  '1': 'SubscribeChannelResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `SubscribeChannelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeChannelResponseDescriptor = $convert.base64Decode(
    'ChhTdWJzY3JpYmVDaGFubmVsUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCg'
    'dtZXNzYWdlGAIgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use unsubscribeChannelRequestDescriptor instead')
const UnsubscribeChannelRequest$json = {
  '1': 'UnsubscribeChannelRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'access_token', '3': 2, '4': 1, '5': 9, '10': 'accessToken'},
  ],
};

/// Descriptor for `UnsubscribeChannelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unsubscribeChannelRequestDescriptor = $convert.base64Decode(
    'ChlVbnN1YnNjcmliZUNoYW5uZWxSZXF1ZXN0Eh0KCmNoYW5uZWxfaWQYASABKAlSCWNoYW5uZW'
    'xJZBIhCgxhY2Nlc3NfdG9rZW4YAiABKAlSC2FjY2Vzc1Rva2Vu');

@$core.Deprecated('Use unsubscribeChannelResponseDescriptor instead')
const UnsubscribeChannelResponse$json = {
  '1': 'UnsubscribeChannelResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `UnsubscribeChannelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unsubscribeChannelResponseDescriptor = $convert.base64Decode(
    'ChpVbnN1YnNjcmliZUNoYW5uZWxSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEh'
    'gKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use getSubscribedChannelsRequestDescriptor instead')
const GetSubscribedChannelsRequest$json = {
  '1': 'GetSubscribedChannelsRequest',
  '2': [
    {'1': 'access_token', '3': 1, '4': 1, '5': 9, '10': 'accessToken'},
  ],
};

/// Descriptor for `GetSubscribedChannelsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSubscribedChannelsRequestDescriptor = $convert.base64Decode(
    'ChxHZXRTdWJzY3JpYmVkQ2hhbm5lbHNSZXF1ZXN0EiEKDGFjY2Vzc190b2tlbhgBIAEoCVILYW'
    'NjZXNzVG9rZW4=');

@$core.Deprecated('Use getSubscribedChannelsResponseDescriptor instead')
const GetSubscribedChannelsResponse$json = {
  '1': 'GetSubscribedChannelsResponse',
  '2': [
    {'1': 'channels', '3': 1, '4': 3, '5': 11, '6': '.oshizatsu.Channel', '10': 'channels'},
  ],
};

/// Descriptor for `GetSubscribedChannelsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSubscribedChannelsResponseDescriptor = $convert.base64Decode(
    'Ch1HZXRTdWJzY3JpYmVkQ2hhbm5lbHNSZXNwb25zZRIuCghjaGFubmVscxgBIAMoCzISLm9zaG'
    'l6YXRzdS5DaGFubmVsUghjaGFubmVscw==');

@$core.Deprecated('Use channelDescriptor instead')
const Channel$json = {
  '1': 'Channel',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'channel_id', '3': 3, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'last_live_scheduled', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'lastLiveScheduled'},
    {'1': 'is_live', '3': 5, '4': 1, '5': 8, '10': 'isLive'},
  ],
};

/// Descriptor for `Channel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List channelDescriptor = $convert.base64Decode(
    'CgdDaGFubmVsEg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEh0KCmNoYW5uZW'
    'xfaWQYAyABKAlSCWNoYW5uZWxJZBJKChNsYXN0X2xpdmVfc2NoZWR1bGVkGAQgASgLMhouZ29v'
    'Z2xlLnByb3RvYnVmLlRpbWVzdGFtcFIRbGFzdExpdmVTY2hlZHVsZWQSFwoHaXNfbGl2ZRgFIA'
    'EoCFIGaXNMaXZl');

@$core.Deprecated('Use registerFCMTokenRequestDescriptor instead')
const RegisterFCMTokenRequest$json = {
  '1': 'RegisterFCMTokenRequest',
  '2': [
    {'1': 'fcm_token', '3': 1, '4': 1, '5': 9, '10': 'fcmToken'},
    {'1': 'access_token', '3': 2, '4': 1, '5': 9, '10': 'accessToken'},
  ],
};

/// Descriptor for `RegisterFCMTokenRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerFCMTokenRequestDescriptor = $convert.base64Decode(
    'ChdSZWdpc3RlckZDTVRva2VuUmVxdWVzdBIbCglmY21fdG9rZW4YASABKAlSCGZjbVRva2VuEi'
    'EKDGFjY2Vzc190b2tlbhgCIAEoCVILYWNjZXNzVG9rZW4=');

@$core.Deprecated('Use registerFCMTokenResponseDescriptor instead')
const RegisterFCMTokenResponse$json = {
  '1': 'RegisterFCMTokenResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RegisterFCMTokenResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerFCMTokenResponseDescriptor = $convert.base64Decode(
    'ChhSZWdpc3RlckZDTVRva2VuUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCg'
    'dtZXNzYWdlGAIgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use unregisterFCMTokenRequestDescriptor instead')
const UnregisterFCMTokenRequest$json = {
  '1': 'UnregisterFCMTokenRequest',
  '2': [
    {'1': 'fcm_token', '3': 1, '4': 1, '5': 9, '10': 'fcmToken'},
    {'1': 'access_token', '3': 2, '4': 1, '5': 9, '10': 'accessToken'},
  ],
};

/// Descriptor for `UnregisterFCMTokenRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unregisterFCMTokenRequestDescriptor = $convert.base64Decode(
    'ChlVbnJlZ2lzdGVyRkNNVG9rZW5SZXF1ZXN0EhsKCWZjbV90b2tlbhgBIAEoCVIIZmNtVG9rZW'
    '4SIQoMYWNjZXNzX3Rva2VuGAIgASgJUgthY2Nlc3NUb2tlbg==');

@$core.Deprecated('Use unregisterFCMTokenResponseDescriptor instead')
const UnregisterFCMTokenResponse$json = {
  '1': 'UnregisterFCMTokenResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `UnregisterFCMTokenResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unregisterFCMTokenResponseDescriptor = $convert.base64Decode(
    'ChpVbnJlZ2lzdGVyRkNNVG9rZW5SZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEh'
    'gKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use getNotificationsRequestDescriptor instead')
const GetNotificationsRequest$json = {
  '1': 'GetNotificationsRequest',
  '2': [
    {'1': 'access_token', '3': 1, '4': 1, '5': 9, '10': 'accessToken'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'offset', '3': 3, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `GetNotificationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getNotificationsRequestDescriptor = $convert.base64Decode(
    'ChdHZXROb3RpZmljYXRpb25zUmVxdWVzdBIhCgxhY2Nlc3NfdG9rZW4YASABKAlSC2FjY2Vzc1'
    'Rva2VuEhQKBWxpbWl0GAIgASgFUgVsaW1pdBIWCgZvZmZzZXQYAyABKAVSBm9mZnNldA==');

@$core.Deprecated('Use getNotificationsResponseDescriptor instead')
const GetNotificationsResponse$json = {
  '1': 'GetNotificationsResponse',
  '2': [
    {'1': 'notifications', '3': 1, '4': 3, '5': 11, '6': '.oshizatsu.Notification', '10': 'notifications'},
    {'1': 'total_count', '3': 2, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `GetNotificationsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getNotificationsResponseDescriptor = $convert.base64Decode(
    'ChhHZXROb3RpZmljYXRpb25zUmVzcG9uc2USPQoNbm90aWZpY2F0aW9ucxgBIAMoCzIXLm9zaG'
    'l6YXRzdS5Ob3RpZmljYXRpb25SDW5vdGlmaWNhdGlvbnMSHwoLdG90YWxfY291bnQYAiABKAVS'
    'CnRvdGFsQ291bnQ=');

@$core.Deprecated('Use notificationDescriptor instead')
const Notification$json = {
  '1': 'Notification',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'body', '3': 3, '4': 1, '5': 9, '10': 'body'},
    {'1': 'channel_id', '3': 4, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'channel_name', '3': 5, '4': 1, '5': 9, '10': 'channelName'},
    {'1': 'type', '3': 6, '4': 1, '5': 14, '6': '.oshizatsu.NotificationType', '10': 'type'},
    {'1': 'created_at', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'is_read', '3': 8, '4': 1, '5': 8, '10': 'isRead'},
  ],
};

/// Descriptor for `Notification`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationDescriptor = $convert.base64Decode(
    'CgxOb3RpZmljYXRpb24SDgoCaWQYASABKAlSAmlkEhQKBXRpdGxlGAIgASgJUgV0aXRsZRISCg'
    'Rib2R5GAMgASgJUgRib2R5Eh0KCmNoYW5uZWxfaWQYBCABKAlSCWNoYW5uZWxJZBIhCgxjaGFu'
    'bmVsX25hbWUYBSABKAlSC2NoYW5uZWxOYW1lEi8KBHR5cGUYBiABKA4yGy5vc2hpemF0c3UuTm'
    '90aWZpY2F0aW9uVHlwZVIEdHlwZRI5CgpjcmVhdGVkX2F0GAcgASgLMhouZ29vZ2xlLnByb3Rv'
    'YnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EhcKB2lzX3JlYWQYCCABKAhSBmlzUmVhZA==');

const $core.Map<$core.String, $core.dynamic> AuthServiceBase$json = {
  '1': 'AuthService',
  '2': [
    {'1': 'Login', '2': '.oshizatsu.LoginRequest', '3': '.oshizatsu.LoginResponse'},
    {'1': 'Logout', '2': '.oshizatsu.LogoutRequest', '3': '.oshizatsu.LogoutResponse'},
    {'1': 'GetUserInfo', '2': '.oshizatsu.GetUserInfoRequest', '3': '.oshizatsu.GetUserInfoResponse'},
  ],
};

@$core.Deprecated('Use authServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> AuthServiceBase$messageJson = {
  '.oshizatsu.LoginRequest': LoginRequest$json,
  '.oshizatsu.LoginResponse': LoginResponse$json,
  '.oshizatsu.UserInfo': UserInfo$json,
  '.oshizatsu.LogoutRequest': LogoutRequest$json,
  '.oshizatsu.LogoutResponse': LogoutResponse$json,
  '.oshizatsu.GetUserInfoRequest': GetUserInfoRequest$json,
  '.oshizatsu.GetUserInfoResponse': GetUserInfoResponse$json,
};

/// Descriptor for `AuthService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List authServiceDescriptor = $convert.base64Decode(
    'CgtBdXRoU2VydmljZRI6CgVMb2dpbhIXLm9zaGl6YXRzdS5Mb2dpblJlcXVlc3QaGC5vc2hpem'
    'F0c3UuTG9naW5SZXNwb25zZRI9CgZMb2dvdXQSGC5vc2hpemF0c3UuTG9nb3V0UmVxdWVzdBoZ'
    'Lm9zaGl6YXRzdS5Mb2dvdXRSZXNwb25zZRJMCgtHZXRVc2VySW5mbxIdLm9zaGl6YXRzdS5HZX'
    'RVc2VySW5mb1JlcXVlc3QaHi5vc2hpemF0c3UuR2V0VXNlckluZm9SZXNwb25zZQ==');

const $core.Map<$core.String, $core.dynamic> ChannelServiceBase$json = {
  '1': 'ChannelService',
  '2': [
    {'1': 'SubscribeChannel', '2': '.oshizatsu.SubscribeChannelRequest', '3': '.oshizatsu.SubscribeChannelResponse'},
    {'1': 'UnsubscribeChannel', '2': '.oshizatsu.UnsubscribeChannelRequest', '3': '.oshizatsu.UnsubscribeChannelResponse'},
    {'1': 'GetSubscribedChannels', '2': '.oshizatsu.GetSubscribedChannelsRequest', '3': '.oshizatsu.GetSubscribedChannelsResponse'},
  ],
};

@$core.Deprecated('Use channelServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> ChannelServiceBase$messageJson = {
  '.oshizatsu.SubscribeChannelRequest': SubscribeChannelRequest$json,
  '.oshizatsu.SubscribeChannelResponse': SubscribeChannelResponse$json,
  '.oshizatsu.UnsubscribeChannelRequest': UnsubscribeChannelRequest$json,
  '.oshizatsu.UnsubscribeChannelResponse': UnsubscribeChannelResponse$json,
  '.oshizatsu.GetSubscribedChannelsRequest': GetSubscribedChannelsRequest$json,
  '.oshizatsu.GetSubscribedChannelsResponse': GetSubscribedChannelsResponse$json,
  '.oshizatsu.Channel': Channel$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
};

/// Descriptor for `ChannelService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List channelServiceDescriptor = $convert.base64Decode(
    'Cg5DaGFubmVsU2VydmljZRJbChBTdWJzY3JpYmVDaGFubmVsEiIub3NoaXphdHN1LlN1YnNjcm'
    'liZUNoYW5uZWxSZXF1ZXN0GiMub3NoaXphdHN1LlN1YnNjcmliZUNoYW5uZWxSZXNwb25zZRJh'
    'ChJVbnN1YnNjcmliZUNoYW5uZWwSJC5vc2hpemF0c3UuVW5zdWJzY3JpYmVDaGFubmVsUmVxdW'
    'VzdBolLm9zaGl6YXRzdS5VbnN1YnNjcmliZUNoYW5uZWxSZXNwb25zZRJqChVHZXRTdWJzY3Jp'
    'YmVkQ2hhbm5lbHMSJy5vc2hpemF0c3UuR2V0U3Vic2NyaWJlZENoYW5uZWxzUmVxdWVzdBooLm'
    '9zaGl6YXRzdS5HZXRTdWJzY3JpYmVkQ2hhbm5lbHNSZXNwb25zZQ==');

const $core.Map<$core.String, $core.dynamic> NotificationServiceBase$json = {
  '1': 'NotificationService',
  '2': [
    {'1': 'RegisterFCMToken', '2': '.oshizatsu.RegisterFCMTokenRequest', '3': '.oshizatsu.RegisterFCMTokenResponse'},
    {'1': 'UnregisterFCMToken', '2': '.oshizatsu.UnregisterFCMTokenRequest', '3': '.oshizatsu.UnregisterFCMTokenResponse'},
    {'1': 'GetNotifications', '2': '.oshizatsu.GetNotificationsRequest', '3': '.oshizatsu.GetNotificationsResponse'},
  ],
};

@$core.Deprecated('Use notificationServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> NotificationServiceBase$messageJson = {
  '.oshizatsu.RegisterFCMTokenRequest': RegisterFCMTokenRequest$json,
  '.oshizatsu.RegisterFCMTokenResponse': RegisterFCMTokenResponse$json,
  '.oshizatsu.UnregisterFCMTokenRequest': UnregisterFCMTokenRequest$json,
  '.oshizatsu.UnregisterFCMTokenResponse': UnregisterFCMTokenResponse$json,
  '.oshizatsu.GetNotificationsRequest': GetNotificationsRequest$json,
  '.oshizatsu.GetNotificationsResponse': GetNotificationsResponse$json,
  '.oshizatsu.Notification': Notification$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
};

/// Descriptor for `NotificationService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List notificationServiceDescriptor = $convert.base64Decode(
    'ChNOb3RpZmljYXRpb25TZXJ2aWNlElsKEFJlZ2lzdGVyRkNNVG9rZW4SIi5vc2hpemF0c3UuUm'
    'VnaXN0ZXJGQ01Ub2tlblJlcXVlc3QaIy5vc2hpemF0c3UuUmVnaXN0ZXJGQ01Ub2tlblJlc3Bv'
    'bnNlEmEKElVucmVnaXN0ZXJGQ01Ub2tlbhIkLm9zaGl6YXRzdS5VbnJlZ2lzdGVyRkNNVG9rZW'
    '5SZXF1ZXN0GiUub3NoaXphdHN1LlVucmVnaXN0ZXJGQ01Ub2tlblJlc3BvbnNlElsKEEdldE5v'
    'dGlmaWNhdGlvbnMSIi5vc2hpemF0c3UuR2V0Tm90aWZpY2F0aW9uc1JlcXVlc3QaIy5vc2hpem'
    'F0c3UuR2V0Tm90aWZpY2F0aW9uc1Jlc3BvbnNl');


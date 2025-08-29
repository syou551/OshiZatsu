//
//  Generated code. Do not modify.
//  source: oshizatsu.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

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

@$core.Deprecated('Use updateUserInfoRequestDescriptor instead')
const UpdateUserInfoRequest$json = {
  '1': 'UpdateUserInfoRequest',
  '2': [
    {'1': 'access_token', '3': 1, '4': 1, '5': 9, '10': 'accessToken'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'picture', '3': 3, '4': 1, '5': 9, '10': 'picture'},
  ],
};

/// Descriptor for `UpdateUserInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserInfoRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVVc2VySW5mb1JlcXVlc3QSIQoMYWNjZXNzX3Rva2VuGAEgASgJUgthY2Nlc3NUb2'
    'tlbhISCgRuYW1lGAIgASgJUgRuYW1lEhgKB3BpY3R1cmUYAyABKAlSB3BpY3R1cmU=');

@$core.Deprecated('Use updateUserInfoResponseDescriptor instead')
const UpdateUserInfoResponse$json = {
  '1': 'UpdateUserInfoResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'user_info', '3': 3, '4': 1, '5': 11, '6': '.oshizatsu.UserInfo', '10': 'userInfo'},
  ],
};

/// Descriptor for `UpdateUserInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserInfoResponseDescriptor = $convert.base64Decode(
    'ChZVcGRhdGVVc2VySW5mb1Jlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGAoHbW'
    'Vzc2FnZRgCIAEoCVIHbWVzc2FnZRIwCgl1c2VyX2luZm8YAyABKAsyEy5vc2hpemF0c3UuVXNl'
    'ckluZm9SCHVzZXJJbmZv');

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


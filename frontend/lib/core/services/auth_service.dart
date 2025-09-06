import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grpc/grpc.dart' as grpc;

import '../../generated/oshizatsu.pb.dart' as pb;
import 'backend_client.dart';

class AuthService {
  static const String oidcIssuer = String.fromEnvironment(
    'OIDC_ISSUER_URL',
    defaultValue: 'https://auth.syou551.dev/realms/auth',
  );
  static const String oidcClientId = String.fromEnvironment(
    'OIDC_CLIENT_ID',
    defaultValue: 'oshizatsu',
  );
  static const String oidcRedirectUri = String.fromEnvironment(
    'OIDC_REDIRECT_URI',
    defaultValue: 'com.example.frontend:/oauthredirect',
  );
  static const List<String> scopes = ['openid', 'profile', 'email'];

  static const String backendHost = String.fromEnvironment(
    'BACKEND_HOST',
    defaultValue: '127.0.0.1',
  );
  static const int backendPort = int.fromEnvironment(
    'BACKEND_PORT',
    defaultValue: 50052,
  );

  FlutterAppAuth? _appAuth;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  FlutterAppAuth get _getAppAuth {
    _appAuth ??= const FlutterAppAuth();
    return _appAuth!;
  }

  Future<LoginResult> loginWithOIDC() async {
    try {
      final tokenResult = await _getAppAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          oidcClientId,
          oidcRedirectUri,
          discoveryUrl: '$oidcIssuer/.well-known/openid-configuration',
          scopes: scopes,
          preferEphemeralSession: false,
        ),
      );

    final idToken = tokenResult?.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw Exception('OIDC ID token was not returned');
    }

    // Call backend Login with OIDC ID token (email field used as ID token per backend contract)
    print('Backend connection info: $backendHost:$backendPort');
    final channel = BackendClientFactory.createChannel(host: backendHost, port: backendPort, useTls: false);
    final client = BackendClientFactory.createAuthClient(channel);

    try {
      final loginResponse = await client.login(pb.LoginRequest(email: idToken));

      await _secureStorage.write(key: 'access_token', value: loginResponse.accessToken);
      if (loginResponse.refreshToken.isNotEmpty) {
        await _secureStorage.write(key: 'refresh_token', value: loginResponse.refreshToken);
      }

      return LoginResult(
        accessToken: loginResponse.accessToken,
        refreshToken: loginResponse.refreshToken,
      );
    } finally {
      await channel.shutdown();
    }
    } catch (e) {
      print('OAuth authentication error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
  }

  Future<UserInfo?> getUserInfo() async {
    final accessToken = await _secureStorage.read(key: 'access_token');
    if (accessToken == null) return null;

    final channel = BackendClientFactory.createChannel(host: backendHost, port: backendPort, useTls: false);
    final client = BackendClientFactory.createAuthClient(channel);
    try {
      final resp = await client.getUserInfo(pb.GetUserInfoRequest(accessToken: accessToken));
      return UserInfo(
        id: resp.userInfo.id,
        email: resp.userInfo.email,
        name: resp.userInfo.name,
        picture: resp.userInfo.picture,
      );
    } catch (e) {
      print('Failed to get user info: $e');
      return null;
    } finally {
      await channel.shutdown();
    }
  }

  Future<bool> updateUserProfile({required String name, String? picture}) async {
    final accessToken = await _secureStorage.read(key: 'access_token');
    if (accessToken == null) return false;

            final channel = BackendClientFactory.createChannel(host: backendHost, port: backendPort, useTls: false);
      final client = BackendClientFactory.createAuthClient(channel);
    try {
      final resp = await client.updateUserInfo(
        pb.UpdateUserInfoRequest(
          accessToken: accessToken,
          name: name,
          picture: picture ?? '',
        ),
      );
      return resp.success;
    } catch (e) {
      print('Failed to update user profile: $e');
      return false;
    } finally {
      await channel.shutdown();
    }
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access_token');
  }
}

class LoginResult {
  final String accessToken;
  final String refreshToken;

  LoginResult({required this.accessToken, required this.refreshToken});
}

class UserInfo {
  final String id;
  final String email;
  final String name;
  final String picture;

  UserInfo({
    required this.id,
    required this.email,
    required this.name,
    required this.picture,
  });
}

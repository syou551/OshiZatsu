import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grpc/grpc.dart' as grpc;

import '../../generated/lib/generated/oshizatsu.pb.dart' as pb;
import 'backend_client.dart';

class AuthService {
  static const String oidcIssuer = String.fromEnvironment(
    'OIDC_ISSUER_URL',
    defaultValue: 'http://auth.syou551.dev/realms/auth',
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
    defaultValue: 50051,
  );

  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<LoginResult> loginWithOIDC() async {
    final tokenResult = await _appAuth.authorizeAndExchangeCode(
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
    final channel = BackendClientFactory.createChannel(host: backendHost, port: backendPort, useTls: false);
    final client = BackendAuthClient(channel);
    try {
      final resp = await client.login(pb.LoginRequest(email: idToken));
      await _secureStorage.write(key: 'access_token', value: resp.accessToken);
      await _secureStorage.write(key: 'refresh_token', value: resp.refreshToken);
      return LoginResult(accessToken: resp.accessToken, refreshToken: resp.refreshToken);
    } finally {
      await channel.shutdown();
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
  }
}

class LoginResult {
  final String accessToken;
  final String refreshToken;

  LoginResult({required this.accessToken, required this.refreshToken});
}

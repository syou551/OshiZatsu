import 'package:grpc/grpc.dart' as grpc;
import 'package:oshizatsu_frontend/generated/oshizatsu.pb.dart' as pb;
import 'package:oshizatsu_frontend/generated/oshizatsu.pbgrpc.dart' as pbgrpc;

class BackendClientFactory {
  static grpc.ClientChannel createChannel({
    required String host,
    required int port,
    bool useTls = false,
  }) {
    print('Creating gRPC channel: $host:$port (TLS: $useTls)');
    print('Host type: ${host.runtimeType}, Port type: ${port.runtimeType}');
    print('Host value: "$host", Port value: $port');
    
    // 明示的にホストとポートを指定
    final channel = grpc.ClientChannel(
      host,
      port: port,
      options: grpc.ChannelOptions(
        credentials: useTls
            ? grpc.ChannelCredentials.secure(
                onBadCertificate: (cert, host) {
                  // Allow self-signed certificates for development
                  print('Warning: Accepting self-signed certificate for $host');
                  return true;
                },
              )
            : grpc.ChannelCredentials.insecure(),
      ),
    );
    print('gRPC channel created successfully');
    print('Channel type: ${channel.runtimeType}');
    
    // 接続テスト用のログ
    print('Attempting to connect to: $host:$port');
    
    return channel;
  }

  static pbgrpc.AuthServiceClient createAuthClient(grpc.ClientChannel channel) {
    return pbgrpc.AuthServiceClient(channel);
  }

  static pbgrpc.ChannelServiceClient createChannelClient(grpc.ClientChannel channel) {
    return pbgrpc.ChannelServiceClient(channel);
  }

  static pbgrpc.NotificationServiceClient createNotificationClient(grpc.ClientChannel channel) {
    return pbgrpc.NotificationServiceClient(channel);
  }
}

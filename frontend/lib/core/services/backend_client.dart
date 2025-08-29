import 'package:grpc/grpc.dart' as grpc;
import 'package:oshizatsu_frontend/generated/oshizatsu.pb.dart' as pb;
import 'package:oshizatsu_frontend/generated/oshizatsu.pbgrpc.dart' as pbgrpc;

class BackendClientFactory {
  static grpc.ClientChannel createChannel({
    required String host,
    required int port,
    bool useTls = false,
  }) {
    return grpc.ClientChannel(
      host,
      port: port,
      options: grpc.ChannelOptions(
        credentials: useTls
            ? grpc.ChannelCredentials.secure()
            : grpc.ChannelCredentials.insecure(),
      ),
    );
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

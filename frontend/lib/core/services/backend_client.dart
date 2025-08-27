import 'package:grpc/grpc.dart' as grpc;

import '../../generated/lib/generated/oshizatsu.pb.dart' as pb;

class BackendAuthClient extends grpc.Client {
  BackendAuthClient(
    this.channel, {
    grpc.CallOptions? options,
    Iterable<grpc.ClientInterceptor>? interceptors,
  }) : super(channel, options: options, interceptors: interceptors);

  final grpc.ClientChannel channel;

  static final _loginMethod = grpc.ClientMethod<pb.LoginRequest, pb.LoginResponse>(
    '/oshizatsu.AuthService/Login',
    (pb.LoginRequest value) => value.writeToBuffer(),
    (List<int> value) => pb.LoginResponse.fromBuffer(value),
  );

  grpc.ResponseFuture<pb.LoginResponse> login(pb.LoginRequest request, {grpc.CallOptions? options}) {
    return $createUnaryCall(_loginMethod, request, options: options);
  }
}

class BackendClientFactory {
  static grpc.ClientChannel createChannel({required String host, required int port, bool useTls = false}) {
    return grpc.ClientChannel(
      host,
      port: port,
      options: grpc.ChannelOptions(
        credentials: useTls ? const grpc.ChannelCredentials.secure() : const grpc.ChannelCredentials.insecure(),
      ),
    );
  }
}

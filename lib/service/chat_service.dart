import 'package:chat_app/src/generated/helloworld.pb.dart';
import 'package:chat_app/src/generated/helloworld.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class ChatService {
  User user = User();
  static BroadcastClient client = BroadcastClient(
    ClientChannel(
      "10.0.2.2",
      port: 50051,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    ),
  );
  ChatService(String name) {
    user
      ..clearName()
      ..name = name
      ..clearId()
      ..id = sha256.convert(utf8.encode(user.name)).toString();
  }
  Future<Close> sendMessage(String body) async {
    return client.broadcastMessage(
      Message()
        ..id = user.id
        ..content = body
        ..timestamp = DateTime.now().toIso8601String(),
    );
  }

  Stream<Message> recieveMessage() async* {
    Connect connect = Connect()
      ..user = user
      ..active = true;
    await for (var msg in client.createStream(connect)) {
      yield msg;
    }
  }
}

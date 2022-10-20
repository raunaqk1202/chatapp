import 'package:flutter/material.dart';
import 'package:chat_app/src/generated/helloworld.pb.dart';
import 'package:chat_app/service/chat_service.dart';

void main() => runApp(MyChatScreen());

class MyChatScreen extends StatelessWidget {
  const MyChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose a Username"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              TextField(
                controller: controller,
              ),
              MaterialButton(
                child: Text("Submit"),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MessagePage(
                        ChatService(controller.text),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessagePage extends StatefulWidget {
  final ChatService service;
  MessagePage(this.service);
  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  TextEditingController controller = TextEditingController();
  Set<Message> messages = Set();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Page"),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: controller,
              ),
            ),
            MaterialButton(
              child: Text("Submit"),
              onPressed: () {
                widget.service.sendMessage(controller.text);
                print(controller.text);
                controller.clear();
              },
            ),
            Flexible(
              child: StreamBuilder<Message>(
                  stream: widget.service.recieveMessage(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      messages.add(snapshot.data ?? Message());
                      print(snapshot.data);
                    }

                    return ListView(
                      children: messages
                          .map(
                            (msg) => ListTile(
                              leading: Text(msg.id.substring(0, 4)),
                              title: Text(msg.content),
                              subtitle: Text(msg.timestamp),
                            ),
                          )
                          .toList(),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

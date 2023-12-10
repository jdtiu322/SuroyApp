import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  final String receiverFullName;

  const ChatScreen(
      {super.key,
      required this.receiverUserEmail,
      required this.receiverUserID,
      required this.receiverFullName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverFullName)),
    );
  }
}

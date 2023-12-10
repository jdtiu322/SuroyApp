import 'package:flutter/material.dart';
import 'package:suroyapp/models/message.dart';

class MessageDetails extends StatefulWidget {
  final Message message;
  const MessageDetails({Key? key, required this.message}):super(key: key);

  @override
  State<MessageDetails> createState() => _MessageDetailsState();
}

class _MessageDetailsState extends State<MessageDetails> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

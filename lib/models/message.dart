import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String receiverName;
  final String text;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.receiverName,
    required this.text,
    required this.timestamp,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      receiverName: map['receiverName'],
      text: map['text'],
      timestamp: map['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': timestamp,
    };
  }
}

class Conversation {
  String hostId;
  String guestId;
  String hostName;
  String guestName;
  String lastMessage;
  Timestamp timestamp;
  List<String> participants; // Add this field

  Conversation({
    required this.hostId,
    required this.guestId,
    required this.hostName,
    required this.guestName,
    required this.lastMessage,
    required this.timestamp,
    required this.participants, // Add this line
  });

  Map<String, dynamic> toMap() {
    return {
      'hostId': hostId,
      'guestId': guestId,
      'hostName': hostName,
      'guestName': guestName,
      'lastMessage': lastMessage,
      'timestamp': timestamp,
      'participants': participants, // Add this line
    };
  }
}

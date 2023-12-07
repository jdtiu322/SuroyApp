import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SpecificConversationScreen extends StatefulWidget {
  final String conversationId;

  SpecificConversationScreen({required this.conversationId});

  @override
  _SpecificConversationScreenState createState() =>
      _SpecificConversationScreenState();
}

class _SpecificConversationScreenState
    extends State<SpecificConversationScreen> {
  late Stream<QuerySnapshot> _messagesStream;

  @override
  void initState() {
    super.initState();
    _messagesStream = FirebaseFirestore.instance
        .collection('messages')
        .where('conversationId', isEqualTo: widget.conversationId)
        .orderBy('timestamp', descending: false)  // Change to ascending order
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversation"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _messagesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No messages yet.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var message = snapshot.data!.docs[index];
              return ListTile(
                title: Text(message['text']),
                subtitle: Text(
                  DateFormat('MMM dd, yyyy hh:mm a')
                      .format((message['timestamp'] as Timestamp).toDate()),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

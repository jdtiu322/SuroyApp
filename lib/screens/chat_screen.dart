import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String hostId;
  final String guestId;
  final String hostName;

  ChatScreen({
    required this.hostId,
    required this.guestId,
    required this.hostName,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _messageController;
  late Stream<QuerySnapshot> _messagesStream;
  late String displayName = "";

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _messagesStream = FirebaseFirestore.instance
        .collection('messages')
        .where('senderId', whereIn: [widget.hostId, widget.guestId])
        .where('receiverId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  void _sendMessage(String message) async {
    String displayName;

    FirebaseFirestore.instance.collection('messages').add({
      'senderId': FirebaseAuth.instance.currentUser!.uid,
      'receiverId': widget.hostId,
      'text': message,
      'timestamp': Timestamp.now(),
    });
    _messageController.clear();

    if (widget.hostId == FirebaseAuth.instance.currentUser!.uid) {
      displayName = await getUserName(widget.guestId);
    } else {
      displayName = widget.hostName;
    }

    // Now you can use the 'displayName' variable as needed.
    print('DisplayName: $displayName');
  }

  Future<String> getUserName(String renterId) async {
    try {
      // Get the user document where renterId is equal to the provided userID
      var userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('userID', isEqualTo: widget.guestId)
          .get();

      // Check if any documents match the query
      if (userQuery.docs.isNotEmpty) {
        // Retrieve the first document (assuming renterId is unique)
        var userDoc = userQuery.docs.first;

        // Access the 'firstName' and 'lastName' fields
        String firstName = userDoc['firstName'];
        String lastName = userDoc['lastName'];
        String fullName = firstName + lastName;

        // Return the data as a map
        return fullName;
      } else {
        // Handle the case where no matching documents were found
        return "";
      }
    } catch (e) {
      // Handle any potential errors
      print('Error getting user name: $e');

      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hostName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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

                // Filter the messages based on senderId and receiverId
                var messages = snapshot.data!.docs.where((message) =>
                    (message['senderId'] == widget.hostId &&
                        message['receiverId'] == widget.guestId) ||
                    (message['senderId'] == widget.guestId &&
                        message['receiverId'] == widget.hostId));

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages.elementAt(index);
                    return ListTile(
                      title: Text(message['text']),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String message = _messageController.text.trim();
                    if (message.isNotEmpty) {
                      _sendMessage(message);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

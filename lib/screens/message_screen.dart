// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:suroyapp/screens/chat_screen.dart';
// import 'package:suroyapp/screens/specific_conversations.dart';

// class MessageScreen extends StatefulWidget {
//   const MessageScreen({Key? key}) : super(key: key);

//   @override
//   _MessageScreenState createState() => _MessageScreenState();
// }

// class _MessageScreenState extends State<MessageScreen> {
//   late Stream<QuerySnapshot> _conversationsStream;

//   @override
//   void initState() {
//     super.initState();
//     String currentUserId = FirebaseAuth.instance.currentUser!.uid;
//     _conversationsStream = FirebaseFirestore.instance
//         .collection('conversations')
//         .where('participants', arrayContains: currentUserId)
//         .snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Messages"),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _conversationsStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No conversations yet.'));
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               var conversation = snapshot.data!.docs[index];
//               // Extract necessary data from the conversation document
//               String hostName = conversation['hostName'];
//               String hostId = conversation['hostId'];

//               return ListTile(
//                 title: Text(hostName),
//                 subtitle: Text(''), // Display the last message if available
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ChatScreen(
//                         hostId: hostId,
//                         guestId: FirebaseAuth.instance.currentUser!.uid,
//                         hostName: hostName,
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

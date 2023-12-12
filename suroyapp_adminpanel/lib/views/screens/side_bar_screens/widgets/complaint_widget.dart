import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ComplaintWidget extends StatelessWidget {
  const ComplaintWidget({super.key});

  Future<bool> sendEmail({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    final serviceId = 'service_lxd0fho';
    final templateId = 'template_0karlmi';
    final publicKey = 'aT5HwscannMsEo7mI'; // Your public key
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'origin': 'http://localhost' // or your domain if deployed
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': publicKey,
          'template_params': {
            'user_name': name,
            'user_email': email,
            'user_subject': subject,
            'user_message': message,
          },
        }),
      );

      if (response.statusCode == 200) {
        print("Email sent successfully");
        return true;
      } else {
        print(
            "Failed to send email. Status code: ${response.statusCode}. Response body: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error sending email: $e");
      return false;
    }
  }

  Widget complaintData(int? flex, Widget widget) {
    return Expanded(
      flex: flex!,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          height: 50,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: widget,
          ),
        ),
      ),
    );
  }

  void showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 700,
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
        );
      },
    );
  }

  Widget complaintStatus(String status) {
    Color statusColor;
    switch (status) {
      case 'Filed':
        statusColor = Colors.orange;
        break;
      case 'Pending':
        statusColor = Colors.blue;
        break;
      case 'Resolved':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Text(
      status,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: statusColor,
      ),
    );
  }

  void showEmailFormDialog(BuildContext context, String recipientEmail) {
    final nameController = TextEditingController();
    final emailController =
        TextEditingController(text: recipientEmail); // Pre-filled
    final subjectController = TextEditingController();
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16),
            constraints: BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Send Feedback',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)), // Title
                SizedBox(height: 10),
                buildInputField(label: 'Name', controller: nameController),
                SizedBox(height: 10),
                buildInputField(
                    label: 'To',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress),
                SizedBox(height: 10),
                buildInputField(
                    label: 'Subject', controller: subjectController),
                SizedBox(height: 10),
                buildInputField(
                    label: 'Message',
                    controller: messageController,
                    maxLines: 4),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    bool emailSent = await sendEmail(
                      name: nameController.text,
                      email: emailController.text,
                      subject: subjectController.text,
                      message: messageController.text,
                    );
                    Navigator.pop(context); // Close the dialog
                    if (emailSent) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Email sent successfully!'),
                          duration: Duration(seconds: 4),
                        ),
                      );
                    }
                  },
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildInputField(
      {required String label,
      int maxLines = 1,
      TextInputType? keyboardType,
      required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        border: OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _complaintsStream =
        FirebaseFirestore.instance.collection('complaints').snapshots();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: _complaintsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final complaintDoc = snapshot.data!.docs[index];
              final docId = complaintDoc.id; // Accessing document ID here

              return Card(
                  margin: EdgeInsets.only(top: 8),
                  color: Colors.blue.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        2.0), // Small radius for edge-like corners
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        complaintData(
                          1,
                          GestureDetector(
                            onTap: () => showImageDialog(
                                context, complaintDoc['imageUrl']),
                            child: Container(
                              height: 30,
                              width: 30,
                              child: Image.network(complaintDoc['imageUrl']),
                            ),
                          ),
                        ),
                        complaintData(
                          1,
                          Text(
                            complaintDoc['complainantEmail'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        complaintData(
                          1,
                          Text(
                            complaintDoc['complaintCategory'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        complaintData(
                          2,
                          Text(
                            complaintDoc['description'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        complaintData(
                          1,
                          Text(
                            complaintDoc['hostEmail'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        complaintData(
                          1,
                          complaintStatus(complaintDoc['complaintStatus']),
                        ),
                        complaintData(
                          1,
                          ElevatedButton(
                            onPressed: () async {
                              String newStatus =
                                  complaintDoc['complaintStatus'] == 'Filed' ||
                                          complaintDoc['complaintStatus'] ==
                                              'Resolved'
                                      ? 'Pending'
                                      : 'Resolved';
                              if (newStatus == 'Pending') {
                                showEmailFormDialog(
                                    context, complaintDoc['complainantEmail']);
                              }
                              await FirebaseFirestore.instance
                                  .collection('complaints')
                                  .doc(docId)
                                  .update({'complaintStatus': newStatus});
                            },
                            child: Text(
                                complaintDoc['complaintStatus'] == 'Filed' ||
                                        complaintDoc['complaintStatus'] ==
                                            'Resolved'
                                    ? 'Pending'
                                    : 'Resolved'),
                          ),
                        ),
                      ],
                    ),
                  ));
            });
      },
    );
  }
}

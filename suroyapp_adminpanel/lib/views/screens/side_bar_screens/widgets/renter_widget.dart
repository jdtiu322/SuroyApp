import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class RenterWidget extends StatelessWidget {
  const RenterWidget({super.key});

  Future sendEmail({
    required BuildContext context,
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
          'user_id': publicKey, // Adding the public key here
          'template_params': {
            'user_name': name,
            'user_email': email,
            'user_subject': subject,
            'user_message': message,
          },
        }),
      );

      if (response.statusCode == 200) {
        print("Email sent successfully!");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email sent successfully!'),
            duration: Duration(seconds: 4),
          ),
        );
      } else {
        print(
            "Failed to send email. Status code: ${response.statusCode}. Response body: ${response.body}");
      }
    } catch (e) {
      print("Error sending email: $e");
    }
  }

  Widget renterData(int? flex, Widget widget) {
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

  Future<void> removeUserData(String documentId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(documentId)
        .delete();
  }

  Color getStatusColor(bool? approved) {
  // When approved is null or false, show grey color for Pending status
  return approved == true ? Colors.green : Colors.grey; 
}

String getStatusText(bool? approved) {
  // When approved is null or false, show "Pending"
  return approved == true ? "Approved" : "-";
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

  Future<void> showEmailFormDialog(BuildContext context,
      Map<String, dynamic> renterData, String action) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController subjectController = TextEditingController();
    TextEditingController messageController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Send Email - $action'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                buildInputField(label: 'Name', controller: nameController),
                SizedBox(height: 10),
                buildInputField(
                    label: 'Email',
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
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Send'),
              onPressed: () async {
                // Call sendEmail with the text from the controllers
                await sendEmail(
                  context: context,
                  name: nameController.text,
                  email: emailController.text,
                  subject: subjectController.text,
                  message: messageController.text,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
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
    final Stream<QuerySnapshot> _rentersStream =
        FirebaseFirestore.instance.collection('users').snapshots();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: _rentersStream,
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
            final DocumentSnapshot renterUserdata = snapshot.data!.docs[index];
            final String docId =
                renterUserdata.id; // Accessing document ID here

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
                      renterData(
                        2,
                        Text(
                          renterUserdata['firstName'] +
                              " " +
                              renterUserdata['lastName'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      renterData(
                        1,
                        Text(
                          renterUserdata['age'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      renterData(
                        2,
                        Text(
                          renterUserdata['email'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      renterData(
                        1,
                        Text(
                          renterUserdata['driverLicense'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      renterData(
                        1,
                        GestureDetector(
                          onTap: () => showImageDialog(
                              context, renterUserdata['licenseImageUrl']),
                          child: Container(
                            height: 30,
                            width: 30,
                            child: Image.network(
                                renterUserdata['licenseImageUrl']),
                          ),
                        ),
                      ),
                      renterData(
                        1,
                        Text(
                          getStatusText(renterUserdata['approved']),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: getStatusColor(renterUserdata['approved']),
                          ),
                        ),
                      ),
                      renterData(
                        1,
                        PopupMenuButton<String>(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'View More',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Icon(
                                Icons
                                    .arrow_drop_down, // Regular arrow down icon
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                          onSelected: (String value) async {
                            switch (value) {
                              case 'Approve/Reject':
                                bool isApproved =
                                    renterUserdata['approved'] == true;
                                String newStatus =
                                    isApproved ? 'Rejected' : 'Approved';
                                await showEmailFormDialog(
                                    context,
                                    renterUserdata.data()
                                        as Map<String, dynamic>,
                                    newStatus);
                                await _firestore
                                    .collection('users')
                                    .doc(docId)
                                    .update({'approved': !isApproved});
                                break;
                              case 'Remove':
                                removeUserData(renterUserdata.id);
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'Approve/Reject',
                              child: Text(renterUserdata['approved'] == false
                                  ? 'Approve'
                                  : 'Reject'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Remove',
                              child: Text('Remove'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ));
          },
        );
      },
    );
  }
}

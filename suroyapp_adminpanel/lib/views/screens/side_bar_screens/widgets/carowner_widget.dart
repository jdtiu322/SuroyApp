import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class CarownerWidget extends StatelessWidget {
  const CarownerWidget({super.key});

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

  Widget carownerData(int? flex, Widget widget) {
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

  LatLng convertStringToLatLng(String latLngString) {
    String cleanedString =
        latLngString.replaceAll('LatLng(', '').replaceAll(')', '');
    List<String> latLngParts = cleanedString.split(',');

    if (latLngParts.length == 2) {
      double latitude = double.parse(latLngParts[0].trim());
      double longitude = double.parse(latLngParts[1].trim());

      return LatLng(latitude, longitude);
    } else {
      throw FormatException('Invalid LatLng string format');
    }
  }

  Future<String> getAddressFrom(LatLng location) async {
    GeoData data = await Geocoder2.getDataFromCoordinates(
      latitude: location.latitude,
      longitude: location.longitude,
      googleMapApiKey: "AIzaSyANSqv9C0InmgUe-druqtq_qfD1rKPRZHc",
    );
    if (data != null) {
      return data.address;
    } else {
      return "No address found";
    }
  }

  Future<String> getDisplayAddress(String coordinates) async {
    LatLng latLngAddress = convertStringToLatLng(coordinates);
    String address = await getAddressFrom(latLngAddress);

    return address;
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

  Widget carownerStatus(String bookingStatus) {
    Color statusColor;
    switch (bookingStatus) {
      case 'Available':
        statusColor = Colors.green;
        break;
      case 'Booked':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey; // Default color for undefined status
    }

    return Text(
      bookingStatus,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: statusColor,
      ),
    );
  }

  Future<void> showEmailFormDialog(BuildContext context,
      Map<String, dynamic> carownerData, String action) async {
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

  void showDocumentsDialog(BuildContext context, String vehicleImageUrl,
      String certificateImageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Vehicle Image",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey)),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(vehicleImageUrl, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: 20),
                Text("Certificate Image",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey)),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child:
                        Image.network(certificateImageUrl, fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget vehicleStatus(bool? isAvailable) {
    Color statusColor;
    String statusText;

    if (isAvailable == null) {
      statusColor = Colors.grey;
      statusText = "-";
    } else if (isAvailable) {
      statusColor = Colors.green;
      statusText = "Approved";
    } else {
      statusColor = Colors.grey;
      statusText = "-";
    }

    return Text(
      statusText,
      style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _carownersStream =
        FirebaseFirestore.instance.collection('vehicleListings').snapshots();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: _carownersStream,
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
              final carownerUserdata = snapshot.data!.docs[index];
              final docId = carownerUserdata.id; // Accessing document ID here

              return FutureBuilder<String>(
                future: getDisplayAddress(carownerUserdata['renterAddress']),
                builder: (context, addressSnapshot) {
                  if (addressSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Text("Loading address...");
                  }

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
                            carownerData(
                              1,
                              Text(
                                carownerUserdata['email'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            carownerData(
                              1,
                              Text(
                                carownerUserdata['vehicleModel'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            carownerData(
                              1,
                              Text(
                                carownerUserdata['vehicleType'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            carownerData(
                              2,
                              Text(
                                addressSnapshot.data ??
                                    'Unknown Address', // Display the converted address
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            carownerData(
                              1,
                              Text(
                                carownerUserdata['licensePlateNum'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            carownerData(
                              1,
                              carownerStatus(carownerUserdata['bookingStatus']),
                            ),
                            carownerData(
                              1,
                              vehicleStatus(carownerUserdata['isAvailable']),
                            ),
                            carownerData(
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
                                    Icon(Icons.arrow_drop_down,
                                        color: Theme.of(context).primaryColor),
                                  ],
                                ),
                                onSelected: (String value) async {
                                  if (value == 'Approve/Reject') {
                                    bool isAvailable =
                                        carownerUserdata['isAvailable'] != true;
                                    await _firestore
                                        .collection('vehicleListings')
                                        .doc(docId)
                                        .update({'isAvailable': isAvailable});
                                  } else if (value == 'Remove') {
                                    await _firestore
                                        .collection('vehicleListings')
                                        .doc(docId)
                                        .delete();
                                  } else if (value == 'Documents') {
                                    String vehicleImageUrl =
                                        carownerUserdata['vehicleImage'];
                                    String certificateImageUrl =
                                        carownerUserdata['certificateImage'];
                                    showDocumentsDialog(context,
                                        vehicleImageUrl, certificateImageUrl);
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'Approve/Reject',
                                    child: Text(
                                        carownerUserdata['isAvailable'] != true
                                            ? 'Approve'
                                            : 'Reject'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'Remove',
                                    child: Text('Remove'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'Documents',
                                    child: Text('Documents'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                },
              );
            });
      },
    );
  }
}

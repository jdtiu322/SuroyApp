import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:suroyapp/reusable_widgets/reusable_widgets.dart';
import 'package:suroyapp/reusable_widgets/user_image.dart';
import 'package:suroyapp/models/vehicle_info.dart';
import 'package:suroyapp/screens/status_screen.dart';

class ComplaintsScreen extends StatefulWidget {
  final RenterStatus complaintDetails;
  const ComplaintsScreen({Key? key, required this.complaintDetails})
      : super(key: key);

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  String startMonth = "";
  String endMonth = "";
  bool? _changedPlans = false;
  bool? _betterDeal = false;
  bool? _unforeseen = false;
  bool? _flight = false;
  bool? _other = false;
  bool _isFree = false;
  bool _isNotFree = false;
  int dateDifference = 0;
  TextEditingController description = TextEditingController();
  String inputText = "";
  String imageUrl = "";
  String complaintCategory = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Submit a complaint",
          style: GoogleFonts.roboto(fontSize: 16),
        ),
      ),
      body: ListView(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Container(
            child: Column(children: [
              Container(
                height: 80,
                color: Colors.grey.shade400,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Text(
                        "",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Tell us your complaint regarding your vehicle rental or overall experience.",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "You can submit a complaint until 48hrs after vehicle rental has ended",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "What best describes your complaint?",
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 5,
                      ),
                      CheckboxListTile(
                        title: Text("1. Inaccurate listing details"),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _changedPlans,
                        onChanged: (bool? value) {
                          setState(() {
                            _changedPlans = value;
                            _betterDeal = false;
                            _unforeseen = false;
                            _flight = false;
                            _other = false;

                            complaintCategory = "Inaccurate listing details";
                          });
                        },
                      ),
                      Divider(
                        height: 5,
                      ),
                      CheckboxListTile(
                        title: Text("2. Unpleasant driving experience"),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _betterDeal,
                        onChanged: (bool? value) {
                          setState(() {
                            _betterDeal = value;
                            _changedPlans = false;
                            _unforeseen = false;
                            _flight = false;
                            _other = false;

                            complaintCategory = "Unpleasant driving experience";
                          });
                        },
                      ),
                      Divider(
                        height: 5,
                      ),
                      CheckboxListTile(
                        title: Text("3. Vehicle was never acquired"),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _unforeseen,
                        onChanged: (bool? value) {
                          setState(() {
                            _unforeseen = value;
                            _changedPlans = false;
                            _betterDeal = false;
                            _flight = false;
                            _other = false;
                            complaintCategory = "Vehicle was never acquired";
                          });
                        },
                      ),
                      Divider(
                        height: 5,
                      ),
                      CheckboxListTile(
                        title: Text("4. Host was late"),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _flight,
                        onChanged: (bool? value) {
                          setState(() {
                            _flight = value;
                            _changedPlans = false;
                            _betterDeal = false;
                            _unforeseen = false;
                            _other = false;

                            complaintCategory = "Host was late";
                          });
                        },
                      ),
                      Divider(
                        height: 5,
                      ),
                      CheckboxListTile(
                        title: Text("5. Others"),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _other,
                        onChanged: (bool? value) {
                          setState(() {
                            _other = value;
                            _changedPlans = false;
                            _betterDeal = false;
                            _unforeseen = false;
                            _flight = false;

                            complaintCategory = "Others";
                          });
                        },
                      ),
                      Divider(
                        height: 5,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: description,
                        maxLines: 2, // Adjust the number of lines as needed
                        maxLength: 200, // Set the maximum number of words
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 20.0)),
                          labelText: 'Description',
                        ),
                        style: GoogleFonts.poppins(fontSize: 14),
                        onChanged: (value) {
                          setState(() {
                            inputText = value;
                          });
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Upload photos to support your claim!",
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.grey.shade400),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      UserImage(onFileChanged: ((imageUrl) {
                        setState(() {
                          this.imageUrl = imageUrl;
                        });
                      })),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Color(0xfff004aad),
                          ),
                        ),
                        onPressed: () async {
                          User? user = FirebaseAuth.instance.currentUser;
                          String complainantID = user!.uid;

                          // Add your complaint to Firestore
                          await FirebaseFirestore.instance
                              .collection('complaints')
                              .add({
                            'complainantID': complainantID,
                            'complainantEmail': user.email,
                            'hostName': widget.complaintDetails.hostName,
                            'hostEmail': widget.complaintDetails.email,
                            'complaintCategory': complaintCategory,
                            'description': description.text,
                            'vehicleModel': widget.complaintDetails.vehicleModel,
                            'plateNumber': widget.complaintDetails.vehicleModel,
                                 // Use description.text instead of description
                            'imageUrl': imageUrl,
                            'complaintStatus': "Filed"
                          });

                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Complaint Submitted',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/success_image.png',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(height: 5), // Adjusted height
                                    Text(
                                      'Your complaint has been submitted successfully.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'OK',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor: Colors.white,
                                elevation: 5,
                              );
                            },
                          );

                          Future.delayed(Duration(seconds: 3), () {
                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          "Submit complaint",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

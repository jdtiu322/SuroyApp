import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Complaints extends StatefulWidget {
  const Complaints({super.key});

  @override
  State<Complaints> createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
  String startMonth = "";
  User? user = FirebaseAuth.instance.currentUser;
  late String userID;
  late Stream<QuerySnapshot> _userStream;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      userID = user!.uid;
      _userStream = FirebaseFirestore.instance
          .collection('complaints')
          .where('complainantID', isEqualTo: userID)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Complaints Overview",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
        ),
      )),
      body: StreamBuilder(
        stream: _userStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Connection error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Waiting for conenection');
          }
          var docs = snapshot.data!.docs;
          // return Text('${docs.length}');
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                Colors.white.withOpacity(.7), // Container color
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.2), // Shadow color
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          height: 180,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          "Complaint Description",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: Text(
                                          docs[index]['description'],
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  context); // Close the dialog
                                            },
                                            child: Text(
                                              'Close',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                    child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            docs[index]['complaintCategory'],
                                            style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            docs[index]['vehicleModel'],
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          Text(
                                            docs[index]['plateNumber'],
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          Text(
                                            "Listed by: " +
                                                docs[index]['hostName'],
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: 'Complaint Status: ',
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: Colors
                                                    .black, // Adjust the color as needed
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: docs[index]
                                                      ['complaintStatus'],
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors
                                                        .black, // Adjust the color as needed
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                              )
                            ],
                          )),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

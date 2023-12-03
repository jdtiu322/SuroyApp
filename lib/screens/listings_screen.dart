import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suroyapp/reusable_widgets/vehicle_info.dart';
import 'package:suroyapp/screens/listing_details.dart';

class Listings extends StatefulWidget {
  const Listings({super.key});

  @override
  State<Listings> createState() => _ListingsState();
}

class _ListingsState extends State<Listings> {
  String userID = "";
  late Stream<QuerySnapshot<Map<String, dynamic>>> _userStream;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    User? user = await FirebaseAuth.instance.currentUser;
    setState(() {
      userID = user!.uid;
    });
    _userStream = FirebaseFirestore.instance
        .collection("vehicleListings")
        .where('hostID', isEqualTo: userID)
        .snapshots();
  }

  Future<void> initializeData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Listings"),
      ),
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
          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    BookingInfo listingInfo = BookingInfo(
                        startDate: DateTime.now(),
                        endDate: DateTime.now(),
                        hostName: docs[index]['hostName'],
                        pickUpAddress: docs[index]['renterAddress'],
                        plateNumber: docs[index]['licensePlateNum'],
                        transactionAmount: "0",
                        vehicleModel: docs[index]['vehicleModel'],
                        vehicleType: docs[index]['vehicleType'],
                        modelYear: docs[index]['modelYear'],
                        imageUrl: docs[index]['vehicleImage'],
                        hostAge: docs[index]['hostAge'],
                        hostMobileNumber: docs[index]['hostMobileNumber'],
                        email: docs[index]['email']);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ListingDetails(listingInfo: listingInfo)));
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFBAD6EB),
                          borderRadius: BorderRadius.circular(10.0)),
                      height: 100,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      docs[index]['vehicleImage'],
                                      width: 100,
                                    )),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  docs[index]['vehicleModel'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}

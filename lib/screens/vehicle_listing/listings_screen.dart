import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suroyapp/models/vehicle_info.dart';
import 'package:suroyapp/screens/vehicle_listing/listing_details.dart';

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
        .where('hostId', isEqualTo: userID,)
        .where('isAvailable', isEqualTo: true)
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
            return Text('Waiting for connection');
          }
          var docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      FinalVehicleInfo listingInfo = FinalVehicleInfo(
                        isAvailable: docs[index]['isAvailable'],
                        rentPrice: docs[index]['pricing'],
                        bookingStatus: docs[index]['bookingStatus'],
                        vehicleDescription: docs[index]['description'],
                        pickUpAddress: docs[index]['renterAddress'],
                        vehicleType: docs[index]['vehicleType'],
                        vehicleModel: docs[index]['vehicleModel'],
                        hostName: docs[index]['hostName'],
                        numSeats: docs[index]['numSeats'],
                        modelYear: docs[index]['modelYear'],
                        plateNumber: docs[index]['licensePlateNum'],
                        vehicleImageUrl: docs[index]['vehicleImage'],
                        certificateImageUrl: "",
                        hostAge: docs[index]['hostAge'],
                        hostMobileNumber: docs[index]['hostMobileNumber'],
                        email: docs[index]['email'],
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListingDetails(listingInfo: listingInfo),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    docs[index]['vehicleImage'],
                                    width: 100,
                                    fit: BoxFit.cover, // Ensures the image covers the entire space
                                  ),
                                ),
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
                          Divider(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

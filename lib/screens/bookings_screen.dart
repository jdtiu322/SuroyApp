import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:suroyapp/models/vehicle_info.dart';
import 'package:suroyapp/screens/booking_details.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({Key? key}) : super(key: key);

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
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
          .collection('bookings')
          .where('renterID', isEqualTo: userID)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookings"),
      ),
      body: StreamBuilder(
        stream: _userStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Connection error'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Waiting for connection'));
          }
          var docs = snapshot.data!.docs;

          if (docs.length == 0) {
            return Center(child: Text("No bookings yet huhu, choose ka na po, sana mapili :(("));
          }else {
            return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              DateTime startDate = docs[index]['startDate'].toDate();
              DateTime endDate = docs[index]['endDate'].toDate();
              startMonth = DateFormat("MMM").format(startDate);
              var imageUrl = docs[index]['imageUrl'];
              return GestureDetector(
                onTap: () {
                  BookingInfo bookingDetails = BookingInfo(
                    startDate: startDate,
                    endDate: endDate,
                    hostName: docs[index]['hostName'],
                    pickUpAddress: docs[index]['pickUpAddress'],
                    plateNumber: docs[index]['plateNumber'],
                    transactionAmount: docs[index]['transactionAmount'],
                    vehicleModel: docs[index]['vehicleModel'],
                    vehicleType: docs[index]['vehicleType'],
                    modelYear: docs[index]['modelYear'],
                    imageUrl: docs[index]['imageUrl'],
                    hostAge: docs[index]['hostAge'],
                    hostMobileNumber: docs[index]['hostMobileNumber'],
                    email: docs[index]['email'],
                    isNotPickedUp: docs[index]['isNotPickedUp'],
                    isPickedUp: docs[index]['isPickedUp']
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingDetailsScreen(
                        bookingDetails: bookingDetails,
                      ),
                    ),
                  );
                },
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
                              color:
                                  Colors.black.withOpacity(0.2), // Shadow color
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                imageUrl,
                                width: 150,
                                height: 100,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 17),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(docs[index]['vehicleModel'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                      )),
                                  Text(
                                    "Pick-Up on " +
                                        startMonth +
                                        " " +
                                        startDate.day.toString(),
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            },
          );
          }
        },
      ),
    );
  }
}

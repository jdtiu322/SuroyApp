import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suroyapp/screens/vehicle_listing/posting_details.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  late String userID;
  late Stream<QuerySnapshot> _userStream;
  List<bool> isHeartFilledList = [];

  @override
  void initState() {
    super.initState();
    if (user != null) {
      userID = user!.uid;
      _userStream = FirebaseFirestore.instance
          .collection('wishlist')
          .where('wishlistID', isEqualTo: user!.uid)
          .snapshots();
    }
  }
                     
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Wishlists")),
      body: StreamBuilder(
        stream: _userStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Connection error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          var docs = snapshot.data?.docs;

          if (docs == null) {
            return Text('No wishlist data available');
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var imageUrl = docs[index]['vehicleImageUrl'];

              while (isHeartFilledList.length <= index) {
                isHeartFilledList.add(false);
              }

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostingDetails(
                        vehicleModel: docs[index]['vehicleModel'], //
                        modelYear: docs[index]['modelYear'], // 
                        hostName: docs[index]['hostName'], //
                        rentPrice: docs[index]['rentPrice'], // 
                        description: docs[index]['description'], //
                        vImageURL: docs[index]['vehicleImageUrl'], //
                        vehicleType: docs[index]['vehicleType'], //
                        plateNum: docs[index]['licensePlateNum'], //
                        numOfSeats: docs[index]['numOfSeats'],
                        vehicleAddress: docs[index]['vehicleAddress'],
                        hostAge: docs[index]['hostAge'],
                        hostMobileNumber: docs[index]['hostMobileNumber'],
                        email: docs[index]['email'],
                        hostId: docs[index]['hostId'],
                        bookingStatus: docs[index]['bookingStatus'],
                        vehicleImageUrl: docs[index]['vehicleImageUrl'],
                        certificateImageUrl: "placeholder",
                      ),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                imageUrl,
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          docs[index]['vehicleModel'],
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          docs[index]['modelYear'],
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          "PHP" + docs[index]['rentPrice'],
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
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

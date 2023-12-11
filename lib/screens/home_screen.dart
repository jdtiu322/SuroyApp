import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:suroyapp/screens/vehicle_listing/posting_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  late String userID;
  late Stream<QuerySnapshot> _userStream;
  List<bool> isHeartFilledList = [];
  late List<DocumentSnapshot> docs;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      userID = user!.uid;
      _userStream = FirebaseFirestore.instance
          .collection('vehicleListings')
          .where('hostId',
              isNotEqualTo: userID) // Exclude listings by the current user
          .where('isAvailable', isEqualTo: true)
          .snapshots();

      // Check if items are in the wishlist and update isHeartFilledList
      checkWishlist();
    }
  }

  Future<void> checkWishlist() async {
    userID = user!.uid;
    try {
      // Refresh the stream to get the latest data
      _userStream = FirebaseFirestore.instance
          .collection('vehicleListings')
          .where('isAvailable', isEqualTo: true)
          .snapshots();

      QuerySnapshot wishlistSnapshot = await FirebaseFirestore.instance
          .collection('wishlist')
          .where('wishlistID', isEqualTo: user!.uid)
          .get();

      List<String> wishlistItems = wishlistSnapshot.docs
          .map((QueryDocumentSnapshot document) =>
              document['vehicleModel'] as String)
          .toList();

      setState(() {
        isHeartFilledList = List.generate(
          docs.length,
          (index) => wishlistItems.contains(docs[index]['vehicleModel']),
        );
      });
    } catch (e) {
      print('Error checking wishlist: $e');
    }
  }

  Future<void> updateWishlistPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        'wishlistItems',
        isHeartFilledList
            .asMap()
            .entries
            .where((entry) => entry.value)
            .map((entry) => docs[entry.key]['vehicleModel'] as String)
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: _userStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Connection error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Waiting for connection');
          }

          docs = snapshot.data!.docs; // Fix: Added assignment to docs variable

          return WillPopScope(
            onWillPop: () async {
              // Call checkWishlist when navigating back to HomeScreen
              await checkWishlist();
              return true;
            },
            child: ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                var imageUrl = docs[index]['vehicleImage'];

                // Ensure the isHeartFilledList has enough elements
                while (isHeartFilledList.length <= index) {
                  isHeartFilledList.add(false);
                }

                return GestureDetector(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostingDetails(
                          vehicleModel: docs[index]['vehicleModel'],
                          modelYear: docs[index]['modelYear'],
                          hostName: docs[index]['hostName'],
                          rentPrice: docs[index]['pricing'],
                          description: docs[index]['description'],
                          vImageURL: docs[index]['vehicleImage'],
                          vehicleType: docs[index]['vehicleType'],
                          plateNum: docs[index]['licensePlateNum'],
                          numOfSeats: docs[index]['numSeats'],
                          vehicleAddress: docs[index]['renterAddress'],
                          hostAge: docs[index]['hostAge'],
                          hostMobileNumber: docs[index]['hostMobileNumber'],
                          email: docs[index]['email'],
                          hostId: docs[index]['hostId'],
                          bookingStatus: docs[index]['bookingStatus'],
                          vehicleImageUrl: docs[index]['vehicleImage'],
                          certificateImageUrl: docs[index]['certificateImage'],
                        ),
                      ),
                    ).then((_) async {
                      // Call checkWishlist when returning from PostingDetails
                      await checkWishlist();
                    });
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
                              Positioned(
                                top: 16,
                                right: 16,
                                child: GestureDetector(
                                  onTap: () async {
                                    if (!isHeartFilledList[index]) {
                                      User? user =
                                          FirebaseAuth.instance.currentUser;

                                      if (user != null) {
                                        try {
                                          await FirebaseFirestore.instance
                                              .collection('wishlist')
                                              .add({
                                            'wishlistID': user.uid,
                                            'vehicleModel': docs[index]
                                                ['vehicleModel'],
                                            'modelYear': docs[index]
                                                ['modelYear'],
                                            'hostName': docs[index]['hostName'],
                                            'rentPrice': docs[index]['pricing'],
                                            'description': docs[index]
                                                ['description'],
                                            'vehicleImageUrl': docs[index]
                                                ['vehicleImage'],
                                            'vehicleType': docs[index]
                                                ['vehicleType'],
                                            'licenseP{lateNum': docs[index]
                                                ['licensePlateNum'],
                                            'numOfSeats': docs[index]
                                                ['numSeats'],
                                            'vehicleAddress': docs[index]
                                                ['renterAddress'],
                                            'hostAge': docs[index]['hostAge'],
                                            'hostMobileNumber': docs[index]
                                                ['hostMobileNumber'],
                                            'email': docs[index]['email'],
                                            'hostId': docs[index]['hostId'],
                                            'bookingStatus': docs[index]
                                                ['bookingStatus'],
                                            ' vehicleImageUrl': docs[index]
                                                ['vehicleImage'],
                                          });
                                        } catch (e) {
                                          print('Error adding to wishlist: $e');
                                        }
                                      } else {
                                        print("User not signed in!");
                                      }
                                    } else {
                                      if (user != null) {
                                        try {
                                          User? user =
                                              FirebaseAuth.instance.currentUser;

                                          CollectionReference wishlist =
                                              FirebaseFirestore.instance
                                                  .collection('wishlist');

                                          QuerySnapshot gwapoKo = await wishlist
                                              .where('wishlistID',
                                                  isEqualTo: user!.uid)
                                              .get();

                                          DocumentSnapshot cuteKo =
                                              gwapoKo.docs.first;

                                          await wishlist
                                              .doc(cuteKo.id)
                                              .delete();
                                        } catch (e) {
                                          print("Error detected: $e");
                                        }
                                      } else {
                                        print("User does not exist!");
                                      }
                                    }

                                    setState(() {
                                      isHeartFilledList[index] =
                                          !isHeartFilledList[index];
                                    });

                                    // Update shared preferences
                                    await updateWishlistPreferences();
                                  },
                                  child: Icon(
                                    isHeartFilledList[index]
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isHeartFilledList[index]
                                        ? Colors.red
                                        : Colors.white,
                                    size: 32,
                                  ),
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
                            "PHP" + docs[index]['pricing'],
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600),
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
            ),
          );
        },
      ),
    );
  }
}

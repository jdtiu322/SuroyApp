import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suroyapp/screens/posting_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  late String userID;
  late Stream<QuerySnapshot> _userStream;
  bool isHeartFilled = false;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      userID = user!.uid;
      _userStream = FirebaseFirestore.instance
          .collection('vehicleListings')
          .where('isAvailable', isEqualTo: true)
          .snapshots();
    }
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
            return Text('Waiting for conenection');
          }
          var docs = snapshot.data!.docs;
          // return Text('${docs.length}');
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var imageUrl = docs[index]['vehicleImage'];
              return GestureDetector(
                onTap: () {
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
                                hostMobileNumber: docs[index]
                                    ['hostMobileNumber'],
                                email: docs[index]['email'],
                                hostId: docs[index]['hostId'],
                                bookingStatus: docs[index]['bookingStatus'],
                                vehicleImageUrl: docs[index]['vehicleImage'],
                                certificateImageUrl: docs[index]
                                    ['certificateImage'],
                              )));
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
                                onTap: () {
                                  setState(() {
                                    isHeartFilled = !isHeartFilled;
                                  });
                                },
                                child: Icon(
                                  isHeartFilled
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color:
                                      isHeartFilled ? Colors.red : Colors.white,
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

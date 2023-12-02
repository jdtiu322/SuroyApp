import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suroyapp/screens/posting_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _userStream =
      FirebaseFirestore.instance.collection('vehicleListings').snapshots();

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
                                hostMobileNumber: docs[index]['hostMobileNumber'],
                                email: docs[index]['email'],
                                
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(imageUrl,
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fitWidth),
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

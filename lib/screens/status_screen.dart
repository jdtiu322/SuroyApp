import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suroyapp/reusable_widgets/vehicle_info.dart';
import 'package:suroyapp/screens/home_screen.dart';
import 'package:suroyapp/screens/starting_page.dart';

class StatusScreen extends StatefulWidget {
  final RenterStatus renterStatus;
  const StatusScreen({Key? key, required this.renterStatus}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  TextEditingController reviewController = TextEditingController();
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.renterStatus.imageUrl,
                height: 220,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0, 20, 0),
                child: Column(
                  children: [
                    Text(
                      widget.renterStatus.vehicleModel,
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      "Picked-up at Address",
                      style: GoogleFonts.poppins(
                          fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Host Name: ",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: widget.renterStatus.hostName,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Mobile Number: ",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: widget.renterStatus.hostMobileNumber,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Email address: ",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: widget.renterStatus.email,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: SvgPicture.asset(
                            'assets/vectors/in-progress.svg',
                            width: 100)),
                    Center(
                        child: Text(
                      "Booking is in-progress...",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                      ),
                    )),
                    Divider(),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/suroy-logo.png',
                          width: 40,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Have any problems?",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Report an issue right now",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 80,
                        ),
                        GestureDetector(
                            onTap: () {},
                            child: SvgPicture.asset('assets/vectors/report.svg',
                                width: 34))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    Center(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                            Color(0xfff004aad),
                          )),
                          onPressed: () {
                            _showReviewDialog();
                          },
                          child: Text(
                            "Finish booking",
                            style: GoogleFonts.poppins(color: Colors.white),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReviewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Rate the Host"),
          content: Column(
            children: [
              Text("Select a star rating:"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        rating = index + 1;
                      });
                    },
                    child: Icon(
                      Icons.star,
                      size: 40,
                      color: index < rating ? Colors.grey: Colors.yellow ,
                    ),
                  );
                }),
              ),
              TextField(
                controller: reviewController,
                decoration: InputDecoration(labelText: "Write a review"),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _submitRating();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StartingPage()));
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  void _submitRating() async {
    // Firebase Collection Reference
    CollectionReference ratings =
        FirebaseFirestore.instance.collection('ratings');

    // Creating a new document with auto-generated ID
    await ratings.add({
      'renterID': widget.renterStatus.renterID,
      'ratings': rating,
      'hostEmail': widget.renterStatus.email,
      'review': reviewController.text,
      'vehicleModel': widget.renterStatus.vehicleModel,
      'modelYear': widget.renterStatus.modelYear,
      'vehicleType': widget.renterStatus.vehicleType,
      'imageUrl': widget.renterStatus.imageUrl,
    });

    // Optionally, you can update UI or show a confirmation message
  }
}

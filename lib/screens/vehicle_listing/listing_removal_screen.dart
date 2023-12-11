import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suroyapp/screens/vehicle_listing/listings_screen.dart';

class ListingRemovalPage extends StatefulWidget {
  const ListingRemovalPage({super.key});

  @override
  State<ListingRemovalPage> createState() => _ListingRemovalPageState();
}

class _ListingRemovalPageState extends State<ListingRemovalPage> {
  bool? _sold = false;
  bool? _betterPlatform = false;
  bool? _serviceFeeTooHigh = false;
  bool? _securityConcerns = false;
  bool? _unforeseenCircumstances = false;
  bool? _other = false;
  bool _buttonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Remove my vehicle listing",
          style: GoogleFonts.roboto(fontSize: 16),
        ),
      ),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Container(
              child: Column(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Tell us your reason for removing your vehicle listing by choosing one of the options below.",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "You can completely remove a vehicle listing, or you can temporarily remove it. The latter option can be selected if the vehicle is unavailable for certain reasons. Vehicle Listings cannot be removed while it is booked.",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Why do you want to remove your listing?",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            height: 5,
                          ),
                          CheckboxListTile(
                            title: Text("1. Vehicle has been sold"),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _sold,
                            onChanged: (bool? value) {
                              setState(() {
                                _sold = value;
                                _betterPlatform = false;
                                _serviceFeeTooHigh = false;
                                _securityConcerns = false;
                                _unforeseenCircumstances = false;
                                _other = false;
                                _updateButtonState();
                              });
                            },
                          ),
                          Divider(
                            height: 5,
                          ),
                          CheckboxListTile(
                            title: Text("2. Better Platform Elsewhere"),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _betterPlatform,
                            onChanged: (bool? value) {
                              setState(() {
                                _betterPlatform = value;
                                _sold = false;
                                _serviceFeeTooHigh = false;
                                _securityConcerns = false;
                                _unforeseenCircumstances = false;
                                _other = false;
                                _updateButtonState();
                              });
                            },
                          ),
                          Divider(
                            height: 5,
                          ),
                          CheckboxListTile(
                            title: Text("3. Service fee too high"),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _serviceFeeTooHigh,
                            onChanged: (bool? value) {
                              setState(() {
                                _serviceFeeTooHigh = value;
                                _sold = false;
                                _betterPlatform = false;
                                _securityConcerns = false;
                                _unforeseenCircumstances = false;
                                _other = false;
                                _updateButtonState();
                              });
                            },
                          ),
                          Divider(
                            height: 5,
                          ),
                          CheckboxListTile(
                            title: Text("4. Security Concerns"),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _securityConcerns,
                            onChanged: (bool? value) {
                              setState(() {
                                _securityConcerns = value;
                                _sold = false;
                                _betterPlatform = false;
                                _serviceFeeTooHigh = false;
                                _unforeseenCircumstances = false;
                                _other = false;
                                _updateButtonState();
                              });
                            },
                          ),
                          Divider(
                            height: 5,
                          ),
                          CheckboxListTile(
                            title: Text("5. Unforeseen Circumstances"),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _unforeseenCircumstances,
                            onChanged: (bool? value) {
                              setState(() {
                                _unforeseenCircumstances = value;
                                _sold = false;
                                _betterPlatform = false;
                                _serviceFeeTooHigh = false;
                                _securityConcerns = false;
                                _other = false;
                                _updateButtonState();
                              });
                            },
                          ),
                          Divider(
                            height: 5,
                          ),
                          CheckboxListTile(
                            title: Text("6. Others"),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _other,
                            onChanged: (bool? value) {
                              setState(() {
                                _other = value;
                                _sold = false;
                                _betterPlatform = false;
                                _serviceFeeTooHigh = false;
                                _securityConcerns = false;
                                _unforeseenCircumstances = false;
                                _updateButtonState();
                              });
                            },
                          ),
                          Divider(
                            height: 5,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                _buttonEnabled
                                    ? Color(0xfff004aad)
                                    : Colors.grey,
                              ),
                            ),
                            onPressed: _buttonEnabled
                                ? () async {
                                    try {
                                      User? user =
                                          FirebaseAuth.instance.currentUser;
                                      String hostID = "";
                                      if (user != null) {
                                        hostID = user.uid;

                                        CollectionReference vehicleListings =
                                            FirebaseFirestore.instance
                                                .collection('vehicleListings');

                                        QuerySnapshot chuGwapo =
                                            await vehicleListings
                                                .where('hostId',
                                                    isEqualTo: hostID)
                                                .get();

                                        DocumentSnapshot chuCutie =
                                            chuGwapo.docs.first;

                                        String copyHostID = chuCutie.id;

                                        await vehicleListings
                                            .doc(copyHostID)
                                            .delete();
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Listings()),
                                        );
                                      }
                                    } catch (error) {
                                      print("Error: $error");
                                    }
                                  }
                                : null,
                            child: Text(
                              "Confirm Listing Removal",
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateButtonState() {
    setState(() {
      _buttonEnabled = _sold! ||
          _betterPlatform! ||
          _serviceFeeTooHigh! ||
          _securityConcerns! ||
          _unforeseenCircumstances! ||
          _other!;
    });
  }
}

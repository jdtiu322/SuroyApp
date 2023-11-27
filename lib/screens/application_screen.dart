import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suroyapp/reusable_widgets/reusable_widgets.dart';
import 'package:suroyapp/reusable_widgets/user_image.dart';
import 'package:suroyapp/screens/address_screen.dart';
import 'package:suroyapp/screens/home_screen.dart';
import 'package:suroyapp/screens/starting_page.dart';
import 'package:suroyapp/screens/vehicle_info.dart';
import 'package:suroyapp/utils/color_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suroyapp/screens/signup_screen.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  _ApplicationState() {
    selectedVehicle = vehicleList[0];
  }
  final vehicleList = [
    "Sedan",
    "SUV",
    "Van",
    "Minivan",
    "Pick-up Truck",
    "Crossover"
  ];

  TextEditingController vehicleModel = TextEditingController();
  TextEditingController modelYear = TextEditingController();
  TextEditingController plateNumber = TextEditingController();
  TextEditingController numSeats = TextEditingController();

  String? selectedVehicle = "";

  String imageUrl = '';

  final user = FirebaseAuth.instance.currentUser!;
  late String firstName = ""; // Initialize with empty string
  late String lastName = ""; // Initialize with empty string

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      // Assume 'users' is the collection and 'userId' is the document ID
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          firstName = snapshot.data()?['firstName'] ?? "";
          lastName = snapshot.data()?['lastName'] ?? "";
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "Suroy your Vehicle!",
                  style: GoogleFonts.poppins(
                      fontSize: 32, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: DropdownButtonFormField(
                    value: selectedVehicle,
                    items: vehicleList.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedVehicle = val as String;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xfff004aad),
                    ),
                    decoration: InputDecoration(
                      labelText: "Vehicle Type",
                      prefixIcon: const Icon(
                        Icons.car_rental,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Vehicle model", Icons.car_repair_sharp,
                    false, vehicleModel),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Number of seats", Icons.chair_alt, false, numSeats),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Model Year", Icons.calendar_month, false, modelYear),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("License Plate No.", Icons.numbers_rounded,
                    false, plateNumber),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Add image of your vehicle",
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                UserImage(onFileChanged: ((imageUrl) {
                  setState(() {
                    this.imageUrl = imageUrl;
                  });
                })),
                ElevatedButton(
                  onPressed: () async {
                    VehicleInformation1 vehicleInfo = VehicleInformation1(
                      vehicleType: selectedVehicle ?? "",
                      vehicleModel: vehicleModel.text,
                      numSeats: numSeats.text,
                      modelYear: modelYear.text,
                      plateNumber: plateNumber.text,
                      imageUrl: imageUrl,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddressRegistration(vehicleInfo: vehicleInfo),
                      ),
                    );
                  },
                  child: Text("Continue"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
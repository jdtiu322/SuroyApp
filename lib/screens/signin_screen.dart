import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:suroyapp/reusable_widgets/reusable_widgets.dart';
import 'package:suroyapp/screens/renter_landing_screen.dart';
import 'package:suroyapp/screens/signup_screen.dart';
import 'package:suroyapp/screens/starting_page.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();

  GeoPoint userGeoLocation = GeoPoint(0, 0); // Initialize with a default value
  String userLocation = '';
  Timer? locationUpdateTimer;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      await _getUserLocation();
    } catch (e) {
      print('Error initializing location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0,
              20,
              0,
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 130),
                Image.asset('assets/images/suroy-logo.png', width: 200,),
                const SizedBox(height: 30),
                Align(
                  alignment: const Alignment(0, -0.1),
                  child: Text(
                    "Welcome!",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  "Login below or create an account",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: const Color.fromARGB(179, 4, 23, 194),
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white70,
                  ),
                ),
                const SizedBox(height: 70),
                reusableTextField(
                  "Enter username",
                  Icons.person_outline,
                  false,
                  emailTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter password",
                  Icons.lock_outline,
                  true,
                  passwordTextController,
                ),
                const SizedBox(height: 50),
                signInSignUpButton(context, true, () async {
                  await _getUserLocation();

                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                    email: emailTextController.text,
                    password: passwordTextController.text,
                  )
                      .then((value) async {
                    locationUpdateTimer = Timer.periodic(Duration(minutes: 1),
                        (Timer timer) async {
                      await _getUserLocation();
                    });

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RenterLandingScreen(),
                      ),
                    );
                  }).catchError((error, stackTrace) {
                    Fluttertoast.showToast(
                      msg: "Invalid details, please try again!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );

                    print("Error ${error.toString()}");
                  });
                }),
                signUpOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: GoogleFonts.poppins(color: const Color(0xfff004aad)),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SignUpScreen(),
              ),
            );
          },
          child: Text(
            " Sign Up",
            style: GoogleFonts.poppins(
              color: const Color(0xfff004aad),
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: const Color(0xfff004aad),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Check if a document with the provided email already exists

      CollectionReference addLocation =
          FirebaseFirestore.instance.collection('userLocation');
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('userLocation')
          .where('email', isEqualTo: emailTextController.text)
          .get();

      GeoPoint newLocation = GeoPoint(position.latitude, position.longitude);

      if (querySnapshot.docs.isNotEmpty) {
        // Retrieve the location from the document
        DocumentSnapshot locationDocument = querySnapshot.docs.first;
        GeoPoint existingLocation = locationDocument['location'];

        setState(() {
          userLocation =
              "Latitude: ${existingLocation.latitude}, Longitude: ${existingLocation.longitude}";
          userGeoLocation = existingLocation;
        });

        print('Location retrieved from existing document: $userLocation');

        // Update location in Firestore if it has changed
        if (newLocation != existingLocation) {
          await locationDocument.reference.update({'location': newLocation});
          print('Location updated in existing document: $newLocation');
        }
      } else {
        String email = emailTextController.text;

        await FirebaseFirestore.instance
            .collection('userLocation')
            .add({'email': email, 'location': newLocation});
      }
    } catch (e) {
      print('Error getting or updating location: $e');
    }
  }

  ElevatedButton signInSignUpButton(
      BuildContext context, bool isSignIn, Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(isSignIn ? 'Sign In' : 'Sign Up'),
    );
  }

  @override
  void dispose() {
    locationUpdateTimer?.cancel();
    super.dispose();
  }
}

Widget logoWidget(String imagePath) {
  return Image.asset(imagePath, width: 300, height: 300);
}

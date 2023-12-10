import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suroyapp/controllers/auth_controller.dart';
import 'package:suroyapp/reusable_widgets/user_image.dart';
import 'package:suroyapp/screens/home_screen.dart';
import 'package:suroyapp/screens/renter_landing_screen.dart';
import 'package:suroyapp/screens/signin_screen.dart';
import 'package:suroyapp/screens/starting_page.dart';
import 'package:suroyapp/utils/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suroyapp/reusable_widgets/reusable_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController middleNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController ageTextController = TextEditingController();
  TextEditingController phoneNumberTextController = TextEditingController();
  TextEditingController driverLicenseTextController = TextEditingController();

  final AuthController _authController = AuthController();
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Uint8List? _image;

  String? licenseImageUrl;

  late String password;
  late String email;
  late String firstName;
  late String middleName;
  late String lastName;
  late String age;
  late String phoneNumber;
  late String driverLicense;

  selectGalleryImage() async {
    Uint8List im = await _authController.pickProfileImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  _saveRenterDetail() async {
    EasyLoading.show();
    if (_formKey.currentState!.validate()) {
      password = passwordTextController.text;
      email = emailTextController.text;
      firstName = firstNameTextController.text;
      middleName = middleNameTextController.text;
      lastName = lastNameTextController.text;
      age = ageTextController.text;
      phoneNumber = phoneNumberTextController.text;
      driverLicense = driverLicenseTextController.text;
      await _authController
          .registerRenter(firstName, middleName, lastName, age, email, password,
              phoneNumber, driverLicense, _image)
          .whenComplete(() {
        EasyLoading.dismiss();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RenterLandingScreen()),
        );
      });
    } else {
      print('Bad');
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0, 20, 0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 30),
                  const Text(
                    "Create an account",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  signInOption(),
                  const SizedBox(height: 30),
                  reusableTextField(
                      "Email", Icons.mail, false, emailTextController),
                  const SizedBox(height: 20),
                  reusableTextField("Password", Icons.lock_outline, true,
                      passwordTextController),
                  const SizedBox(height: 20),
                  reusableTextField("First Name", Icons.person_outline, false,
                      firstNameTextController),
                  const SizedBox(height: 20),
                  reusableTextField("Middle Name", Icons.person_outline, false,
                      middleNameTextController),
                  const SizedBox(height: 20),
                  reusableTextField("Last Name", Icons.person_outline, false,
                      lastNameTextController),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: resizableTextField(
                            "Phone Number",
                            Icons.phone_android_outlined,
                            180,
                            phoneNumberTextController),
                      ),
                      const SizedBox(
                        width: 20,
                      ), // Add some spacing between the two fields
                      Expanded(
                        child: resizableTextField("Age", Icons.hourglass_bottom,
                            180, ageTextController),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  reusableTextField("Driver's License", Icons.numbers_outlined,
                      false, driverLicenseTextController),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Add image of your driver's license",
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          selectGalleryImage();
                        },
                        child: Container(
                          width: 108, // Adjust size as needed
                          height: 108,
                          decoration: BoxDecoration(
                            shape: BoxShape
                                .rectangle, // You can adjust shape as needed
                            // Add any additional styling you need
                          ),
                          child: _image == null
                              ? SvgPicture.asset(
                                  'assets/vectors/add-image.svg',
                                  fit: BoxFit.cover,
                                )
                              : Image.memory(
                                  _image!, // _image is checked for null above, so ! is safe here
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
              
                      // Space between the image and the text
                      SizedBox(
                          height: 5), // Adjust the height for more or less space
              
                      // Text Widget for 'Change Photo' or 'Select photo'
                      InkWell(
                        onTap: () {
                          selectGalleryImage();
                        },
                        child: Text(
                          _image != null ? 'Change Photo' : 'Select photo',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      _saveRenterDetail();
                    },
                    child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width - 40,
                        decoration: BoxDecoration(
                          color: Color(0xFF004AAD),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                            child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row signInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Have an account already? Click here to",
            style: TextStyle(
              color: Color(0xfff004aad),
            )),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignInScreen(),
              ),
            );
          },
          child: const Text(
            " log-in",
            style: TextStyle(
              color: Color(0xfff004aad),
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
              decorationColor: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:suroyapp/screens/home_screen.dart';
import 'package:suroyapp/screens/signin_screen.dart';
import 'package:suroyapp/screens/starting_page.dart';
import 'package:suroyapp/utils/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suroyapp/reusable_widgets/reusable_widgets.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0, 20, 0),
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
                reusableTextField("Email", Icons.mail, false, emailTextController),
                const SizedBox(height: 20),
                reusableTextField("Password", Icons.lock_outline, true, passwordTextController),
                const SizedBox(height: 20),
                reusableTextField("First Name", Icons.person_outline, false, firstNameTextController),
                const SizedBox(height: 20),
                reusableTextField("Middle Name", Icons.person_outline, false, middleNameTextController),
                const SizedBox(height: 20),
                reusableTextField("Last Name", Icons.person_outline, false, lastNameTextController),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: resizableTextField("Phone Number", Icons.phone_android_outlined, 180, phoneNumberTextController),
                    ),
                    const SizedBox(
                      width: 20,
                    ), // Add some spacing between the two fields
                    Expanded(
                      child: resizableTextField("Age", Icons.hourglass_bottom, 180, ageTextController),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                reusableTextField("Driver's License", Icons.numbers_outlined, false, driverLicenseTextController),
                const SizedBox(height: 20),
                signInSignUpButton(context, false, () async {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailTextController.text,
                      password: passwordTextController.text,
                    );

                    // mo check if dili null ang gi return sa createUserWithEmailAndPassword
                    User? user = userCredential.user;

                    if (user != null) {
                      // Save additional user information to Firestore
                      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                        'email': emailTextController.text,
                        'password': passwordTextController.text,
                        'firstName': firstNameTextController.text,
                        'middleName': middleNameTextController.text,
                        'lastName': lastNameTextController.text,
                        'age': ageTextController.text,
                        'phoneNumber': phoneNumberTextController.text,
                        'driverLicense': driverLicenseTextController.text,
                      });

                      print("New account created");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const StartingPage()));
                    }
                  } catch (error) {
                    print("Invalid account details ${error.toString()}");
                  }
                }),
              ],
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
        const Text("Have an account already? Click here to", style: TextStyle(color:Color(0xfff004aad),)),
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

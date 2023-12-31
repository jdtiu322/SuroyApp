import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suroyapp_adminpanel/views/main_screen.dart';
import 'package:suroyapp_adminpanel/views/screens/side_bar_screens/widgets/reusable_widgets.dart';
import 'package:suroyapp_adminpanel/views/screens/signin_screen.dart';

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
  // TextEditingController driverLicenseTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0, 20, 0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 30),
                Text(
                  "Create an account as Admin",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                signInOption(),
                SizedBox(height: 30),
                reusableTextField("Email", Icons.mail, false, emailTextController),
                SizedBox(height: 20),
                reusableTextField("Password", Icons.lock_outline, true, passwordTextController),
                SizedBox(height: 20),
                reusableTextField("First Name", Icons.person_outline, false, firstNameTextController),
                SizedBox(height: 20),
                reusableTextField("Middle Name", Icons.person_outline, false, middleNameTextController),
                SizedBox(height: 20),
                reusableTextField("Last Name", Icons.person_outline, false, lastNameTextController),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: resizableTextField("Phone Number", Icons.phone_android_outlined, 180, phoneNumberTextController),
                    ),
                    SizedBox(
                      width: 20,
                    ), // Add some spacing between the two fields
                    Expanded(
                      child: resizableTextField("Age", Icons.hourglass_bottom, 180, ageTextController),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // reusableTextField("Driver's License", Icons.numbers_outlined, false, driverLicenseTextController),
                SizedBox(height: 20),
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
                      await FirebaseFirestore.instance.collection('admin').doc(user.uid).set({
                        'email': emailTextController.text,
                        'firstName': firstNameTextController.text,
                        'middleName': middleNameTextController.text,
                        'lastName': lastNameTextController.text,
                        'age': ageTextController.text,
                        'phoneNumber': phoneNumberTextController.text,
                      });

                      print("New account created");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
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
        const Text("Have an account already? Click here to", style: TextStyle(color:Color(0xfFF004AAD),)),
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
              color: Color(0xfFF004AAD),
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
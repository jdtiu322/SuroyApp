import 'package:flutter/material.dart';
import 'package:suroyapp/screens/home_screen.dart';
import 'package:suroyapp/screens/signin_screen.dart';
import 'package:suroyapp/utils/color_utils.dart';
import 'package:suroyapp/reusable_widgets/reusable_widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        hexStringToColor("FFFFFF"),
        hexStringToColor("#2A61C8"),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0, 20, 0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              Text("Create an account",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  )),
              signInOption(),
              SizedBox(height: 30),
              reusableTextField(
                  "Email", Icons.mail, false, emailTextController),
              SizedBox(height: 20),
              reusableTextField(
                  "Password", Icons.lock_outline, true, passwordTextController),
              SizedBox(height: 20),
              reusableTextField("First Name", Icons.person_outline, false,
                  passwordTextController),
              SizedBox(height: 20),
              reusableTextField("Middle Name", Icons.person_outline, false,
                  passwordTextController),
              SizedBox(height: 20),
              reusableTextField("Last Name", Icons.person_outline, false,
                  passwordTextController),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: resizableTextField(
                          "Phone Number", Icons.phone_android_outlined, 180)),
                  SizedBox(
                      width: 20), // Add some spacing between the two fields
                  Expanded(
                      child: resizableTextField(
                          "Age", Icons.hourglass_bottom, 180)),
                ],
              ),
              SizedBox(height: 20),
              reusableTextField("Driver's License", Icons.numbers_outlined,
                  false, emailTextController),
              SizedBox(height: 20),
              signInSignUpButton(context, false, () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              }),
            ],
          ),
        ),
      ),
    ));
  }

  Row signInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Have an account already? Click here to",
            style: TextStyle(color: Colors.grey)),
        GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignInScreen()));
            },
            child: const Text(" log-in",
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.grey)))
      ],
    );
  }
}

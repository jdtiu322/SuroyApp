import 'package:flutter/material.dart';
import 'package:food/reusable_widgets/reusable_widgets.dart';
import 'package:food/utils/color_utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        hexStringToColor("FFFFFF"),
        hexStringToColor("#2A61C8"),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.fromLTRB(
            20, MediaQuery.of(context).size.height * 0, 20, 0),
        child: Column(children: <Widget>[
          SizedBox(height: 130),
          logoWidget("assets/images/logo1.png"),
          SizedBox(height: 50),
          Align(
           alignment: Alignment(0, -0.1), // Adjust the vertical value (-1.0) to move the text closer to the top
           child: Text(
            "Welcome!",
             style: TextStyle(
             fontSize: 30,
             fontFamily: 'Inter',
             fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            "Login below or create an account",
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Poppins',
              color: Colors.white70,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white70,
            )
          ),
          SizedBox(height: 70),
          reusableTextField("Enter username", Icons.person_outline, false, emailTextController),
          SizedBox(height: 20),
          reusableTextField("Enter password", Icons.lock_outline, true, passwordTextController),
          SizedBox(height: 50),
          signInSignUpButton(context, true, (){})
        ]),
      )),
    ));
  }
}

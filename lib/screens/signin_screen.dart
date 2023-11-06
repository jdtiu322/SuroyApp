import 'package:flutter/material.dart';
import 'package:food/reusable_widgets/reusable_widgets.dart';
import 'package:food/screens/signup_screen.dart';
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
        padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0, 20, 0),
        child: Column(children: <Widget>[
          const SizedBox(height: 130),
          logoWidget("assets/images/logo1.png"),
          const SizedBox(height: 50),
          const Align(
            alignment: Alignment(0,
                -0.1), // Adjust the vertical value (-1.0) to move the text closer to the top
            child: Text(
              "Welcome!",
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Text("Login below or create an account",
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Poppins',
                color: Colors.white70,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white70,
              )),
          const SizedBox(height: 70),
          reusableTextField("Enter username", Icons.person_outline, false,
              emailTextController),
          const SizedBox(height: 20),
          reusableTextField("Enter password", Icons.lock_outline, true,
              passwordTextController),
          const SizedBox(height: 50),
          signInSignUpButton(context, true, () {}),
          signUpOption()
        ]
        ),
      )
      ),
    )
    );
  }
 
  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()));
            },
            child: const Text(" Sign Up",
                style: TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.bold, 
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white70)))
      ],
    );
  }
}

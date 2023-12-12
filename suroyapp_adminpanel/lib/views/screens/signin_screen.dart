import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suroyapp_adminpanel/views/main_screen.dart';
import 'package:suroyapp_adminpanel/views/screens/side_bar_screens/widgets/reusable_widgets.dart';
import 'package:suroyapp_adminpanel/views/screens/signup_screen.dart';

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
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [
        //       hexStringToColor("FFFFFF"),
        //       hexStringToColor("#2A61C8"),
        //     ],
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //   ),
        decoration: BoxDecoration(
          color: Colors.white),
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
                // logoWidget("assets/images/suroylogo.png"),
                const SizedBox(height: 30),
                   Align(  
                  alignment: Alignment(0, -0.1),
                  child: Text(
                    "Welcome Admin!",
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
                    color: Color.fromARGB(179, 4, 23, 194),                 
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
                signInSignUpButton(context, true, () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                    email: emailTextController.text,
                    password: passwordTextController.text,
                  )
                      .then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreen(),
                      ),
                    );
                  }).catchError((error, stackTrace) {
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
        Text("Don't have account?",
            style:GoogleFonts.poppins(
              color: Color(0xfFF004AAD),)),
        GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()));
            },
            child: Text(" Sign Up",
                style: 
                    GoogleFonts.poppins(
                    color: Color(0xfFF004AAD),
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xfFF004AAD),))),
      ],
    );
  }
}
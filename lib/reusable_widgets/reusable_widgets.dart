import 'package:flutter/material.dart';
import 'package:suroyapp/screens/signin_screen.dart';

Image logoWidget(String imageName) {
  return Image.asset(imageName, fit: BoxFit.fitWidth, width: 600);
}

//reusable textfield widget
TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
      //textfield behavior
      controller: controller,
      obscureText: isPasswordType,
      enableSuggestions: !isPasswordType,
      autocorrect: !isPasswordType,
      cursorColor: Colors.blue,
      style: TextStyle(color: Colors.black45.withOpacity(0.7)),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black),
        labelText: text,
        labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white.withOpacity(.1),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(width: 1, style: BorderStyle.solid)),
      ),
      keyboardType: isPasswordType
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress);
}

Widget resizableTextField(
  String data,
  IconData icon,
  double width, // Pass the desired width as a parameter
) {
  return SizedBox(
    width: width,
    child: TextField(
      cursorColor: Colors.blue,
      style: TextStyle(color: Colors.black45.withOpacity(0.7)),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black),
        labelText: data,
        labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white.withOpacity(.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 1, style: BorderStyle.solid),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      ),
    ),
  );
}

//reusable button for signin and login
Container signInSignUpButton(
    BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
        onPressed: () {
          onTap();
        },
        child: Text(
          isLogin ? 'LOG IN' : 'SIGN UP',
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              fontSize: 16),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.white70;
            }
            return const Color.fromARGB(255, 33, 72, 243);
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
        )),
  );
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suroyapp_adminpanel/views/screens/side_bar_screens/bookings_screen.dart';
import 'package:suroyapp_adminpanel/views/screens/side_bar_screens/carowners_screen.dart';


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
      style: GoogleFonts.poppins(color: Colors.black45.withOpacity(0.7)),
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
    TextEditingController controller) {
  return SizedBox(
    width: width,
    child: TextField(
      controller: controller,
      cursorColor: Colors.blue,
      style: GoogleFonts.poppins(color: Colors.black45.withOpacity(0.7)),
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
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
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
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.white70;
            }
            return const Color.fromARGB(255, 33, 72, 243);
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
        ),
        child: Text(
          isLogin ? 'LOG IN' : 'SIGN UP',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        )),
  );
}

Container reserveButton() {
  return Container(
    decoration: BoxDecoration(
        color: const Color(0xfff004aad),
        borderRadius: BorderRadius.circular(10)),
    height: 50,
    width: 100,
    child: Align(
      alignment: Alignment.center,
      child: Text(
        "RESERVE",
        style:
            GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
  );
}


int calculateTotalDays(DateTime startDate, DateTime endDate) {
  Duration difference = endDate.difference(startDate);
  int totalDays = difference.inDays;

  return totalDays;
}

ElevatedButton cancellationButton(BuildContext context) {
  return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
        Color(0xfff004aad),
      )),
      onPressed: () async {
        try {
          User? user = FirebaseAuth.instance.currentUser;
          String renterID = "";
          if (user != null) {
            renterID = user.uid;

            CollectionReference bookings =
                FirebaseFirestore.instance.collection('bookings');

            QuerySnapshot chuGwapo =
                await bookings.where('renterID', isEqualTo: renterID).get();

            DocumentSnapshot chuCutie = chuGwapo.docs.first;

            String copyRenterId = chuCutie.id;

            await bookings.doc(copyRenterId).delete();
            Navigator.push(context, MaterialPageRoute(builder: (context) => BookingsScreen()));

          }
        } catch (error) {
          print("Error: $error");
        }
      },
      child: Text(
        "Confirm Cancellation",
        style: GoogleFonts.poppins(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ));
}

 ElevatedButton removeListingButton(BuildContext context) {
  return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
        Color(0xfff004aad),
      )),
      onPressed: () async {
        try {
          User? user = FirebaseAuth.instance.currentUser;
          String hostID = "";
          if (user != null) {
            hostID = user.uid;

            CollectionReference vehicleListings =
                FirebaseFirestore.instance.collection('vehicleListings');

            QuerySnapshot chuGwapo =
                await vehicleListings.where('hostID', isEqualTo: hostID).get();

            DocumentSnapshot chuCutie = chuGwapo.docs.first;

            String copyHostID = chuCutie.id;

            await vehicleListings.doc(copyHostID).delete();
            Navigator.push(context, MaterialPageRoute(builder: (context) => CarOwnersScreen()));

          }
        } catch (error) {
          print("Error: $error");
        }
      },
      child: Text(
        "Confirm Listing Removal",
        style: GoogleFonts.poppins(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ));
}

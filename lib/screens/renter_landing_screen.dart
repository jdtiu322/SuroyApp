import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:suroyapp/models/renter_user_models.dart';
import 'package:suroyapp/screens/signin_screen.dart';
import 'package:suroyapp/screens/signup_screen.dart';
import 'package:suroyapp/screens/starting_page.dart';


class RenterLandingScreen extends StatelessWidget {
  const RenterLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final CollectionReference _rentersStream =
        FirebaseFirestore.instance.collection('users');
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: _rentersStream.doc(_auth.currentUser!.uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          if(!snapshot.data!.exists){
            return SignUpScreen();
          }

          RenterUserModel renterUserModel = RenterUserModel.fromJson(
              snapshot.data!.data()! as Map<String, dynamic>);

          if(renterUserModel.approved == true){
            return StartingPage();
          } 
          return Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
             
              SizedBox(
                height: 15,
              ),
              Text(
                renterUserModel.firstName.toString(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Your application has been sent to the admin\n Admin will get back to you soon!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignInScreen()),
                  );
                },
                child: Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              )
            ]),
          );
        },
      ),
    );
  }
}

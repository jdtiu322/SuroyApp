import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:suroyapp/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:suroyapp/screens/landing_screen.dart';
import 'package:suroyapp/screens/signin_screen.dart';
import 'package:suroyapp/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false, // Set this to false to hide the debug banner
      home: LandingPage(), // Replace 'MyApp' with your app's root widget
    ),);
}


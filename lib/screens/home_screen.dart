import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suroyapp/screens/bookings_screen.dart';
import 'package:suroyapp/screens/message_screen.dart';
import 'package:suroyapp/screens/profile_screen.dart';
import 'package:suroyapp/screens/wishlist_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(

      ),
    );
  }
}

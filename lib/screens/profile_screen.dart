import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suroyapp/screens/application_screen.dart';
import 'package:suroyapp/screens/home_screen.dart';
import 'package:suroyapp/screens/notification_screen.dart';
import 'package:suroyapp/screens/profile_details.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  late String firstName = ""; // Initialize with empty string
  late String lastName = "";  // Initialize with empty string

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      // Assume 'users' is the collection and 'userId' is the document ID
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          firstName = snapshot.data()?['firstName'] ?? "";
          lastName = snapshot.data()?['lastName'] ?? "";
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0, 20, 0),
              child: Column(
                children: <Widget>[
                   GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const ProfileDetails()));
      },
      child: Container(
          height: 80,
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey)),
              color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/vectors/profile-circle.svg',
                  width: 60,
                  height: 60,
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                       '$firstName $lastName',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Show Profile",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: SvgPicture.asset(
                      'assets/vectors/arrow-right.svg',
                    ))
              ],
            ),
          )),
    ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Application()));
                    },
                    child: Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        height: 130,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white.withOpacity(0.9),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              )
                            ]),
                        child: Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "SUROY YOUR VEHICLE",
                                  style: GoogleFonts.oswald(
                                    fontSize: 20,
                                    color: const Color(0xfff004aad),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Use your vehicle to invest,",
                                  style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "let us do the rest",
                                  style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Image.asset('assets/images/landingpage.png',
                                width: 150, height: 150),
                          )
                        ]),
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        "Profile",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black,
        ),
      ),
      backgroundColor: const Color(0xfff004aad).withOpacity(0.1),
      elevation: 0.0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/vectors/arrow.svg',
            width: 25,
            height: 25,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()));
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: SvgPicture.asset('assets/vectors/notifications.svg'),
            ),
          ),
        )
      ],
    );
  }
}
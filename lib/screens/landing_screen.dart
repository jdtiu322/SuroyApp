import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suroyapp/reusable_widgets/reusable_widgets.dart';
import 'package:suroyapp/screens/signin_screen.dart';
import 'package:suroyapp/utils/color_utils.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0, 20, 0),
          child: Column(children: <Widget>[
            const SizedBox(height: 130),
            logoWidget('assets/images/landingpage.png'),
            SizedBox(height: 10),
            Align(
              child: Text("Rent",
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w600
                  ),
                  
                  ),
            ),
            Text("a perfect vehicle",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 32)),
           Text("for any occasion",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 32)),
            SizedBox(height: 15),
           Text(
              "It's never been easier",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Color.fromARGB(255, 133, 132, 132),
              ),
            ),
             Text(
              "to rent a car using an app.",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Color.fromARGB(255, 133, 132, 132),
              ),
            ),
             Text(
              "Low rates & quality service.",
              style: 
                GoogleFonts.poppins(
                fontSize: 14,
                color: Color.fromARGB(255, 133, 132, 132),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.white70;
                  }
                  return const Color.fromARGB(255, 33, 72, 243);
                }),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18))),
                minimumSize: MaterialStateProperty.all(Size(230, 50))
              ),
              child: Text("Let's go",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                  )),
            )
          ]),
        )),
      ),
    );
  }
}

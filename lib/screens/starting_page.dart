import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suroyapp/screens/bookings_screen.dart';
import 'package:suroyapp/screens/home_screen.dart';
import 'package:suroyapp/screens/message_screen.dart';
import 'package:suroyapp/screens/profile_screen.dart';
import 'package:suroyapp/screens/wishlist_screen.dart';

class StartingPage extends StatefulWidget {
  const StartingPage({super.key});

  @override
  State<StartingPage> createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  int myIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      myIndex = index;
    });
  }

  final List pages = [
    const HomeScreen(),
    const WishlistScreen(),
    const BookingsScreen(),
    const MessageScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[myIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: myIndex,
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: navigateBottomBar,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/vectors/magnifying-glass-solid.svg',
              width: 25,
            ),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/vectors/heart.svg'),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/vectors/car.svg',
            ),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/vectors/message.svg'),
              label: 'Messages'),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/vectors/profile.svg'),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

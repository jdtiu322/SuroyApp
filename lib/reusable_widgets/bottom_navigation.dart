import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suroyapp/screens/home_screen.dart';
import 'package:suroyapp/screens/wishlist_screen.dart';
import 'package:suroyapp/screens/bookings_screen.dart';
import 'package:suroyapp/screens/message_screen.dart';
import 'package:suroyapp/screens/profile_screen.dart';


class GeneralBottomNavigation extends StatefulWidget {
  @override
  _GeneralBottomNavigationState createState() => _GeneralBottomNavigationState();
}

class _GeneralBottomNavigationState extends State<GeneralBottomNavigation> {
  int myIndex = 0;

  final List<Widget> _screens = [
    // const HomeScreen(),
    const WishlistScreen(),
    const BookingsScreen(),
    const MessageScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[myIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        currentIndex: myIndex,
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
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/vectors/profile.svg'),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

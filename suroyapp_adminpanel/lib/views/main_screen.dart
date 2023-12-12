


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:suroyapp_adminpanel/views/screens/side_bar_screens/bookings_screen.dart';
import 'package:suroyapp_adminpanel/views/screens/side_bar_screens/carowners_screen.dart';
import 'package:suroyapp_adminpanel/views/screens/side_bar_screens/ratings_screen.dart';
import 'package:suroyapp_adminpanel/views/screens/side_bar_screens/commissions_screen.dart';
import 'package:suroyapp_adminpanel/views/screens/side_bar_screens/complaints_screen.dart';
import 'package:suroyapp_adminpanel/views/screens/side_bar_screens/dashboard_screen.dart';
import 'package:suroyapp_adminpanel/views/screens/side_bar_screens/profit_screen.dart';
import 'package:suroyapp_adminpanel/views/screens/side_bar_screens/renters_screen.dart';
import 'package:suroyapp_adminpanel/views/screens/side_bar_screens/uploadbanner_screen.dart';
import 'package:suroyapp_adminpanel/views/screens/signin_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  Widget _selectedItem = DashboardScreen();

  screenSlector(item){
    switch(item.route){
      case DashboardScreen.routeName:
      setState(() {
        _selectedItem = DashboardScreen();
      });
      break;
      case RentersScreen.routeName:
      setState(() {
        _selectedItem = RentersScreen();
      });
      break;
      case CarOwnersScreen.routeName:
      setState(() {
        _selectedItem = CarOwnersScreen();
      });
      break;
      case ProfitScreen.routeName:
      setState(() {
        _selectedItem = ProfitScreen();
      });
      break;
      case BookingsScreen.routeName:
      setState(() {
        _selectedItem = BookingsScreen();
      });
      break;
      case CommissionsScreen.routeName:
      setState(() {
        _selectedItem = CommissionsScreen();
      });
      break;
      case RatingsScreen.routeName:
      setState(() {
        _selectedItem = RatingsScreen();
      });
      break;
      case ComplaintsScreen.routeName:
      setState(() {
        _selectedItem = ComplaintsScreen();
      });
      break;
      // case CategoriesScreen.routeName:
      // setState(() {
      //   _selectedItem = CategoriesScreen();
      // });
      // break;
      case UploadBannerScreen.routeName:
      setState(() {
        _selectedItem = UploadBannerScreen();
      });
      break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.only(right: 8.0), // Adjust the spacing as needed
            child: Image.asset(
              'assets/images/suroylogo.png',
              height: 60.0, // Adjust the height as needed
              width: 60.0, // Adjust the width as needed
            ),
          ),
          Text('Suroy',
          style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Navigate to the sign-in page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()), // Replace SignInScreen with your actual sign-in screen class name
              );
            },
          ),
        ],
      leading: Container(), // Remove this line if you don't want the default leading icon
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(10.0), // Set the thickness of the border
        child: Container(
          color: Colors.blueAccent, // Set the color of the border
          height: 1.5, // Set the thickness of the border
        ),
      ),
      ),

      sideBar: SideBar(
        backgroundColor: Color(0xFFBAD6EB),
        items: [
        AdminMenuItem(
        title: 'Dashboard', 
        icon: Icons.dashboard, 
        route: DashboardScreen.routeName,
        ),
        AdminMenuItem(
        title: 'Users', 
        icon: CupertinoIcons.person_3, 
        route: RentersScreen.routeName,
        ),
        AdminMenuItem(
        title: 'Vehicle Listings', 
        icon: CupertinoIcons.person, 
        route: CarOwnersScreen.routeName,
        ),
        AdminMenuItem(
        title: 'Profit', 
        icon: CupertinoIcons.money_dollar, 
        route: ProfitScreen.routeName,
        ),
        AdminMenuItem(
        title: 'Bookings', 
        icon: CupertinoIcons.book_circle, 
        route: BookingsScreen.routeName,
        ),
        AdminMenuItem(
        title: 'Commissions', 
        icon: CupertinoIcons.money_dollar_circle, 
        route: CommissionsScreen.routeName,
        ),
        AdminMenuItem(
        title: 'Ratings', 
        icon: CupertinoIcons.star_fill, 
        route: RatingsScreen.routeName,
        ),
        AdminMenuItem(
        title: 'Complaints', 
        icon: CupertinoIcons.exclamationmark_bubble_fill, 
        route: ComplaintsScreen.routeName,
        ),
        // AdminMenuItem(
        // title: 'Categories', 
        // icon: CupertinoIcons.color_filter, 
        // route: CategoriesScreen.routeName,
        // ),
        AdminMenuItem(
        title: 'Upload Banner', 
        icon: CupertinoIcons.add, 
        route: UploadBannerScreen.routeName,
        ),
        
      ], selectedRoute: '', onSelected: (item){
        screenSlector(item);
      },
      header: Container(
          height: 60,
          //padding: EdgeInsets.symmetric(horizontal: 20.0),
          width: double.infinity,
          color: Color.fromARGB(255, 63, 113, 206),
          child: const Center(
            child: Text(
              'Admin Panel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _selectedItem,
    ),
    );
  }
}
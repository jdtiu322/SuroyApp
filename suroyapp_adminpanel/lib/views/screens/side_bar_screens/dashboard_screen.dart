import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:suroyapp_adminpanel/services/firebase_services.dart';
import 'package:suroyapp_adminpanel/views/screens/side_bar_screens/widgets/recentcarowner_widget.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = '\DashboardScreen';
  FirebaseServices _services = FirebaseServices();

  Widget _rowHeader(String text, int flex) {
  return Expanded(
    flex: flex,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        border: Border.all(color: Colors.grey[300]!), // Light-colored border
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
   Widget analyticWidget({
  String title = "",
  String value = "",
  IconData? icon,
  Color? iconColor,
}) {
  return Container(
    margin: EdgeInsets.all(8),
    padding: const EdgeInsets.all(16.0),
    width: 280,
    decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon != null ? Icon(icon, size: 40, color: iconColor,) : Container(),
              ],
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: const Text(
            'Dashboard',
            style: TextStyle(
              color: Color.fromARGB(255, 57, 91, 143),
              fontWeight: FontWeight.w700,
              fontSize: 36,
            ),
          ),
        ),
        SizedBox(height: 30),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            FutureBuilder<int>(
              future: _services.getNumberOfUsers(),
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                // Handling the case when snapshot.data is null
                if (!snapshot.hasData || snapshot.data == null) {
                  return Text("No data available");
                }

                return analyticWidget(
                  title: "Total Users",
                  value: snapshot.data?.toString() ?? "0",
                  icon: Icons.person,
                  iconColor: Colors.red,
                );
              },
            ),
            FutureBuilder<int>(
              future: _services.getNumberOfBookings(),
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return Text("No bookings data available");
                }

                return analyticWidget(
                  title: "Total Bookings",
                  value: snapshot.data?.toString() ?? "0",
                  icon: Icons.book_online,
                  iconColor: Colors.green,
                );
              },
            ),

            // FutureBuilder for Total Vehicle Listings
            FutureBuilder<int>(
              future: _services.getNumberOfVehicleListings(),
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return Text("No vehicle listings data available");
                }

                return analyticWidget(
                  title: "Total Vehicle Listings",
                  value: snapshot.data?.toString() ?? "0",
                  icon: Icons.directions_car,
                  iconColor: Colors.orange,
                );
              },
            ),
          ],
        ),
        SizedBox(height: 30),
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Text(
            'Recent Vehicle Listings',
            style: theme.textTheme.headline5
                    ?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 57, 91, 143),
                      ) ??
                TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 57, 91, 143),
                  ),
          ),
        ),
        Row(
          children: [
            _rowHeader('VEHICLE IMAGE', 1),
            _rowHeader('USER ID', 2),
            _rowHeader('VEHICLE MODEL', 1),
            _rowHeader('VEHICLE TYPE', 1),
            _rowHeader('VEHICLE ADDRESS', 2),
            _rowHeader('PLATE NUMBER', 1),
          ],
        ),
        Expanded(
          child: RecentCarownerWidget(),
        ),
      ],
    );
  }
}

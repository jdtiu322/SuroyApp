import 'package:flutter/material.dart';
import 'package:suroyapp_adminpanel/views/screens/side_bar_screens/widgets/carowner_widget.dart';

class CarOwnersScreen extends StatelessWidget {
  static const String routeName = '\CarOwnersScreen';

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
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: const Text(
            'Manage Vehicle Listings',
            style: TextStyle(
              color: Color.fromARGB(255, 57, 91, 143),
              fontWeight: FontWeight.w700,
              fontSize: 36,
            ),
          ),
        ),


        Row(children: [
          _rowHeader('HOST EMAIL', 1),
          _rowHeader('VEHICLE MODEL', 1),
          _rowHeader('VEHICLE TYPE', 1),
          _rowHeader('VEHICLE ADDRESS', 2),
          _rowHeader('PLATE NUMBER', 1),
          _rowHeader('STATUS', 1),
          _rowHeader('APPROVAL', 1),
          _rowHeader('ACTION', 1),

        ],),

        Expanded(
          child: CarownerWidget(),
        ),
      ],
    );
  }
}

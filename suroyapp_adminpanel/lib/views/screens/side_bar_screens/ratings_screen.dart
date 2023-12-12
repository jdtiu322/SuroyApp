import 'package:flutter/material.dart';
import 'package:suroyapp_adminpanel/views/screens/side_bar_screens/widgets/ratings_widget.dart';

class RatingsScreen extends StatelessWidget {
  static const String routeName = '\RatingsScreen';

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
            'Ratings',
            style: TextStyle(
              color: Color.fromARGB(255, 57, 91, 143),
              fontWeight: FontWeight.w700,
              fontSize: 36,
            ),
          ),
        ),


        Row(children: [
          _rowHeader('HOST EMAIL', 2),
          _rowHeader('AVERAGE RATING', 1),
         
          _rowHeader('ACTION', 1),

        ],),

        Expanded(
          child: RatingsWidget(),
        ),
      ],
    );
  }
}

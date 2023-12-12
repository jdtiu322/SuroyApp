import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RatingsWidget extends StatelessWidget {
  const RatingsWidget({super.key});

  Widget ratingsData(int? flex, Widget widget) {
    return Expanded(
      flex: flex!,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          height: 50,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget,
          ),
        ),
      ),
    );
  }

  void showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 700,
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
        );
      },
    );
  }

  void showRatingsDialog(BuildContext context, String hostEmail) async {
    QuerySnapshot ratingsSnapshot = await FirebaseFirestore.instance
        .collection('ratings')
        .where('hostEmail', isEqualTo: hostEmail)
        .get();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Ratings for $hostEmail',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: DataTable(
                    columnSpacing: 15.0,
                    headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Colors.lightBlue[50]!),
                    columns: const [
                      DataColumn(
                        label: Text('Vehicle Image',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Rating',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Review',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Host Email',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Model Year',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Vehicle Model',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Vehicle Type',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                    rows: ratingsSnapshot.docs.map((doc) {
                      return DataRow(
                        cells: [
                          DataCell(
                            doc['imageUrl'] != null
                                ? Image.network(
                                    doc['imageUrl'],
                                    width: 50,
                                    height: 50,
                                  )
                                : Container(),
                          ),
                          DataCell(Text(doc['ratings'].toString())),
                          DataCell(Text(doc['review'] ?? '')),
                          DataCell(Text(doc['hostEmail'])),
                          DataCell(Text(doc['modelYear'])),
                          DataCell(Text(doc['vehicleModel'])),
                          DataCell(Text(doc['vehicleType'])),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  // Helper function to calculate average ratings
  Map<String, double> calculateAverageRatings(
      List<QueryDocumentSnapshot> docs) {
    Map<String, List<double>> ratingsMap = {};
    for (var doc in docs) {
      String email = doc['hostEmail'];
      double rating = (doc['ratings'] is String)
          ? double.tryParse(doc['ratings']) ?? 0
          : (doc['ratings'] as num).toDouble();

      if (!ratingsMap.containsKey(email)) {
        ratingsMap[email] = [];
      }
      ratingsMap[email]!.add(rating);
    }

    return ratingsMap.map((email, ratingsList) {
      double average = ratingsList.reduce((a, b) => a + b) / ratingsList.length;
      return MapEntry(email, average);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collection('ratings').snapshots();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        Map<String, double> averageRatings =
            calculateAverageRatings(snapshot.data!.docs);
        List<String> hostEmails = averageRatings.keys.toList();

        return ListView.builder(
            shrinkWrap: true,
            itemCount: hostEmails.length,
            itemBuilder: (context, index) {
              final ratingsUserdata = snapshot.data!.docs[index];
              String hostEmail = averageRatings.keys.elementAt(index);
              double averageRating = averageRatings[hostEmail]!;

              return Card(
                  margin: EdgeInsets.only(top: 8),
                  color: Colors.blue.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        2.0), // Small radius for edge-like corners
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          ratingsData(
                            2,
                            Text(
                              hostEmail,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ratingsData(
                            1,
                            Text(
                              averageRating.toStringAsFixed(1),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ratingsData(
                            1,
                            ElevatedButton(
                              onPressed: () =>
                                  showRatingsDialog(context, hostEmail),
                              child: Text(
                                'View More',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ),
                        ],
                      )));
            });
      },
    );
  }
}

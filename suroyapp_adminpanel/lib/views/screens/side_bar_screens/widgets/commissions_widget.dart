import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class CommissionsWidget extends StatelessWidget {
  const CommissionsWidget({super.key});

  Widget commissionsData(int? flex, Widget widget) {
    return Expanded(
      flex: flex!,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          height: 50,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: widget,
          ),
        ),
      ),
    );
  }

  Future<void> removeUserData(String documentId) async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(documentId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _commissionsStream =
        FirebaseFirestore.instance.collection('bookings').snapshots();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: _commissionsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final commissionsUserdata = snapshot.data!.docs[index];

            // Convert Timestamp to DateTime and format as a string
            double transactionAmount = double.tryParse(
                    commissionsUserdata['transactionAmount']?.toString() ??
                        '0') ??
                0;
            double PercentOfTransaction = transactionAmount * 0.85;

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
                      commissionsData(
                        2,
                        Text(
                          commissionsUserdata['hostName'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      commissionsData(
                        2,
                        Text(
                          PercentOfTransaction.toStringAsFixed(
                              2), // Removed the dollar sign
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      commissionsData(
                        2,
                        Text(
                          commissionsUserdata['email'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      commissionsData(
                        1,
                        Text(
                          commissionsUserdata['plateNumber'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      commissionsData(
                          1,
                          ElevatedButton(
                              onPressed: () {
                                // Call the removeUserData function with the document ID
                                removeUserData(commissionsUserdata.id);
                              },
                              child: Text(
                                'Remove',
                                style: TextStyle(fontSize: 11),
                              ))),
                    ],
                  ),
                ));
          },
        );
      },
    );
  }
}

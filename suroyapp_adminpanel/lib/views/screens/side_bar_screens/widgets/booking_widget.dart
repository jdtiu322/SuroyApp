import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart'; // Import for date formatting

class BookingWidget extends StatelessWidget {
  const BookingWidget({super.key});

  Widget bookingData(int? flex, Widget widget) {
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
        .collection('users')
        .doc(documentId)
        .delete();
  }

  LatLng convertStringToLatLng(String latLngString) {
    String cleanedString =
        latLngString.replaceAll('LatLng(', '').replaceAll(')', '');
    List<String> latLngParts = cleanedString.split(',');

    if (latLngParts.length == 2) {
      double latitude = double.parse(latLngParts[0].trim());
      double longitude = double.parse(latLngParts[1].trim());

      return LatLng(latitude, longitude);
    } else {
      throw FormatException('Invalid LatLng string format');
    }
  }

  Future<String> getAddressFrom(LatLng location) async {
    GeoData data = await Geocoder2.getDataFromCoordinates(
      latitude: location.latitude,
      longitude: location.longitude,
      googleMapApiKey: "AIzaSyANSqv9C0InmgUe-druqtq_qfD1rKPRZHc",
    );
    if (data != null) {
      return data.address;
    } else {
      return "No address found";
    }
  }

  Future<String> getDisplayAddress(String coordinates) async {
    LatLng latLngAddress = convertStringToLatLng(coordinates);
    String address = await getAddressFrom(latLngAddress);

    return address;
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _bookingsStream =
        FirebaseFirestore.instance.collection('bookings').snapshots();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: _bookingsStream,
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
              final bookingUserdata = snapshot.data!.docs[index];

              // Convert Timestamp to DateTime and format as a string
              DateTime startDate =
                  (bookingUserdata['startDate'] as Timestamp).toDate();
              DateTime endDate =
                  (bookingUserdata['endDate'] as Timestamp).toDate();

              return FutureBuilder<String>(
                future: getDisplayAddress(bookingUserdata[
                    'pickUpAddress']), // Call your reverse geocoding function
                builder: (context, addressSnapshot) {
                  if (addressSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Text("Loading address...");
                  }

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
                            bookingData(
                              1,
                              Text(
                                bookingUserdata['hostName'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            bookingData(
                              1,
                              Text(
                                bookingUserdata['renterID'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            bookingData(
                              1,
                              Text(
                                bookingUserdata['transactionAmount'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            bookingData(
                              2,
                              Text(
                                addressSnapshot.data ??
                                    'Unknown Address', // Display the converted address
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            bookingData(
                              1,
                              Text(
                                DateFormat('yyyy-MM-dd').format(endDate),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            bookingData(
                              1,
                              Text(
                                DateFormat('yyyy-MM-dd').format(startDate),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            bookingData(
                              1,
                              Text(
                                bookingUserdata['plateNumber'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            bookingData(
                                1,
                                ElevatedButton(
                                  onPressed: () {
                                    // Call the removeUserData function with the document ID
                                    removeUserData(bookingUserdata.id);
                                  },
                                  child: Text(
                                    'Remove',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ))
                          ],
                        ),
                      ));
                },
              );
            });
      },
    );
  }
}

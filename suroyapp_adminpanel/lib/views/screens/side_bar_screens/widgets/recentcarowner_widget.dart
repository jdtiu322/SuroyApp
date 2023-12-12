import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:latlong2/latlong.dart';

class RecentCarownerWidget extends StatelessWidget {
  const RecentCarownerWidget({super.key});

  Widget recentcarownerData(int? flex, Widget widget) {
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

  void showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 500,
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
        );
      },
    );
  }
  

  @override
  Widget build(BuildContext context) {
    // Stream to fetch users ordered by creation date in descending order
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('vehicleListings')
        .orderBy('timestamp', descending: true)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        // Debugging
        print(
            'Number of documents fetched: ${snapshot.data?.docs.length ?? 0}');

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text("No recent users data available");
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final recentcarownerUserdata = snapshot.data!.docs[index];

            return FutureBuilder<String>(
              future: getDisplayAddress(recentcarownerUserdata[
                  'renterAddress']), // Call your reverse geocoding function
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
                          recentcarownerData(
                            1,
                            GestureDetector(
                              onTap: () => showImageDialog(context,
                                  recentcarownerUserdata['vehicleImage']),
                              child: Container(
                                height: 30,
                                width: 30,
                                child: Image.network(
                                    recentcarownerUserdata['vehicleImage']),
                              ),
                            ),
                          ),
                          recentcarownerData(
                            2,
                            Text(
                              recentcarownerUserdata['hostId'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          recentcarownerData(
                            1,
                            Text(
                              recentcarownerUserdata['vehicleModel'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          recentcarownerData(
                            1,
                            Text(
                              recentcarownerUserdata['vehicleType'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          recentcarownerData(
                            2,
                            Text(
                              addressSnapshot.data ??
                                  'Unknown Address', // Display the converted address
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          recentcarownerData(
                            1,
                            Text(
                              recentcarownerUserdata['licensePlateNum'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ));
              },
            );
          },
        );
      },
    );
  }
}

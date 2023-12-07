import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:suroyapp/models/vehicle_info.dart';

class LocationTracker extends StatefulWidget {
  final FinalVehicleInfo listingInfo;

  const LocationTracker({Key? key, required this.listingInfo})
      : super(key: key);

  @override
  State<LocationTracker> createState() => _LocationTrackerState();
}

class _LocationTrackerState extends State<LocationTracker> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Tracker'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('userLocation')
            .where('email', isEqualTo: widget.listingInfo.email)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No location found for this user.'),
            );
          }

          var userLocation = snapshot.data!.docs.first;
          var location = userLocation['location'] as GeoPoint;

          return Column(
            children: [
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(location.latitude, location.longitude),
                    zoom: 15.0,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                  markers: {
                    Marker(
                      markerId: MarkerId('user_location'),
                      position: LatLng(location.latitude, location.longitude),
                      infoWindow: InfoWindow(
                        title: 'User Location',
                        snippet: '[$location° N, ${-location.longitude}° W]',
                      ),
                    ),
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


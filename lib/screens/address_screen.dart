import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:awesome_place_search/awesome_place_search.dart';
import 'package:suroyapp/screens/description_screen.dart';
import 'package:suroyapp/screens/vehicle_info.dart';

class AddressRegistration extends StatefulWidget {
  final VehicleInformation1 vehicleInfo;

  const AddressRegistration({Key? key, required this.vehicleInfo})
      : super(key: key);

  @override
  _AddressRegistrationState createState() => _AddressRegistrationState();
}

class _AddressRegistrationState extends State<AddressRegistration> {
  PredictionModel? prediction;
  static const LatLng _pGooglePlex = LatLng(9.8169, 124.0641);
  String selectedLocation = '';
  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Where should we",
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: const [
                              TextSpan(
                                text: 'PICK-UP ',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xfff004aad),
                                ),
                              ),
                              TextSpan(
                                text: ' your vehicle?',
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "Select the address where your vehicle is located. Renters will use this to pick-up your vehicle at the selected address",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        initialCameraPosition:
                            CameraPosition(target: _pGooglePlex, zoom: 12),
                        markers: markers,
                        onTap: _onMapTapped,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    floatingActionButton: Align(
  alignment: Alignment.bottomCenter,
  child: Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: TextButton(
      onPressed: _selectLocation,
      style: TextButton.styleFrom(
        backgroundColor: Color(0xfff004aad), // Customize the button color
      ),
      child: Text(
        "Save Pick-Up Address",
        style: GoogleFonts.poppins(
          color: Colors.white,

        )
      ),
    ),
  ),
),

    );
  }

  void _onMapTapped(LatLng tappedPoint) {
    setState(() {
      // Clear existing markers
      markers.clear();
      // Add a marker to the tapped location
      markers.add(Marker(
        markerId: MarkerId("selected_location"),
        position: tappedPoint,
        infoWindow: InfoWindow(
          title: 'Selected Location',
          snippet: 'Tap the button to save this location',
        ),
      ));
    });
  }
void _selectLocation() {
  // Check if a marker is selected
  if (markers.isNotEmpty) {
    // Get the position of the selected marker
    LatLng selectedPosition = markers.first.position;

    // Create an instance of VehicleInformation2
    VehicleInformation2 vehicleInfo2 = VehicleInformation2(
      pickUpAddress: selectedLocation,
      vehicleType: widget.vehicleInfo.vehicleType,
      vehicleModel: widget.vehicleInfo.vehicleModel,
      numSeats: widget.vehicleInfo.numSeats,
      modelYear: widget.vehicleInfo.modelYear,
      plateNumber: widget.vehicleInfo.plateNumber,
      imageUrl: widget.vehicleInfo.imageUrl,
    );

    print('Selected Location: $selectedPosition');
    print('Complete Vehicle Information: $vehicleInfo2');

    // Navigate to DescriptionPage and pass the vehicleInfo2 object
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DescriptionRegistration(vehicleInfo: vehicleInfo2),
      ),
    );
  }
}


}

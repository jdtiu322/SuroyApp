import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart' as loc;
import 'package:google_api_headers/google_api_headers.dart' as header;
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as places;
import 'package:location/location.dart';
import 'package:suroyapp/reusable_widgets/reusable_widgets.dart';
import 'package:suroyapp/screens/description_screen.dart';
import 'package:suroyapp/screens/vehicle_info.dart';
import 'package:geocoder2/geocoder2.dart';

class AddressRegistration extends StatefulWidget {
  final VehicleInformation1 vehicleInfo;

  const AddressRegistration({Key? key, required this.vehicleInfo})
      : super(key: key);

  @override
  State<AddressRegistration> createState() => _AddressRegistrationState();
}

class _AddressRegistrationState extends State<AddressRegistration> {
  Location location = Location();
  final Map<String, Marker> _markers = {};
  double latitude = 0;
  double longitude = 0;
  GoogleMapController? _controller;
  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(10, 123.5),
    zoom: 10,
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String displayAddress = "Search Pick-Up Address";

  late TextEditingController _searchController;

  @override
  void initState() {
    getCurrentLocation();
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      body: Column(
        children: [
          SizedBox(
            height: 40,
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
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
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
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  initialCameraPosition: _kGooglePlex,
                  markers: _markers.values.toSet(),
                  onTap: (LatLng latlng) {
                    _updateSelectedLocation(latlng);
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  },
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          side: BorderSide(
                            width: 3,
                          )),
                      onPressed: _handleSearch,
                      child: Text(
                        displayAddress,
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40.0,
                  left: 50,
                  right: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xfff004aad),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        if (_markers.isNotEmpty) {
                          LatLng selectedPosition =
                              _markers['myLocation']!.position;
                          _selectLocation(selectedPosition);
                        }
                      },
                      child: Text(
                        'Save Selected Address',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String> displayPrediction(
      places.Prediction p, ScaffoldState? currentState) async {
    places.GoogleMapsPlaces _places = places.GoogleMapsPlaces(
      apiKey: 'AIzaSyANSqv9C0InmgUe-druqtq_qfD1rKPRZHc',
      apiHeaders: await const header.GoogleApiHeaders().getHeaders(),
    );
    places.PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;
    _markers.clear();
    final marker = Marker(
      markerId: const MarkerId('deliveryMarker'),
      position: LatLng(lat, lng),
      infoWindow: const InfoWindow(
        title: '',
      ),
    );
    setState(() {
      _markers['myLocation'] = marker;
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 15),
        ),
      );
    });

    return getAddressFrom(LatLng(lat, lng));
  }

  getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData currentPosition = await location.getLocation();
    latitude = currentPosition.latitude!;
    longitude = currentPosition.longitude!;
    final marker = Marker(
      markerId: const MarkerId('myLocation'),
      position: LatLng(latitude, longitude),
      infoWindow: const InfoWindow(
        title: 'Naa diri mo sakyanan badi',
      ),
    );
    setState(() {
      _markers['myLocation'] = marker;
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(latitude, longitude), zoom: 15),
        ),
      );
    });
  }

  void onError(places.PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Message',
        message: response.errorMessage!,
        contentType: ContentType.failure,
      ),
    ));
  }

  Future<void> _handleSearch() async {
    places.Prediction? p = await loc.PlacesAutocomplete.show(
      context: context,
      apiKey: 'AIzaSyANSqv9C0InmgUe-druqtq_qfD1rKPRZHc',
      onError: onError,
      mode: loc.Mode.overlay,
      language: 'en',
      strictbounds: false,
      types: [],
      decoration: InputDecoration(
        hintText: 'search',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      components: [],
    );

    if (p != null) {
      String address = await displayPrediction(p, _scaffoldKey.currentState);
      setState(() {
        displayAddress = address;
      });
    } else {
      setState(() {
        _markers.clear();
        displayAddress = "Search Pick-Up Address";
      });
    }
  }

  void _updateSelectedLocation(LatLng latlng) async {
     String address = await getAddressFrom(latlng);
  _markers.clear(); // Clear existing markers
  final marker = Marker(
    markerId: const MarkerId('myLocation'),
    position: latlng,
    infoWindow: const InfoWindow(
      title: 'Naa diri imo sakyanan gwapo litse ka',
    ),
  );
  setState(() {
    _markers['myLocation'] = marker;
    displayAddress = address;
  });
  }

  void _selectLocation(LatLng selectedPosition) {
    VehicleInformation2 vehicleInfo2 = VehicleInformation2(
      pickUpAddress: selectedPosition.toString(),
      vehicleType: widget.vehicleInfo.vehicleType,
      vehicleModel: widget.vehicleInfo.vehicleModel,
      hostName: widget.vehicleInfo.hostName,
      numSeats: widget.vehicleInfo.numSeats,
      modelYear: widget.vehicleInfo.modelYear,
      plateNumber: widget.vehicleInfo.plateNumber,
      imageUrl: widget.vehicleInfo.imageUrl,
    );

    print('Selected Location: $selectedPosition');
    print('Complete Vehicle Information: $vehicleInfo2');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DescriptionRegistration(vehicleInfo: vehicleInfo2),
      ),
    );
  }

}

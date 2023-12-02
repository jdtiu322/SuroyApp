import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:suroyapp/reusable_widgets/reusable_widgets.dart';
import 'package:suroyapp/reusable_widgets/vehicle_info.dart';

class BookingDetailsScreen extends StatefulWidget {
  final BookingInfo bookingDetails;
  const BookingDetailsScreen({Key? key, required this.bookingDetails})
      : super(key: key);

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  late String exactAddress;
  String displayAddress = "";
  late GoogleMapController mapController;
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _loadDisplayAddress();
    _updateMapLocation(); // Trigger map update
  }

  Future<void> _loadDisplayAddress() async {
    exactAddress = await getDisplayAddress(widget.bookingDetails.pickUpAddress);
    setState(() {
      displayAddress = exactAddress;
    });
  }

  Future<void> _updateMapLocation() async {
    LatLng location =
        await _getLatLngFromAddress(widget.bookingDetails.pickUpAddress);
    mapController.animateCamera(CameraUpdate.newLatLng(location));
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('vehicleLocation'),
          position: location,
          infoWindow: InfoWindow(
            title: 'Vehicle Location',
            snippet: widget.bookingDetails.pickUpAddress,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Container(
            height: 220,
            color: Colors.blue,
            child: Image.network(
              widget.bookingDetails.imageUrl,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 420,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Additional Vehicle Details",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Exact pick-up address: ",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: displayAddress,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: GoogleMap(
                      mapType: MapType.hybrid,
                      scrollGesturesEnabled: true,
                      zoomControlsEnabled: true,
                      onMapCreated: (controller) {
                        setState(() {
                          mapController = controller;
                          _updateMapLocation(); // Trigger map update
                        });
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(0.0, 0.0), // Default location
                        zoom: 20,
                      ),
                      markers: Set.from(_markers),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Vehicle Plate Number: ",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: widget.bookingDetails.plateNumber,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Additional Host Details",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Host Name: ",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: widget.bookingDetails.hostName,
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Mobile Number: ",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: widget.bookingDetails.hostMobileNumber,
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Email address: ",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: widget.bookingDetails.email,
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Future<LatLng> _getLatLngFromAddress(String address) async {
    try {
      RegExp regex = RegExp(r"LatLng\(([-+]?\d*\.?\d+), ([-+]?\d*\.?\d+)\)");
      Match match = regex.firstMatch(address)!;
      double latitude = double.parse(match.group(1)!);
      double longitude = double.parse(match.group(2)!);

      return LatLng(latitude, longitude);
    } catch (e) {
      print("Error fetching LatLng from address: $e");
      return const LatLng(0.0, 0.0);
    }
  }
}

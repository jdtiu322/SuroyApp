import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:suroyapp/reusable_widgets/reusable_widgets.dart';
import 'package:suroyapp/screens/payment_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:suroyapp/screens/address_screen.dart';
import 'package:suroyapp/screens/vehicle_info.dart';


class PostingDetails extends StatefulWidget {
  final String vehicleModel;
  final String modelYear;
  final String hostName;
  final String rentPrice;
  final String description;
  final String vImageURL;
  final String vehicleType;
  final String plateNum;
  final String numOfSeats;
  final String vehicleAddress;

  const PostingDetails({
    Key? key,
    required this.vehicleModel,
    required this.modelYear,
    required this.hostName,
    required this.rentPrice,
    required this.description,
    required this.vImageURL,
    required this.vehicleType,
    required this.plateNum,
    required this.numOfSeats,
    required this.vehicleAddress,
  }) : super(key: key);

  @override
  State<PostingDetails> createState() => _PostingDetailsState();
}

class _PostingDetailsState extends State<PostingDetails> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  DateTime currentDate = DateTime.now();
  String selectedDates = "Select Dates";
  String startMonth = "";
  String endMonth = "";
  late GoogleMapController mapController;
  List<Marker> _markers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.vImageURL,
                height: 220,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0, 20, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.vehicleModel,
                        style: GoogleFonts.poppins(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        "Pick-up at Address",
                        style: GoogleFonts.poppins(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.modelYear +
                            " Model - " +
                            widget.vehicleType +
                            " - " +
                            widget.numOfSeats +
                            " Seater",
                        style: GoogleFonts.poppins(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0, 20, 0),
                child: Container(
                  height: 130,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.description,
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0, 20, 0),
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: SvgPicture.asset(
                          'assets/vectors/profile-circle.svg',
                          width: 50,
                          height: 50,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "HOSTED BY",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.hostName,
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "WHERE YOU'LL PICK-UP YOUR VEHICLE",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: const Color(0xfff004aad),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              // Display the map below the latest Column
              SizedBox(
                height: 200, // Set the height according to your requirement
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    child: GoogleMap(
                      mapType: MapType.hybrid,
                      onMapCreated: (controller) {
                        setState(() {
                          mapController = controller;
                          _updateMapLocation(); // Trigger map update
                        });
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(0.0, 0.0), // Default location
                        zoom: 16.0,
                      ),
                      markers: Set.from(_markers),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 80,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: widget.rentPrice,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: ' per day',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        DateTimeRange? selectedDateRange =
                            await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2023),
                          lastDate: DateTime(2030),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData
                                  .dark(), // Customize the theme as needed
                              child: child!,
                            );
                          },
                        );

                        if (selectedDateRange != null) {
                          setState(() {
                            startDate = selectedDateRange.start;
                            endDate = selectedDateRange.end;
                            startMonth = DateFormat("MMM").format(startDate);
                            endMonth = DateFormat("MMM").format(endDate);
                            selectedDates = startMonth +
                                " " +
                                startDate.day.toString() +
                                " - " +
                                endMonth +
                                " " +
                                endDate.day.toString();
                          });
                        }
                      },
                      child: Text(
                        selectedDates,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    VehicleInformationWithDate vehicleInformationWithDate =
                        VehicleInformationWithDate(
                      startDate: startDate,
                      endDate: endDate,
                      vehicleDescrition: widget.description,
                      pickUpAddress: widget.vehicleAddress,
                      vehicleType: widget.vehicleType,
                      vehicleModel: widget.vehicleModel,
                      hostName: widget.hostName,
                      numSeats: widget.numOfSeats,
                      modelYear: widget.modelYear,
                      plateNumber: widget.plateNum,
                      imageUrl: widget.vImageURL,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentPage()),
                    );
                  },
                  child: reserveButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateMapLocation() async {
    LatLng location = await _getLatLngFromAddress(widget.vehicleAddress);
    mapController.animateCamera(CameraUpdate.newLatLng(location));
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('vehicleLocation'),
          position: location,
          infoWindow: InfoWindow(
            title: 'Vehicle Location',
            snippet: widget.vehicleAddress,
          ),
        ),
      );
    });
  }

  Future<LatLng> _getLatLngFromAddress(String address) async {
    try {
      // Extracting latitude and longitude from the string
      RegExp regex = RegExp(r"LatLng\(([-+]?\d*\.?\d+), ([-+]?\d*\.?\d+)\)");
      Match match = regex.firstMatch(address)!;
      double latitude = double.parse(match.group(1)!);
      double longitude = double.parse(match.group(2)!);

      return LatLng(latitude, longitude);
    } catch (e) {
      print("Error fetching LatLng from address: $e");
      // Return a default location in case of an error
      return const LatLng(0.0, 0.0);
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:suroyapp/reusable_widgets/reusable_widgets.dart';
import 'package:suroyapp/models/vehicle_info.dart';
import 'package:suroyapp/screens/vehicle_booking/cancellation_screen.dart';
import 'package:suroyapp/screens/complaints_screen.dart';
import 'package:suroyapp/screens/starting_page.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingDetailsScreen extends StatefulWidget {
  final BookingInfo bookingDetails;
  const BookingDetailsScreen({Key? key, required this.bookingDetails})
      : super(key: key);

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  TextEditingController reviewController = TextEditingController();
  int rating = 0;
  late String exactAddress;
  bool canPickUp = true;
  bool _canCancel = true;
  bool _pickedUp = false;
  bool _notPickedUp = true;
  bool pickedUp = true;
  String displayAddress = "";
  String renterID = "";
  late GoogleMapController mapController;
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _loadDisplayAddress();
    _updateMapLocation(); // Trigger map update
  }

  Future<void> _loadDisplayAddress() async {
    User? user = await FirebaseAuth.instance.currentUser;
    renterID = user!.uid;
    exactAddress = await getDisplayAddress(widget.bookingDetails.pickUpAddress);

    CollectionReference bookings =
        FirebaseFirestore.instance.collection('bookings');

    QuerySnapshot imissyoupo = await bookings
        .where('plateNumber', isEqualTo: widget.bookingDetails.plateNumber)
        .get();
    DocumentSnapshot renterdocs = imissyoupo.docs.first;

    String renterDocsID = renterdocs.id;

    DocumentSnapshot updatedDocument = await bookings.doc(renterDocsID).get();

    _pickedUp =
        (updatedDocument.data() as Map<String, dynamic>?)?['isPickedUp'];
    _notPickedUp =
        (updatedDocument.data() as Map<String, dynamic>?)?['isNotPickedUp'];
    setState(() {
      displayAddress = exactAddress;
    });
  }

  Future<void> _updateMapLocation() async {
    if (DateTime.now() == widget.bookingDetails.endDate) {
      canPickUp = true;
      _canCancel = false;
    }
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

  Future<void> createRenterStatusDocument() async {
    try {
      CollectionReference renterStatusCollection =
          FirebaseFirestore.instance.collection('renterStatus');
      await renterStatusCollection.add({
        'renterID': renterID,
        'hostName': widget.bookingDetails.hostName,
        'currentAddress': widget.bookingDetails.pickUpAddress,
        'plateNumber': widget.bookingDetails.plateNumber,
        'vehicleModel': widget.bookingDetails.vehicleModel,
        'vehicleType': widget.bookingDetails.vehicleType,
        'modelYear': widget.bookingDetails.modelYear,
        'imageUrl': widget.bookingDetails.imageUrl,
        'hostAge': widget.bookingDetails.hostAge,
        'hostMobileNumber': widget.bookingDetails.hostMobileNumber,
        'email': widget.bookingDetails.email,
      });
      print('RenterStatus document created successfully.');
    } catch (e) {
      print('Error creating RenterStatus document: $e');
    }
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
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  widget.bookingDetails.imageUrl,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth,
                ),
                Positioned(
                  top: 160,
                  left: 20,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.bookingDetails.vehicleModel,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: " ," + widget.bookingDetails.modelYear,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // Section for Not Picked-Up
          Visibility(
            visible: !_pickedUp && _notPickedUp,
            child: buildNotPickedUpSection(),
          ),
          // Section for Picked-Up
          Visibility(
            visible: _pickedUp,
            child: buildPickedUpSection(),
          ),
        ],
      ),
    );
  }

  Widget buildPickedUpSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).size.height * 0, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 3,
          ),
          Text(
            "Picked-up at Address",
            style:
                GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 5,
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              // Launch the email app with the host's email
                         // ignore: deprecated_member_use
                         launch("mailto:${widget.bookingDetails.email}");

                            },
                            child: Text(
                              widget.bookingDetails.email,
                              style: GoogleFonts.poppins(
                                color: Colors.blue,
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(
            height: 1,
          ),
          const Center(
              child: Image(
                  image: AssetImage('assets/images/booking-progress.gif'),
                  fit: BoxFit.fitHeight,
                  width: 400)),
          Divider(height: 5),
          Row(
            children: [
              Image.asset(
                'assets/images/suroy-logo.png',
                width: 40,
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Have any problems?",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Report an issue right now",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 50,
              ),
              GestureDetector(
                  onTap: () {
                    RenterStatus complaintDetails = RenterStatus(
                        renterID: renterID,
                        currentAddress: widget.bookingDetails.pickUpAddress,
                        startDate: widget.bookingDetails.startDate,
                        endDate: widget.bookingDetails.endDate,
                        hostName: widget.bookingDetails.hostName,
                        pickUpAddress: widget.bookingDetails.pickUpAddress,
                        plateNumber: widget.bookingDetails.plateNumber,
                        transactionAmount:
                            widget.bookingDetails.transactionAmount,
                        vehicleModel: widget.bookingDetails.vehicleModel,
                        vehicleType: widget.bookingDetails.vehicleType,
                        modelYear: widget.bookingDetails.modelYear,
                        imageUrl: widget.bookingDetails.imageUrl,
                        hostAge: widget.bookingDetails.hostAge,
                        hostMobileNumber:
                            widget.bookingDetails.hostMobileNumber,
                        email: widget.bookingDetails.email);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ComplaintsScreen(
                                  complaintDetails: complaintDetails,
                                )));
                  },
                  child:
                      SvgPicture.asset('assets/vectors/report.svg', width: 34))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(),
          Center(
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                  Color(0xfff004aad),
                )),
                onPressed: () async {
                  User? user = FirebaseAuth.instance.currentUser;
                  String renterID = user!.uid;

                  CollectionReference bookings =
                      FirebaseFirestore.instance.collection('bookings');

                  QuerySnapshot jomar = await bookings
                      .where('plateNumber',
                          isEqualTo: widget.bookingDetails.plateNumber)
                      .get();

                  DocumentSnapshot jumong = jomar.docs.first;

                  String renterDocsID = jumong.id;

                  await bookings.doc(renterDocsID).delete();

                  CollectionReference vehicleListings =
                      FirebaseFirestore.instance.collection('vehicleListings');

                  QuerySnapshot chuGwapo = await vehicleListings
                      .where('licensePlateNum',
                          isEqualTo: widget.bookingDetails.plateNumber)
                      .get();

                  DocumentSnapshot chuCutie = chuGwapo.docs.first;

                  String copyHostID = chuCutie.id;

                  await vehicleListings
                      .doc(copyHostID)
                      .update({'isAvailable': true});

                  await vehicleListings
                      .doc(copyHostID)
                      .update({'bookingStatus': "Available"});
                      

                  _showReviewDialog();
                },
                child: Text(
                  "Finish booking",
                  style: GoogleFonts.poppins(color: Colors.white),
                )),
          ),
        ],
      ),
    );
  }

  Widget buildNotPickedUpSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 550,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
              height: 5,
            ),
            Divider(
              height: 5,
            ),
            Text(
              "More About The Host",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
            SizedBox(
              height: 10,
            ),
            Center(
              child: Visibility(
                visible: _canCancel,
                child: ElevatedButton(
                  onPressed: () {
                    BookingInfo bookingInfo = BookingInfo(
                        startDate: widget.bookingDetails.startDate,
                        endDate: widget.bookingDetails.endDate,
                        hostName: widget.bookingDetails.hostName,
                        pickUpAddress: widget.bookingDetails.pickUpAddress,
                        plateNumber: widget.bookingDetails.plateNumber,
                        transactionAmount:
                            widget.bookingDetails.transactionAmount,
                        vehicleModel: widget.bookingDetails.vehicleModel,
                        vehicleType: widget.bookingDetails.vehicleType,
                        modelYear: widget.bookingDetails.modelYear,
                        imageUrl: widget.bookingDetails.imageUrl,
                        hostAge: widget.bookingDetails.hostAge,
                        hostMobileNumber:
                            widget.bookingDetails.hostMobileNumber,
                        email: widget.bookingDetails.email,
                        isNotPickedUp: widget.bookingDetails.isNotPickedUp,
                        isPickedUp: widget.bookingDetails.isPickedUp);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CancellationPage(
                          bookingInfo: bookingInfo,
                        ),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xfff004aad),
                    ),
                  ),
                  child: Text(
                    "Cancel Reservation",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Visibility(
                visible: canPickUp,
                child: ElevatedButton(
                  onPressed: () async {
                    BookingInfo bookingDetails = BookingInfo(
                      startDate: widget.bookingDetails.startDate,
                      endDate: widget.bookingDetails.endDate,
                      hostName: widget.bookingDetails.hostName,
                      pickUpAddress: widget.bookingDetails.pickUpAddress,
                      plateNumber: widget.bookingDetails.plateNumber,
                      transactionAmount:
                          widget.bookingDetails.transactionAmount,
                      vehicleModel: widget.bookingDetails.vehicleModel,
                      vehicleType: widget.bookingDetails.vehicleType,
                      modelYear: widget.bookingDetails.modelYear,
                      imageUrl: widget.bookingDetails.imageUrl,
                      hostAge: widget.bookingDetails.hostAge,
                      hostMobileNumber: widget.bookingDetails.hostMobileNumber,
                      email: widget.bookingDetails.email,
                      isNotPickedUp: _notPickedUp,
                      isPickedUp: _pickedUp,
                    );
                    User? user = FirebaseAuth.instance.currentUser;
                    String renterID = user!.uid;

                    CollectionReference bookings =
                        FirebaseFirestore.instance.collection('bookings');

                    QuerySnapshot imissyoupo = await bookings
                        .where('plateNumber',
                            isEqualTo: widget.bookingDetails.plateNumber)
                        .get();
                    DocumentSnapshot sanamissmodinako = imissyoupo.docs.first;

                    String renterDocsID = sanamissmodinako.id;

                    await bookings.doc(renterDocsID).update({
                      'isPickedUp': true,
                    });

                    await bookings.doc(renterDocsID).update({
                      'isNotPickedUp': false,
                    });

                    // Show a dialog after updating the document
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Vehicle Picked-Up',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Text(
                            'Vehicle has been Picked-Up! Enjoy your trip!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BookingDetailsScreen(
                                                  bookingDetails:
                                                      bookingDetails)));
                                },
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: Colors.white,
                          elevation: 5,
                        );
                      },
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xfff004aad),
                    ),
                  ),
                  child: Text(
                    "Pick-Up Vehicle",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _submitRating() async {
    // Firebase Collection Reference
    CollectionReference ratings =
        FirebaseFirestore.instance.collection('ratings');

    // Creating a new document with auto-generated ID
    await ratings.add({
      'renterID': renterID,
      'ratings': rating,
      'hostEmail': widget.bookingDetails.email,
      'review': reviewController.text,
      'vehicleModel': widget.bookingDetails.vehicleModel,
      'modelYear': widget.bookingDetails.modelYear,
      'vehicleType': widget.bookingDetails.vehicleType,
      'imageUrl': widget.bookingDetails.imageUrl,
    });

    // Optionally, you can update UI or show a confirmation message
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

  void _showReviewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Rate the Host"),
          content: Column(
            children: [
              Text("Select a star rating:"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        rating = index + 1;
                      });
                    },
                    child: Icon(
                      Icons.star,
                      size: 40,
                      color: index < rating ? Colors.grey : Colors.yellow,
                    ),
                  );
                }),
              ),
              TextField(
                controller: reviewController,
                decoration: InputDecoration(labelText: "Write a review"),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _submitRating();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StartingPage()));
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }
}

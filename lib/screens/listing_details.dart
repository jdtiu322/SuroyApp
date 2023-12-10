import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:suroyapp/reusable_widgets/reusable_widgets.dart';
import 'package:suroyapp/models/vehicle_info.dart';
import 'package:suroyapp/screens/listing_removal_screen.dart';
import 'package:suroyapp/screens/location_tracking_screen.dart';

class ListingDetails extends StatefulWidget {
  final FinalVehicleInfo listingInfo;

  const ListingDetails({Key? key, required this.listingInfo}) : super(key: key);

  @override
  State<ListingDetails> createState() => _ListingDetailsState();
}

class _ListingDetailsState extends State<ListingDetails> {
  String displayAddress = "";
  String displayBookingStatus = "";
  bool available = false;
  bool notAvailable = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    String address = await getDisplayAddress(widget.listingInfo.pickUpAddress);
    String bookingStatus = "";
    if (widget.listingInfo.bookingStatus == "Booked") {
      notAvailable = true;
    } else if (widget.listingInfo.bookingStatus == "Available") {
      available = true;
    }

    setState(() {
      displayAddress = address;
      displayBookingStatus = widget.listingInfo.bookingStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.listingInfo.vehicleImageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.listingInfo.vehicleModel,
                  style: GoogleFonts.poppins(
                      fontSize: 28, fontWeight: FontWeight.w600),
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors
                          .black, // You can set the color as per your design
                    ),
                    children: [
                      TextSpan(text: "Vehicle owned by "),
                      TextSpan(
                          text: widget.listingInfo.hostName,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          )),
                    ],
                  ),
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.listingInfo.vehicleDescription,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.justify,
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.listingInfo.modelYear + " Model",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Divider(),
                Text(
                  "Pick-Up at " + displayAddress,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  "Exact address is only revealed to renter after reservation is confirmed",
                  style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.shade400),
                ),
                Divider(),
                Text(
                  widget.listingInfo.numSeats + " seater",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Divider(),
                Text(
                  "Plate Number: " + widget.listingInfo.plateNumber,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Divider(),
                Text(
                  "Listing Status: " + displayBookingStatus,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Divider(),
                Visibility(
                  visible: available,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                      Color(0xfff004aad),
                    )),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListingRemovalPage()));
                    },
                    child: Text("Remove Listing",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white,
                        )),
                  ),
                ),
                Visibility(
                    visible: notAvailable,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                        Color(0xfff004aad),
                      )),
                      onPressed: () {
                        FinalVehicleInfo listingInfo = FinalVehicleInfo(
                            isAvailable: widget.listingInfo.isAvailable,
                            rentPrice: widget.listingInfo.rentPrice,
                            bookingStatus: widget.listingInfo.bookingStatus,
                            vehicleDescription:
                                widget.listingInfo.vehicleDescription,
                            pickUpAddress: widget.listingInfo.pickUpAddress,
                            vehicleType: widget.listingInfo.vehicleType,
                            vehicleModel: widget.listingInfo.vehicleModel,
                            hostName: widget.listingInfo.hostName,
                            numSeats: widget.listingInfo.numSeats,
                            modelYear: widget.listingInfo.modelYear,
                            plateNumber: widget.listingInfo.plateNumber,
                            vehicleImageUrl: widget.listingInfo.vehicleImageUrl,
                            certificateImageUrl: "",
                            hostAge: widget.listingInfo.hostAge,
                            hostMobileNumber:
                                widget.listingInfo.hostMobileNumber,
                            email: widget.listingInfo.email);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LocationTracker(listingInfo: listingInfo)));
                      },
                      child: Text("Track Vehicle Location",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white,
                          )),
                    )),             
              ],
            ),
          ),
        ),
      ),
    );
  }
}

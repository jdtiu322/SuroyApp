import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suroyapp/screens/pricing_screen.dart';
import 'package:suroyapp/screens/vehicle_info.dart';

class DescriptionRegistration extends StatefulWidget {
  final VehicleInformation2 vehicleInfo;

  const DescriptionRegistration({Key? key, required this.vehicleInfo})
      : super(key: key);

  @override
  State<DescriptionRegistration> createState() =>
      _DescriptionRegistrationState();
}

class _DescriptionRegistrationState extends State<DescriptionRegistration> {
  TextEditingController description = TextEditingController();
  String inputText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0, 20, 0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Give a short description",
                  style: GoogleFonts.poppins(
                      fontSize: 24, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Share why your vehicle is exceptional. The shorter the better!",
                  style: GoogleFonts.poppins(
                      fontSize: 16, color: Colors.grey.shade500),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 200,
                  child: TextField(
                    controller: description,
                    maxLines: 7, // Adjust the number of lines as needed
                    maxLength: 305, // Set the maximum number of words
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 20.0)),
                      labelText: 'Description',
                    ),
                    style: GoogleFonts.poppins(fontSize: 14),
                    onChanged: (value) {
                      setState(() {
                        inputText = value;
                      });
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Create an instance of VehicleInformation3
                    VehicleInformation3 vehicleInfo3 = VehicleInformation3(
                      vehicleDescription: inputText,
                      pickUpAddress: widget.vehicleInfo.pickUpAddress,
                      vehicleType: widget.vehicleInfo.vehicleType,
                      vehicleModel: widget.vehicleInfo.vehicleModel,
                      hostName: widget.vehicleInfo.hostName,
                      numSeats: widget.vehicleInfo.numSeats,
                      modelYear: widget.vehicleInfo.modelYear,
                      plateNumber: widget.vehicleInfo.plateNumber,
                      imageUrl: widget.vehicleInfo.imageUrl,
                    );

                    // Navigate to the PriceRegistration page and pass the information
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PriceRegistration(
                          vehicleInfo: vehicleInfo3,
                        ),
                      ),
                    );
                  },
                  child: Text("Next"),
                )
              ]),
        ),
      ),
    );
  }
}

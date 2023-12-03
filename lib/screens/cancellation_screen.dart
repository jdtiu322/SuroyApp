import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:suroyapp/reusable_widgets/vehicle_info.dart';

class CancellationPage extends StatefulWidget {
  final BookingInfo bookingInfo;
  const CancellationPage({Key? key, required this.bookingInfo})
      : super(key: key);

  @override
  State<CancellationPage> createState() => _CancellationPageState();
}

class _CancellationPageState extends State<CancellationPage> {
  String startMonth = "";
  String endMonth = "";

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _convertMonth();
    // Other initialization tasks can be added here
  }

  Future<void> _convertMonth() async {
    startMonth = DateFormat("MMM").format(widget.bookingInfo.startDate);
    endMonth = DateFormat("MMM").format(widget.bookingInfo.endDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Can I cancel my reservation?",
          style: GoogleFonts.roboto(fontSize: 16),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(
          child: Column(children: [
            Container(
              height: 80,
              color: Colors.grey.shade400,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        widget.bookingInfo.vehicleModel,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Text(
                      startMonth +
                          " " +
                          widget.bookingInfo.startDate.day.toString() +
                          " - " +
                          endMonth +
                          " " +
                          widget.bookingInfo.endDate.day.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Tell us your reason for cancellation by choosing one of the options below.",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      "You can cancel a reservation for free 48 Hours after it has been placed. Further cancellations will be charged",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

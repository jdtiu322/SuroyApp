import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:suroyapp/reusable_widgets/reusable_widgets.dart';
import 'package:suroyapp/models/vehicle_info.dart';

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
  bool? _changedPlans = false;
  bool? _betterDeal = false;
  bool? _unforeseen = false;
  bool? _flight = false;
  bool? _other = false;
  bool _isFree = false;
  bool _isNotFree = false;
  int dateDifference = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _convertMonth();
  }

  Future<void> _convertMonth() async {
    startMonth = DateFormat("MMM").format(widget.bookingInfo.startDate);
    endMonth = DateFormat("MMM").format(widget.bookingInfo.endDate);
    dateDifference =
        calculateTotalDays(widget.bookingInfo.startDate, DateTime.now());

    if (dateDifference <= 2) {
      _isFree = true;
    } else {
      _isNotFree = true;
    }
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
      body: ListView(children: [
        Container(
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
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "You can cancel a reservation for free 48 Hours after it has been placed. Further cancellations will be charged",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Why do you want to cancel your reservation?",
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 5,
                      ),
                      CheckboxListTile(
                        title: Text("1. Change in Plans"),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _changedPlans,
                        onChanged: (bool? value) {
                          setState(() {
                            _changedPlans = value;
                            _betterDeal = false;
                            _unforeseen = false;
                            _flight = false;
                            _other = false;
                          });
                        },
                      ),
                      Divider(
                        height: 5,
                      ),
                      CheckboxListTile(
                        title: Text("2. Better Deal Elsewhere"),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _betterDeal,
                        onChanged: (bool? value) {
                          setState(() {
                            _betterDeal = value;
                            _changedPlans = false;
                            _unforeseen = false;
                            _flight = false;
                            _other = false;
                          });
                        },
                      ),
                      Divider(
                        height: 5,
                      ),
                      CheckboxListTile(
                        title: Text("3. Unforeseen Circumstances"),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _unforeseen,
                        onChanged: (bool? value) {
                          setState(() {
                            _unforeseen = value;
                            _changedPlans = false;
                            _betterDeal = false;
                            _flight = false;
                            _other = false;
                          });
                        },
                      ),
                      Divider(
                        height: 5,
                      ),
                      CheckboxListTile(
                        title: Text("4. Flight was delayed/cancelled"),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _flight,
                        onChanged: (bool? value) {
                          setState(() {
                            _flight = value;
                            _changedPlans = false;
                            _betterDeal = false;
                            _unforeseen = false;
                            _other = false;
                          });
                        },
                      ),
                      Divider(
                        height: 5,
                      ),
                      CheckboxListTile(
                        title: Text("5. Others"),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _other,
                        onChanged: (bool? value) {
                          setState(() {
                            _other = value;
                            _changedPlans = false;
                            _betterDeal = false;
                            _unforeseen = false;
                            _flight = false;
                          });
                        },
                      ),
                      Divider(
                        height: 5,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: _isFree &&
                            (_changedPlans == true ||
                                _betterDeal == true ||
                                _unforeseen == true ||
                                _flight == true ||
                                _other == true),
                        child: Container(
                          height: 120,
                          child: Column(
                            children: [
                              Text(
                                "Cancellation is Free",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Learn more about our",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: " cancellation policy",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              cancellationButton(context),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _isNotFree,
                        child: Container(
                          height: 30,
                          child: Text("test 2"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

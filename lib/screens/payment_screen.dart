import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:intl/intl.dart';
import 'package:pay/pay.dart';
import 'package:suroyapp/payment_configurations.dart';
import 'package:suroyapp/screens/vehicle_info.dart';
import 'package:suroyapp/reusable_widgets/reusable_widgets.dart';

class PaymentPage extends StatefulWidget {
  final VehicleInformationWithDate vehicleInfo;

  const PaymentPage({Key? key, required this.vehicleInfo}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String startMonth = "";
  String endMonth = "";
  late GooglePayButton googlePayButton;
  String displayAddress = "";
  String displayInitialPrice = "";
  String displayFinalBasePrice = "";
  String displayDaysCount = "";
  String displayServiceFee = "";
  String displayTotal = "";
  double total = 0.0;
  double serviceFee = 0.0;
  int daysCount = 0;
  double initialBasePrice = 0.0;
  double finalBasePrice = 0.0;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    startMonth = DateFormat("MMM").format(widget.vehicleInfo.startDate);
    endMonth = DateFormat("MMM").format(widget.vehicleInfo.endDate);
    String address = await getDisplayAddress(widget.vehicleInfo.pickUpAddress);
    daysCount = calculateTotalDays(
        widget.vehicleInfo.startDate, widget.vehicleInfo.endDate);
    displayDaysCount = daysCount.toString();
    displayInitialPrice = widget.vehicleInfo.rentPrice;
    initialBasePrice = double.tryParse(displayInitialPrice) ?? 0;
    finalBasePrice = initialBasePrice * daysCount;
    displayFinalBasePrice = finalBasePrice.toStringAsFixed(2);
    serviceFee = finalBasePrice * 0.15;
    displayServiceFee = serviceFee.toStringAsFixed(2);
    total = finalBasePrice + serviceFee;
    displayTotal = total.toStringAsFixed(2);

    setState(() {
      displayAddress = address;
      googlePayButton = GooglePayButton(
        paymentConfiguration:
            PaymentConfiguration.fromJsonString(defaultGooglePay),
        paymentItems: [
          PaymentItem(
            label: 'Total',
            amount: displayTotal,
            status: PaymentItemStatus.final_price,
          )
        ],
        onPaymentResult: (result) => debugPrint('Payment Result $result'),
        loadingIndicator: const Center(child: CircularProgressIndicator()),
        width: double.infinity,
        type: GooglePayButtonType.book,
        margin: const EdgeInsets.only(top: 15.0),
      );
    });
  }

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
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        widget.vehicleInfo.imageUrl,
                        width: 150,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.vehicleInfo.vehicleType,
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          widget.vehicleInfo.vehicleModel,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(widget.vehicleInfo.modelYear),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                height: 15,
              ),
              Container(
                height: 150,
                child: Row(
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your booking details",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Dates",
                            style: GoogleFonts.poppins(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(startMonth +
                                  " " +
                                  widget.vehicleInfo.startDate.day.toString() +
                                  " - " +
                                  endMonth +
                                  " " +
                                  widget.vehicleInfo.endDate.day.toString()),
                              SizedBox(
                                width: 180,
                              ),
                              Text(
                                "Change Date",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Vehicle Location",
                              style: GoogleFonts.poppins(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                          Text(displayAddress),
                        ]),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                height: 15,
              ),
              Container(
                height: 110,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Pricing Details",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "PHP" +
                              displayInitialPrice +
                              " X " +
                              displayDaysCount +
                              " days",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        // SizedBox(
                        //   width: 150,
                        // ),
                        Text(
                          "PHP" + displayFinalBasePrice,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Suroy Service Fee",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        // SizedBox(
                        //   width: 150,
                        // ),
                        Text(
                          "PHP" + displayServiceFee,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Grand Total",
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        // SizedBox(
                        //   width: 150,
                        // ),
                        Text(
                          "PHP" + displayTotal,
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                height: 15,
              ),
              Container(
                height: 65,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cancellation Policy",
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                        "Cancellation is free for the first 24hrs. Any cancellation requests will be reviewed and will have a cancellation fee.",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                height: 15,
              ),
              Container(
                height: 120,
                color: Colors.blue,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "General Rules",
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          "We genuinely ask every renter to follow general simple rules to provide a great experience for all parties included",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                          )),
                          SizedBox(height: 5,),
                      Text(
                          "- Follow the Host's Vehicle Rules",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                          )),
                          Text(
                          "- Treat the vehicle like your own",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                          )),
                    ]),
              ),
              Container(
                height: 100,
                color: Colors.purple,
                child: Center(
                  child: GestureDetector(
                    onTap: (){},
                    child: googlePayButton
                    ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

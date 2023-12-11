import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pay/pay.dart';
import 'package:suroyapp/payment_configurations.dart';
import 'package:suroyapp/screens/vehicle_booking/bookings_screen.dart';
import 'package:suroyapp/models/vehicle_info.dart';
import 'package:suroyapp/reusable_widgets/reusable_widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
  final VehicleInformationWithDate vehicleInfo;

  const PaymentPage({Key? key, required this.vehicleInfo}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late bool _isLoading;
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
  late FirebaseMessaging _firebaseMessaging;

  @override
  void initState() {
    _isLoading = true;
    _firebaseMessaging = FirebaseMessaging.instance;
    super.initState();
    initialize();
  }

Future<void> sendNotificationToHost(String hostId, String notificationTitle, String notificationBody) async {
  // Get FCM token for the specified host
  String hostFCMToken = await getHostFCMToken(hostId);

  // FCM server endpoint
  final String fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';

  // Server Key from Firebase Consolef
  final String serverKey = 'AAAA4u2dvu0:APA91bF0x0w8ZKxuR4u_F_6551zSebkhCMbhnrzYSWWIYg8BfvpIX4bRnzKNHFNUv3nKKWIc6QNEPsBezTo0N_7YPl6B2QM7URnZC2slEnoHkKXU0CswYYFD3ht_U_v9S7_Tg9H6YnV6';

  // Create the notification payload
  Map<String, dynamic> notification = {
    'to': hostFCMToken,
    'notification': {
      'title': notificationTitle,
      'body': notificationBody,
    },
    'data': {
      // Optional data payload
      'key1': 'value1',
      'key2': 'value2',
    },
  };

  // Encode the payload to JSON
  String jsonPayload = jsonEncode(notification);

  // Send the notification to FCM server
final response = await http.post(
  Uri.parse(fcmEndpoint),
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey',
  },
  body: jsonPayload,
);

print('FCM Response: ${response.body}');


}

  Future<String> getHostFCMToken(String hostId) async {

    DocumentSnapshot hostSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(hostId).get();

    return hostSnapshot['fcmToken'] ?? '';
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
        onPaymentResult: (result) async {
          if (result != null) {
            try {
              User? user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                await FirebaseFirestore.instance.collection('bookings').add({
                  'renterID': user.uid,
                  'transactionAmount': displayTotal,
                  'description': widget.vehicleInfo.vehicleDescription,
                  'startDate': widget.vehicleInfo.startDate,
                  'endDate': widget.vehicleInfo.endDate,
                  'pickUpAddress': widget.vehicleInfo.pickUpAddress,
                  'vehicleType': widget.vehicleInfo.vehicleType,
                  'vehicleModel': widget.vehicleInfo.vehicleModel,
                  'plateNumber': widget.vehicleInfo.plateNumber,
                  'imageUrl': widget.vehicleInfo.vehicleImageUrl,
                  'hostId': widget.vehicleInfo.hostId,
                  'hostName': widget.vehicleInfo.hostName,
                  'modelYear': widget.vehicleInfo.modelYear,
                  'hostAge': widget.vehicleInfo.hostAge,
                  'hostMobileNumber': widget.vehicleInfo.hostMobileNumber,
                  'email': widget.vehicleInfo.email,
                  'isNotPickedUp': true,
                  'isPickedUp': false,
                });

                CollectionReference vehicleListings =
                    FirebaseFirestore.instance.collection('vehicleListings');

                QuerySnapshot baliknapls = await vehicleListings
                    .where('licensePlateNum',
                        isEqualTo: widget.vehicleInfo.plateNumber)
                    .get();
                DocumentSnapshot huhuplsna = baliknapls.docs.first;

                String vehicleListingDocsID = huhuplsna.id;

                await vehicleListings.doc(vehicleListingDocsID).update({
                  'isAvailable': false,
                });

                await vehicleListings.doc(vehicleListingDocsID).update({
                  'bookingStatus': "Booked",
                });
                await sendNotificationToHost(widget.vehicleInfo.hostId, "Vehicle has been booked!",
                 "One of your vehicle listings has been booked");
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => BookingsScreen()));
              }
            } catch (error) {
              print("Invalid account details ${error.toString()}");
            }
          }
        },
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
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0, 20, 0),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          widget.vehicleInfo.vehicleImageUrl,
                          width: 150,
                        ),
                      ),
                      const SizedBox(
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
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    height: 15,
                  ),
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
                        const SizedBox(
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
                            Text(
                                "$startMonth ${widget.vehicleInfo.startDate.day} - $endMonth ${widget.vehicleInfo.endDate.day}"),
                            const SizedBox(
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
                        const SizedBox(
                          height: 20,
                        ),
                        Text("Vehicle Location",
                            style: GoogleFonts.poppins(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                        Text(displayAddress),
                      ]),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    height: 15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pricing Details",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(
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
                      const SizedBox(
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
                      const SizedBox(
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
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    height: 15,
                  ),
                  Column(
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
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    height: 15,
                  ),
                  Column(
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
                        SizedBox(
                          height: 5,
                        ),
                        Text("- Follow the Host's Vehicle Rules",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                            )),
                        Text("- Treat the vehicle like your own",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                            )),
                      ]),
                  Center(
                    child: googlePayButton,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
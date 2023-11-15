import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suroyapp/reusable_widgets/reusable_widgets.dart';
import 'package:suroyapp/utils/color_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  _ApplicationState() {
    selectedVehicle = vehicleList[0];
  }
  final vehicleList = [
    "Sedan",
    "SUV",
    "Van",
    "Minivan",
    "Pick-up Truck",
    "Crossover"
  ];

  TextEditingController vehicleModel = TextEditingController();
  TextEditingController modelYear = TextEditingController();
  TextEditingController plateNumber = TextEditingController();

  String? selectedVehicle = "";

  String vImageURL = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0, 20, 0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Suroy your Vehicle!",
                  style: GoogleFonts.poppins(
                      fontSize: 32, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: DropdownButtonFormField(
                    value: selectedVehicle,
                    items: vehicleList.map((e) {
                      return DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedVehicle = val as String;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xfFF004AAD),
                    ),
                    decoration: InputDecoration(
                      labelText: "Vehicle Type",
                      prefixIcon: Icon(
                        Icons.car_rental,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                reusableTextField("Vehicle model", Icons.car_repair_sharp,
                    false, vehicleModel),
                SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Model Year", Icons.calendar_month, false, modelYear),
                SizedBox(
                  height: 20,
                ),
                reusableTextField("License Plate No.", Icons.numbers_rounded,
                    false, plateNumber),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        IconButton(
                            onPressed: () async {
                              ImagePicker imagePicker = ImagePicker();
                              XFile? file = await imagePicker.pickImage(
                                  source: ImageSource.camera);
                              print('${file?.path}');

                              if (file == null) return;

                              String vImageFileName = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString()+".png";

                              Reference referenceRoot =
                                  FirebaseStorage.instance.ref();
                              Reference referenceImageDir =
                                  referenceRoot.child('vehicleImages');
                              Reference referenceImageToUpload =
                                  referenceImageDir.child(vImageFileName);

                              try {
                                await referenceImageToUpload
                                    .putFile(File(file!.path));
                                vImageURL =  await referenceImageToUpload.getDownloadURL();
                              } catch (error) {

                              }
                            },
                            icon: SvgPicture.asset(
                                'assets/vectors/add-image.svg'),
                            iconSize: 120),
                        Text(
                          "Add Vehicle Image",
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.grey),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

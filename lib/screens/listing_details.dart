import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suroyapp/reusable_widgets/vehicle_info.dart';

class ListingDetails extends StatefulWidget {
  final BookingInfo listingInfo;

  const ListingDetails({Key? key, required this.listingInfo}) : super(key: key);

  @override
  State<ListingDetails> createState() => _ListingDetailsState();
}

class _ListingDetailsState extends State<ListingDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(widget.listingInfo.imageUrl,
                fit: BoxFit.fill,),
              ), 
              SizedBox(height: 10,),
              Text(widget.listingInfo.vehicleModel,
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w600
              ),),
              Divider(),
              SizedBox(height: 10,),
              Text("Vehicle owned by " + widget.listingInfo.hostName,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),),
              Divider(),
                SizedBox(height: 10,),
              Text("",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),),
              Divider(),
              
            ],
          ),
        ),
      ),
    );
  }
}

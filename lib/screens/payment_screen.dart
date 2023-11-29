import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0 , 20, 0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 30,),
              Container(
                height: 120,
                color: Colors.blue,
                child: Row(
                  children: [

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
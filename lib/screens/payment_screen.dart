import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage>{
    var googlePayButton = GooglePayButton(
      // paymentConfiguration: ,
    onPaymentResult: (result) => debugPrint('Paymenr Result $result'),
    loadingIndicator: const Center(child: CircularProgressIndicator()), 
    paymentItems: [
      PaymentItem(
        label: 'Total',
        amount: '1,000',
        status: PaymentItemStatus.final_price
      )
    ],
    width: double.infinity,
    margin: const EdgeInsets.only(top: 15.0),
  );
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
                    Center(
                      child: googlePayButton,
                    )
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
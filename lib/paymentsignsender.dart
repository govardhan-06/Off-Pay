import 'package:flutter/material.dart';
import 'package:offpay/home_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'globals.dart';

class Paymentsignsender extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Signature QR CODE"),
      ),
      body: Center(
        child: paymentsign != null && paymentsign!.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImageView(
                    data: paymentsign!,
                    size: 300,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Scan the QR code to confirm the Payment",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                       ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text('Payment Successful'), backgroundColor: Color.fromRGBO(55, 255, 0, 0.992),),
              );
                    },
                    child: Text("EXIT"),
                  ),
                ],
              )
            : Text(
                "No signature available, payment failed try again",
                style: TextStyle(fontSize: 16),
              ),
      ),
    );
  }
}

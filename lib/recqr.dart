import 'package:flutter/material.dart';
import 'package:offpay/scantrans.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'globals.dart';

class RecQr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recieve Payment"),
      ),
      body: Center(
        child: recPublicKey != null && recPublicKey!.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImageView(
                    data: recPublicKey!,
                    size: 300,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Scan the QR code to proceed with the transaction",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to paymentSignSender() page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => scanTrans()),
                      );
                    },
                    child: Text("Scan Transaction"),
                  ),
                ],
              )
            : Text(
                "An Error Occured",
                style: TextStyle(fontSize: 16),
              ),
      ),
    );
  }
  
}

import 'package:flutter/material.dart';
import 'package:offpay/scansign.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'globals.dart';

class RecFalconKey extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Falcon key"),
      ),
      body: Center(
        child: recPublicKey != null && recPublicKey!.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImageView(
                    data: falconpublickey!,
                    size: 300,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Scan the QR code for Falcon Key",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to paymentSignSender() page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ScanSign()),
                      );
                    },
                    child: Text("Scan Transaction Details"),
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

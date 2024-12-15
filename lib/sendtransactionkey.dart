import 'package:flutter/material.dart';
import 'package:offpay/paymentsignsender.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'globals.dart';

class sendTransactionKey extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction QR Code"),
      ),
      body: Center(
        child: transactionData != null && transactionData!.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImageView(
                    data: transactionData!,
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
                        MaterialPageRoute(builder: (context) => Paymentsignsender()),
                      );
                    },
                    child: Text("Proceed"),
                  ),
                ],
              )
            : Text(
                "No transaction data available",
                style: TextStyle(fontSize: 16),
              ),
      ),
    );
  }
  
}

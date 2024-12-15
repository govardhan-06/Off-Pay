import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:offpay/globals.dart';
import 'package:offpay/home_page.dart';
import 'package:offpay/payqr.dart';
import 'package:offpay/scansign.dart';

class scanTrans extends StatelessWidget{

  String? scannedTrans="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Scan Transaction details',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF202020),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomePage()),
            );
          },
        ),
      ),
      body: Center(
        child: MobileScanner(
        onDetect: (capture) {
  final List<Barcode> barcodes = capture.barcodes;
  for (final barcode in barcodes) {
    final rawval = barcode.rawValue;
    if (rawval != null && rawval.startsWith("off-")) {
      print(rawval);
      print(barcode.rawValue);
      scannedTrans = rawval.replaceFirst("off-", "");

      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirm Transaction"),
            content: Text("Do you want to proceed to the next page to confirm the transaction?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // If "Yes" is pressed, navigate to ScanSign page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ScanSign()),
                  );
                },
                child: Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  // If "No" is pressed, just close the dialog
                  Navigator.pop(context);
                },
                child: Text("No"),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Show valid OFF-PAY QR code')),
      );
    }
  }
},
  
          
        ),
      ),
    );
  }
}


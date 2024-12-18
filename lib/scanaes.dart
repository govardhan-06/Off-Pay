import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:offpay/globals.dart';
import 'package:offpay/home_page.dart';
import 'package:offpay/utils/scanfalcon.dart';

class ScanAES extends StatelessWidget{
  String? scannedSign = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Scan AES Key',
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
              if(rawval != null)
                print(rawval);
                print(barcode.rawValue);
                 Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => ScanFalcon()),
            );
            }
          },
        ),
      ),
    );
  }
}


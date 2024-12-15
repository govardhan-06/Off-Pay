import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:offpay/globals.dart';
import 'package:offpay/home_page.dart';
import 'package:offpay/payqr.dart';

class sendQr extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Scan QR',
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
              if(rawval != null && rawval.startsWith("off-")){
                print(rawval);
                print(barcode.rawValue);
                recPublicKey = rawval.replaceFirst("off-", "");
                 Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => PayQR()),
            );
                }else{
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


import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:offpay/globals.dart';
import 'package:offpay/home_page.dart';

class ScanFalcon extends StatelessWidget{
  String? scannedSign = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Scan Falcon Public Key',
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
                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Payment Recieved Successfully'), backgroundColor: Colors.green,),
              );
                 Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomePage()),
                
            );
            }
          },
        ),
      ),
    );
  }
}


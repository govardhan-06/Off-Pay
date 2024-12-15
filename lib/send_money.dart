import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:offpay/connectionpage.dart';
import 'package:offpay/home_page.dart';

class SendMoney extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Send Money',
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
                Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => ConnectionPage()),
            );
              print(barcode.rawValue);}else{
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

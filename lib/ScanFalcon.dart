import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:offpay/globals.dart';
import 'package:offpay/home_page.dart';
import 'package:offpay/payqr.dart';

class ScanFalcon extends StatefulWidget {
  @override
  _ScanFalconState createState() => _ScanFalconState();
}

class _ScanFalconState extends State<ScanFalcon> {
  MobileScannerController scannerController = MobileScannerController();
  bool isScanned = false; // To track if a QR code has already been processed

  void falconkeyset() {
    falconpublickey = "123";
  }

  @override
  void dispose() {
    scannerController.dispose(); // Properly dispose of the scanner
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Scan Falcon',
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
          controller: scannerController, // Use the controller here
          onDetect: (capture) {
            if (!isScanned) {
              isScanned = true; // Mark as scanned to prevent duplicate processing
              scannerController.stop(); // Stop the scanner
              falconkeyset();

              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final rawval = barcode.rawValue;
                if (rawval != null && rawval.startsWith("off-")) {
                  print(rawval);
                  print(barcode.rawValue);
                  falconpublickey = rawval.replaceFirst("off-", "");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => PayQR()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Show valid OFF-PAY QR code')),
                  );
                  isScanned = false; // Allow scanning again if invalid code is detected
                  scannerController.start(); // Restart the scanner
                }
              }
            }
          },
        ),
      ),
    );
  }
}

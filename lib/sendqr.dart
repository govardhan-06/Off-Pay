import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:offpay/globals.dart';
import 'package:offpay/home_page.dart';
import 'package:offpay/payqr.dart';
import 'package:offpay/scanfalcon.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 

class sendQr extends StatefulWidget {
  @override
  _sendQrState createState() => _sendQrState();
}

class _sendQrState extends State<sendQr> {
  bool _isScanning = true; 
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
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
          onDetect: (capture) async{
            if (!_isScanning) return; // Prevent further scanning if already stopped

            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              final rawval = barcode.rawValue;
                recPublicKey = rawval;
                await _secureStorage.write(key: 'recPublicKey', value: recPublicKey);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Confirm Transaction"),
                      content: Text("Do you want to proceed to the next page to confirm the transaction?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ScanFalcon()),
                            );
                          },
                          child: Text("Yes"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              _isScanning = true; // Resume scanning if "No" is pressed
                            });
                          },
                          child: Text("No"),
                        ),
                      ],
                    );
                  },
                );
              
            }
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import the package
import 'package:offpay/recfalconkey.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'globals.dart';

class RecQr extends StatefulWidget {
  @override
  _RecQrState createState() => _RecQrState();
}

class _RecQrState extends State<RecQr> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  String? recPublicKey;  // Variable to store public key

  @override
  void initState() {
    super.initState();
    _loadPublicKey();  // Load public key when the widget is first created
  }

  // Method to read the public key from secure storage
  Future<void> _loadPublicKey() async {
    String? publicKey = await _secureStorage.read(key: 'publickeyhex');
    setState(() {
      recPublicKey = publicKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receive Payment"),
      ),
      body: Center(
        child: recPublicKey != null && recPublicKey!.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImageView(
                    data: recPublicKey!,
                    size: 350,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Scan this QR code",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to paymentSignSender() page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RecFalconKey()),
                      );
                    },
                    child: Text("Scan Transaction"),
                  ),
                ],
              )
            : Text(
                "An Error Occurred",
                style: TextStyle(fontSize: 16),
              ),
      ),
    );
  }
}

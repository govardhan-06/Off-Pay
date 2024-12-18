import 'package:flutter/material.dart';
import 'package:offpay/home_page.dart';
import 'package:offpay/recfalconkey.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'globals.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AES extends StatefulWidget {
  @override
  _AESState createState() => _AESState();
}

class _AESState extends State<AES> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String? aeskeyhex;

  @override
  void initState() {
    super.initState();
    _loadPaymentSign();
  }

  // Method to read cipherTextHex from secure storage
  void _loadPaymentSign() async {
    final aeskey = await secureStorage.read(key: 'aeskey');
    
    setState(() {
      aeskeyhex = aeskey; // Update the paymentsign value and trigger a rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AES Encrypted Key"),
      ),
      body: Center(
        child: paymentsign != null && paymentsign!.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImageView(
                    data: aeskeyhex!,
                    size: 350,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Scan the QR code to confirm the Payment",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RecFalconKey()),
                      );
                    },
                    child: Text("Next"),
                  ),
                ],
              )
            : Text(
                "No signature available, payment failed try again",
                style: TextStyle(fontSize: 16),
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:offpay/aes.dart';
import 'package:offpay/home_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'globals.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Signature extends StatefulWidget {
  @override
  _SignatureState createState() => _SignatureState();
}

class _SignatureState extends State<Signature> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String? SignatureHex;

  @override
  void initState() {
    super.initState();
    _loadPaymentSign();
  }

  // Method to read cipherTextHex from secure storage
  void _loadPaymentSign() async {
    final signhex = await secureStorage.read(key: 'signhex');
    
    setState(() {
      SignatureHex = signhex; // Update the paymentsign value and trigger a rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Signature"),
      ),
      body: Center(
        child: paymentsign != null && paymentsign!.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImageView(
                    data: SignatureHex!,
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
                        MaterialPageRoute(builder: (context) => AES()),
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

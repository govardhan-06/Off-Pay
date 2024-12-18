import 'package:flutter/material.dart';
import 'package:offpay/home_page.dart';
import 'package:offpay/signature.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'globals.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Paymentsignsender extends StatefulWidget {
  @override
  _PaymentsignsenderState createState() => _PaymentsignsenderState();
}

class _PaymentsignsenderState extends State<Paymentsignsender> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String? paymentsign;

  @override
  void initState() {
    super.initState();
    _loadPaymentSign();
  }

  // Method to read cipherTextHex from secure storage
  void _loadPaymentSign() async {
    final cipherTextHex = await secureStorage.read(key: 'cypherTextHex');
    
    setState(() {
      paymentsign = cipherTextHex; // Update the paymentsign value and trigger a rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cipher Text"),
      ),
      body: Center(
        child: paymentsign != null && paymentsign!.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImageView(
                    data: paymentsign!,
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
                        MaterialPageRoute(builder: (context) => Signature()),
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

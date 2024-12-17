import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:offpay/globals.dart';
import 'home_page.dart'; 
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:offpay/utils/crypto_helper.dart';
import 'dart:typed_data';

class SetPinPage extends StatefulWidget {
  @override
  _SetPinPageState createState() => _SetPinPageState();
}

class _SetPinPageState extends State<SetPinPage> {
  final TextEditingController _pinController = TextEditingController();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

    String bytesToHex(Uint8List bytes) {
  return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
}

  Future<void> savePin(String pin) async {
    // Save the PIN securely in encrypted storage
    await _secureStorage.write(key: 'user_pin', value: pin);
    final pk = malloc<ffi.Uint8>(1184); 
    final sk = malloc<ffi.Uint8>(2400);

    await CryptoFFIHelper.kyberKeypair(pk, sk);

    publicKeyPointer = pk;
    secretKeyPointer = sk;

    final publicKey = pk.asTypedList(1184);
    final secretKey = sk.asTypedList(2400);
    final publicKeyHex = bytesToHex(publicKey);
    final secretKeyHex = bytesToHex(secretKey);
    await _secureStorage.write(key: 'publickeyhex', value: publicKeyHex);
    await _secureStorage.write(key: 'secretkeyhex', value: secretKeyHex);

    final fpk = malloc<ffi.Uint8>(1184); 
    final fsk = malloc<ffi.Uint8>(2400);

    await CryptoFFIHelper.falconKeypair(fpk, fsk);
    falconPublicPointer = fpk;
    falconSecretPointer = fsk;
    final falpublickey = fpk.asTypedList(897);
    final falsecretkey = fpk.asTypedList(1281);
    final falpublichex = bytesToHex(falpublickey);
    final falsecrethex = bytesToHex(falsecretkey);
    await _secureStorage.write(key: 'falpublichex', value: falpublichex);
    await _secureStorage.write(key: 'falsecrethex', value: falsecrethex);


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // Makes the page scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon and Welcome Message
              Column(
                children: [
                  Image.asset(
                    'assets/logo.png', // Replace with your image
                    height: 150, // Set a height for the image
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Welcome to OFFPAY, please set your PIN",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: 50), // Add space between the top and text field
              // PIN Input Field
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter PIN',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_pinController.text.length == 4) { // Basic validation
                    savePin(_pinController.text).then((_) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()), // Navigate to HomePage
                      );
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('PIN must be 4 digits')),
                    );
                  }
                },
                child: Text('Set PIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

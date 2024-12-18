import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:offpay/paymentsignsender.dart';
import 'globals.dart';
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:offpay/utils/crypto_helper.dart';
import 'dart:typed_data';
import 'dart:convert';

class PayQR extends StatefulWidget {
  @override
  _PayQRState createState() => _PayQRState();
}

class _PayQRState extends State<PayQR> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  bool isSending = false;

  String bytesToHex(Uint8List bytes) {
  return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
}

void sendAmount() async {
  final amount = _amountController.text.trim();
  final enteredPin = _pinController.text.trim();

  if (amount.isEmpty || enteredPin.isEmpty) {
    showSnackBar("Please fill in both fields.");
    return;
  }

  final storedPin = await _secureStorage.read(key: 'user_pin');
  if (storedPin == null || storedPin != enteredPin) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invalid PIN'), backgroundColor: Colors.red),
    );
    return;
  }

  final recpubkey = await _secureStorage.read(key: 'recPublicKey');
  if (recpubkey == null) {
    showSnackBar("Receiver's public key not found.");
    return;
  }

  // Convert the public key string into a byte array (List<int>)
  final recpubkeyBytes = recpubkey.codeUnits;

  // Allocate memory for the receiver's public key pointer
  final recpubkeyPtr = malloc<ffi.Uint8>(recpubkeyBytes.length);

  // Copy the public key into the allocated memory
  for (int i = 0; i < recpubkeyBytes.length; i++) {
    recpubkeyPtr[i] = recpubkeyBytes[i];
  }

  final ss = malloc<ffi.Uint8>(32);
  final ct = malloc<ffi.Uint8>(1088);

  // Pass the receiver public key pointer (recpubkeyPtr) to the CryptoFFIHelper
  await CryptoFFIHelper.kyberEnc(ct, ss, recpubkeyPtr);
  final cypherText = ct.asTypedList(1184);
  final cypherTextHex = bytesToHex(cypherText);

  print(cypherTextHex);
  
  await _secureStorage.write(key: 'cypherTextHex', value: cypherTextHex);

  final message = 'Payment Transferring';
  final seckey = await _secureStorage.read(key: 'secretkeyhex');
  if (seckey == null) {
    showSnackBar("Receiver's public key not found.");
    return;
  }
  final messagePointer = malloc<ffi.Uint8>(message.length);
  final secretKeyBytes = seckey.codeUnits;

   for (int i = 0; i < message.length; i++) {
      messagePointer[i] = message.codeUnitAt(i);
    }

  final secretKeyPtr = malloc<ffi.Uint8>(secretKeyBytes.length);
    for (int i = 0; i < recpubkeyBytes.length; i++) {
    secretKeyPtr[i] = secretKeyBytes[i];
  }

  final sig = malloc<ffi.Uint8>(752);
  final siglen = malloc<ffi.Uint8>(3);


  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Paymentsignsender()),
  );
}

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payments"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Amount",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter PIN",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSending ? null : sendAmount,
              child: isSending ? CircularProgressIndicator() : Text("Send"),
            ),
          ],
        ),
      ),
    );
  }
}

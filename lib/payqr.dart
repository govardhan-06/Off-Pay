import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:offpay/paymentsignsender.dart';
import 'globals.dart';

class PayQR extends StatefulWidget {
  @override
  _PayQRState createState() => _PayQRState();
}

class _PayQRState extends State<PayQR> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  bool isSending = false;

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
                SnackBar(content: Text('Invalid PIN'), backgroundColor: Colors.red,),
              );
      return;
    }
    setState(() {
    paymentsign = "123";
    });
    
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

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
    paymentsign = "02000002FD7F0000C223FCECFD7F0000FFFFFFFF000000003700000000000000F0E1CB6748020000280100000000000038775AEDFD7F0000000000002B00000000000000000000000000000000000000B007CB674802000060E8CB67480200008103000000000000000000000000000090030000000000000000000000000000390000000000000000000000000000000000C967480200009C92E873FE7F00000000C96748020000020000000000000081030000000000009003000000000000F804C9674802000060F2CFB08D00000003000000000000000000CFB00000000000E8CB674802000020F2CFB08D000000402A55074802000000000000000000006E2A550748020000402E550748020000000000000000000000000000000000000000000000000000402A55074802000000005AED00000000010000002B00000020F2CFB08D000000000000000000000000000000000000000000000000000000100000000000000081030000000000001807405048020000000000000000000001000000000000000900000000000000E0F3CFB08D000000A6003071FE7F000000000000000000008103000000000000402A5507480200000000000000000000010000000000000071202CEDFD7F00008103000000000000F0142AEDFD7F0000000000000000000000000000000000000900000000000000D669CAECFD7F000001000000000000008103000000000000C0F4CFB08D0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000C8CF5FEDFD7F000058181654480200000DF4CFB08D000000BA1B00000000000018F9A08B000000003C5D03EDFD7F0000F0E1CB6748020000214703EDFD7F000070E8CB674802000003000000280000004888530748020000F00200000000000090E5CB674802000039170A44FE7F000050F4CFB08D0000002801000000000000F0E1CB6748020000654EFCECFD7F000090F4CFB08D0000003436550748020000";
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

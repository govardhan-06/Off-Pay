import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:nearby_connections/nearby_connections.dart';

class PaymentsPage extends StatefulWidget {
  final String connectedEndpointId; // Pass the connected endpoint ID

  PaymentsPage({required this.connectedEndpointId});

  @override
  _PaymentsPageState createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  final TextEditingController _amountController = TextEditingController();
  bool isSending = false;

  void sendAmount() async {
    final amount = _amountController.text.trim();

    if (amount.isEmpty) {
      showSnackBar("Please enter an amount.");
      return;
    }

    setState(() {
      isSending = true;
    });

    try {
      // Send the amount as a payload to the connected device
      await Nearby().sendBytesPayload(
        widget.connectedEndpointId,
        Uint8List.fromList(amount.codeUnits),
      );
      showSnackBar("Amount sent: $amount");
    } catch (e) {
      showSnackBar("Error sending amount: $e");
    } finally {
      setState(() {
        isSending = false;
      });
    }
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
          mainAxisAlignment: MainAxisAlignment.center,
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

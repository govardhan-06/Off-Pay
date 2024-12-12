import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'home_page.dart'; // Import the HomePage

class SetPinPage extends StatefulWidget {
  @override
  _SetPinPageState createState() => _SetPinPageState();
}

class _SetPinPageState extends State<SetPinPage> {
  final TextEditingController _pinController = TextEditingController();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<void> savePin(String pin) async {
    // Save the PIN securely in encrypted storage
    await _secureStorage.write(key: 'user_pin', value: pin);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon and Welcome Message
            Column(
              children: [
                Image.asset('assets/logo.png'), // Replace with your image
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
    );
  }
}

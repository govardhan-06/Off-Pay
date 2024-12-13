import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'home_page.dart';

class EnterPinPage extends StatefulWidget {
  @override
  _EnterPinPageState createState() => _EnterPinPageState();
}

class _EnterPinPageState extends State<EnterPinPage> {
  final TextEditingController _pinController = TextEditingController();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  String? _storedPin;

  @override
  void initState() {
    super.initState();
    loadStoredPin();
  }

  Future<void> loadStoredPin() async {
    // Load the encrypted PIN from secure storage
    _storedPin = await _secureStorage.read(key: 'user_pin');
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
                    'assets/logo.png',
                    height: 150, // Set a fixed height for the image
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Welcome to OFFPAY, please enter your PIN",
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
                  if (_pinController.text == _storedPin) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => HomePage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid PIN')),
                    );
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

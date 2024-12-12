import 'package:flutter/material.dart';
import 'set_pin_page.dart';
import 'enter_pin_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PIN Authentication',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CheckPinScreen(),
    );
  }
}

class CheckPinScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isPinSet(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data == true) {
          return EnterPinPage(); // If PIN is set, navigate to EnterPinPage
        } else {
          return SetPinPage(); // If no PIN, navigate to SetPinPage
        }
      },
    );
  }

  Future<bool> isPinSet() async {
    // Check if a PIN is already stored in secure storage
    final secureStorage = FlutterSecureStorage();
    final pin = await secureStorage.read(key: 'user_pin');
    return pin != null;
  }
}

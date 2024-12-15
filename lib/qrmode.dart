import 'package:flutter/material.dart';
import 'package:offpay/home_page.dart';
import 'package:offpay/recqr.dart';
import 'package:offpay/sendqr.dart';

class QrMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'QR MODE',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF202020),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomePage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // Handle Send Money action
                 Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => sendQr()),
            );
              },
              child: Card(
                color: Color(0xFF202020),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.qr_code_sharp,
                        size: 40,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Send Money',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // Handle Receive Money action
                   Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => RecQr()),
            );
                print('Receive Money clicked');
              },
              child: Card(
                color: Color(0xFF202020),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.currency_rupee,
                        size: 40,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Receive Money',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

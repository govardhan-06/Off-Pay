import 'package:flutter/material.dart';
import 'package:offpay/home_page.dart';

class TransactionHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Transaction History',
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
      body: Center(
        child: Text(
          'Transaction History Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

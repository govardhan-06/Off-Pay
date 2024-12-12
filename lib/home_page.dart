import 'package:flutter/material.dart';
import 'package:offpay/profile.dart';
import 'package:offpay/recieve_money.dart';
import 'package:offpay/send_money.dart';
import 'package:offpay/settings.dart';
import 'package:offpay/transaction_history.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF202020),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  height: 125, // Adjust the height as needed
                ),
              ),
              _buildOptionCard(
                context,
                title: "SEND MONEY",
                icon: Icons.camera_alt,
                onTap: () {
                  // Navigate to Send Money Page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => SendMoney()),
                  );
                },
              ),
              _buildOptionCard(
                context,
                title: "RECEIVE MONEY",
                icon: Icons.qr_code,
                onTap: () {
                  // Navigate to Receive Money Page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => RecMoney()),
                  );
                },
              ),
              _buildOptionCard(
                context,
                title: "TRANSACTION HISTORY",
                icon: IconData(0xf05db, fontFamily: 'MaterialIcons'),
                onTap: () {
                  // Navigate to Transaction History Page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => TransactionHistory()),
                  );
                },
              ),
              _buildOptionCard(
                context,
                title: "SETTINGS",
                icon: Icons.settings,
                onTap: () {
                  // Navigate to Settings Page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => SettingsPage()),
                  );
                },
              ),
              _buildOptionCard(
                context,
                title: "PROFILE",
                icon: Icons.person,
                onTap: () {
                  // Navigate to Profile Page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => Profile()),
                  );
                },
              ),
              SizedBox(height: 20),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Color(0xFF202020), // Hex Color: #202020
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 30),
              SizedBox(width: 20),
              Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

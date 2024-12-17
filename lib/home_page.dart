import 'package:flutter/material.dart';
import 'package:offpay/globals.dart';
import 'package:offpay/profile.dart';
import 'package:offpay/recieve_money.dart';
import 'package:offpay/send_money.dart';
import 'package:offpay/qrmode.dart';
import 'package:offpay/transaction_history.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:location/location.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _requestAllPermissions();
    
  }



  Future<String?> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id;
  }

  Future<void> _requestAllPermissions() async {
    final Location location = Location();

    // Ensure location services are enabled
    if (!(await location.serviceEnabled())) {
      await location.requestService();
    }

    // Request location permission
    await location.requestPermission();

    // Get device ID and set advertiserId
    final String? tempValue = await getDeviceId();
    advertiserId = "Off-$tempValue";

    // Request other permissions sequentially to avoid conflicts
    await _requestPermission(Permission.bluetooth);
    await _requestPermission(Permission.bluetoothScan);
    await _requestPermission(Permission.bluetoothAdvertise);
    await _requestPermission(Permission.bluetoothConnect);
    await _requestPermission(Permission.storage);
    await _requestPermission(Permission.nearbyWifiDevices);
  }

  Future<void> _requestPermission(Permission permission) async {
    final status = await permission.request();
    if (!status.isGranted) {
      debugPrint('${permission.toString()} permission not granted.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Home Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF202020),
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
                  height: 125,
                ),
              ),
              _buildOptionCard(
                context,
                title: "SEND MONEY (P2P)",
                icon: Icons.camera_alt,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => SendMoney()),
                  );
                },
              ),
              _buildOptionCard(
                context,
                title: "RECEIVE MONEY (P2P)",
                icon: Icons.qr_code_scanner,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => RecMoney()),
                  );
                },
              ),
              _buildOptionCard(
                context,
                title: "TRANSACTION HISTORY",
                icon: const IconData(0xf05db, fontFamily: 'MaterialIcons'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => TransactionHistory()),
                  );
                },
              ),
              _buildOptionCard(
                context,
                title: "QR MODE TRANSACTION",
                icon: Icons.qr_code,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => QrMode()),
                  );
                },
              ),
              _buildOptionCard(
                context,
                title: "PROFILE",
                icon: Icons.person,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => Profile()),
                  );
                },
              ),
              const SizedBox(height: 20),
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
        color: const Color(0xFF202020),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 30),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

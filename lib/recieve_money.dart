import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:offpay/home_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class RecMoney extends StatefulWidget {
  @override
  _RecMoneyState createState() => _RecMoneyState();
}

class _RecMoneyState extends State<RecMoney> {
  final Strategy strategy = Strategy.P2P_POINT_TO_POINT;
  String? advertiserId;


  @override
  void initState() {
    super.initState();
    //_startAdvertising();
  }


Future<String?> getDeviceId() async {
  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo; // Get Android device info
  return androidInfo.id; // Returns the Android ID (similar to Settings.Secure.ANDROID_ID)
}


  Future<void> _startAdvertising() async {
    await Permission.locationWhenInUse.request();
    // Start advertising
    advertiserId = await getDeviceId();
    print('Device Id is: $advertiserId');
    print("STARTED ADVERTISING FOR DEVICES");
    bool advertising = await Nearby().startAdvertising(
      'Advertiser',
      strategy,
      onConnectionInitiated: (id, info) {
        Nearby().acceptConnection(
          id,
          onPayLoadRecieved: (endpointId, payload) {
            // Handle payload received
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Payload received from $endpointId')),
            );
          },
          onPayloadTransferUpdate: (endpointId, payloadTransferUpdate) {
            // Monitor payload transfer progress
          },
        );
      },
      onConnectionResult: (id, status) {
        if (status == Status.CONNECTED) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Connected to $id')),
          );
          Nearby().stopAdvertising();
        }
      },
      onDisconnected: (id) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Disconnected from $id')),
        );
      },
    );

    if (!advertising) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start advertising')),
      );
      return;
    }

    // Get advertiser ID (local endpoint ID)
    
  }

  @override
  void dispose() {
    Nearby().stopAdvertising();
    super.dispose();
  }

  @override
  void deactivate() {
    // Stop advertising when the widget is deactivated (sent to the background)
    Nearby().stopAdvertising();
    super.deactivate();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Advertiser'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomePage()),
          );
        },
      ),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Scan this QR code to connect:',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          FutureBuilder(
            future: _startAdvertising(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return QrImageView(
                  data: "$advertiserId",
                  size: 300,
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    ),
  );
}
}

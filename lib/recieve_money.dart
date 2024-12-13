import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:offpay/home_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

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
    _startAdvertising();
  }

  void _startAdvertising() async {
    await Permission.locationWhenInUse.request();
    // Start advertising
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
    setState(() {
      advertiserId = "1234";
    });
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
                  );// Go back to the previous page
          },
        ),
      ),
      body: Center(
        child: advertiserId != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Scan this QR code to connect:',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  QrImageView(
                    data: advertiserId!,
                    size: 200,
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}

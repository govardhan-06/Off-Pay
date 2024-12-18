import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:offpay/globals.dart';
import 'package:offpay/home_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import the package

class RecMoney extends StatefulWidget {
  @override
  _RecMoneyState createState() => _RecMoneyState();
}

class _RecMoneyState extends State<RecMoney> {
  final Strategy strategy = Strategy.P2P_POINT_TO_POINT;
  String receivedPayment = ""; // Variable to store received payment amount
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  
  @override
  void initState() {
    super.initState();
    //_startAdvertising();
    _loadPublicKey();  

  }
    Future<void> _loadPublicKey() async {
    String? publicKey = await _secureStorage.read(key: 'publickeyhex');
    setState(() {
      recPublicKey = publicKey;
    });
  }

Future<void> _startAdvertising() async {
  await Permission.locationWhenInUse.request();

  print('Device Id is: $advertiserId');
  print("STARTED ADVERTISING FOR DEVICES");
  bool advertising = await Nearby().startAdvertising(
    'Receiver',
    strategy,
    onConnectionInitiated: (id, info) async {
      bool shouldAcceptConnection = await _showConnectionDialog(id);
      if (shouldAcceptConnection) {
        Nearby().acceptConnection(
          id,
          onPayLoadRecieved: (endpointId, payload) {
            if (payload.type == PayloadType.BYTES) {
              String payloadData = String.fromCharCodes(payload.bytes!);
              setState(() {
                receivedPayment = payloadData;
              });
              _showGreenSnackBar("Payment Received: ₹$payloadData");
            }
          },
        );
      } else {
        Nearby().rejectConnection(id);
      }
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
}

Future<bool> _showConnectionDialog(String id) async {
  bool shouldAccept = false;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Connection Request'),
        content: Text('Do you want to accept the connection from $id?'),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              shouldAccept = true;
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  return shouldAccept;
}

  void _showGreenSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    Nearby().stopAdvertising();
    super.dispose();
  }

  @override
  void deactivate() {
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
                    data: recPublicKey!,
                    size: 300,
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            SizedBox(height: 20),
            if (receivedPayment.isNotEmpty)
              Text(
                "Last Payment Received: ₹$receivedPayment",
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}

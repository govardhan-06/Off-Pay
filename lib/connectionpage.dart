import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:offpay/paymentwindow.dart';

class ConnectionPage extends StatefulWidget {
  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}
class _ConnectionPageState extends State<ConnectionPage> {
  final Strategy strategy = Strategy.P2P_POINT_TO_POINT; // Choose your strategy
  final List<Map<String, String>> discoveredDevices = [];
  bool isDiscovering = false;

  @override
  void dispose() {
    super.dispose();
    if (isDiscovering) {
      Nearby().stopDiscovery();
    }
  }

  void startDiscovery() async {
    try {
      setState(() {
        isDiscovering = true;
        discoveredDevices.clear();
      });

      await Nearby().startDiscovery(
        'Sender', // Replace with a unique name or user ID
        strategy,
        onEndpointFound: (id, name, serviceId) {
          setState(() {
            discoveredDevices.add({'id': id, 'name': name});
          });
          showSnackBar('Discovered: $name');
        },
        onEndpointLost: (id) {
          setState(() {
            discoveredDevices.removeWhere((device) => device['id'] == id);
          });
        },
      );
    } catch (e) {
      showSnackBar("Error starting discovery: $e");
    }
  }

  void stopDiscovery() {
    Nearby().stopDiscovery();
    setState(() {
      isDiscovering = false;
    });
    showSnackBar("Discovery stopped.");
  }

  void connectToDevice(String endpointId) async {
    try {
      await Nearby().requestConnection(
        'Device', // Replace with your name or ID
        endpointId,
        onConnectionInitiated: (id, info) {
          showSnackBar("Connection initiated with ${info.endpointName}");
        },
        onConnectionResult: (id, status) {
          if(status == Status.CONNECTED){
            showSnackBar("Connection successful with the intended device");
            print("connection accepted and confirmed");
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PaymentsPage(connectedEndpointId: id)),
          );
          }else{
            showSnackBar("Connection FAILED with the intended device");
            print("Connection failed to be accepted");
          }
        },
        onDisconnected: (id) {
          showSnackBar("Disconnected from $id");
        },
      );
    } catch (e) {
      showSnackBar("Error connecting: $e");
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Discover Devices')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: isDiscovering ? stopDiscovery : startDiscovery,
              child: Text(isDiscovering ? 'Stop Discovery' : 'Start Discovery'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: discoveredDevices.length,
              itemBuilder: (context, index) {
                final device = discoveredDevices[index];
                return ListTile(
                  title: Text(device['name'] ?? 'Unknown'),
                  subtitle: Text(device['id'] ?? ''),
                  trailing: ElevatedButton(
                    onPressed: () => connectToDevice(device['id']!),
                    child: Text('Connect'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

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
      final signhex = "02000002FD7F0000C223FCECFD7F0000FFFFFFFF000000003700000000000000F0E1CB6748020000280100000000000038775AEDFD7F0000000000002B00000000000000000000000000000000000000B007CB674802000060E8CB67480200008103000000000000000000000000000090030000000000000000000000000000390000000000000000000000000000000000C967480200009C92E873FE7F00000000C96748020000020000000000000081030000000000009003000000000000F804C9674802000060F2CFB08D00000003000000000000000000CFB00000000000E8CB674802000020F2CFB08D000000402A55074802000000000000000000006E2A550748020000402E550748020000000000000000000000000000000000000000000000000000402A55074802000000005AED00000000010000002B00000020F2CFB08D000000000000000000000000000000000000000000000000000000100000000000000081030000000000001807405048020000000000000000000001000000000000000900000000000000E0F3CFB08D000000A6003071FE7F000000000000000000008103000000000000402A5507480200000000000000000000010000000000000071202CEDFD7F00008103000000000000F0142AEDFD7F0000000000000000000000000000000000000900000000000000D669CAECFD7F000001000000000000008103000000000000C0F4CFB08D0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000C8CF5FEDFD7F000058181654480200000DF4CFB08D000000BA1B00000000000018F9A08B000000003C5D03EDFD7F0000F0E1CB6748020000214703EDFD7F000070E8CB674802000003000000280000004888530748020000F00200000000000090E5CB674802000039170A44FE7F000050F4CFB08D0000002801000000000000F0E1CB6748020000654EFCECFD7F000090F4CFB08D0000003436550748020000";
  final aeskey = "a13f270a896136eb5a2a87b558469b1043ef7738792277e986b89e8b9fa96d846af752a578775a44f193839a96f6fc44585292b6ad52c80fdb3f9f205836ecd41bb9bca737c4c50c69dc8a0ececcb8b736644d7c8211e228f5436cb60b2ace8092d72ebe98056f938301ae3463c5ea4722fd7b27b6b016d1371cbb987bfa6e5559de043bc664819bf4bb1c380d9b9afba68a9bc7955a388006655f67ebe580012240a493845244d2f6eec70e92a7a202d9b10b772223c3756fd1a78000c271dca3c28e3c5d33cb7586f058a2dbaf632a8818274a8e334cc6ca362c9186a68de068668b0df039b5c3560962f03cbafc1474f724dfb2fb8a543d94e465c53b3418e774eb156d2ad3134cae94fb72b9a8bb0609c402516e83439712c1ca6ab444c1cb63ce2c574";

  _secureStorage.write(key: 'signhex', value: signhex);
  _secureStorage.write(key: 'aeskey', value: aeskey);
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
                SnackBar(content: Text('Invalid PIN'), backgroundColor: Colors.red,),
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

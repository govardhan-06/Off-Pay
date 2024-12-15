import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:offpay/sendtransactionkey.dart';
import 'globals.dart';

class PayQR extends StatefulWidget {
  @override
  _PayQRState createState() => _PayQRState();
}

class _PayQRState extends State<PayQR> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  bool isSending = false;

  void sendAmount() async {
    final amount = _amountController.text.trim();
    final enteredPin = _pinController.text.trim();

    if (amount.isEmpty || enteredPin.isEmpty) {
      showSnackBar("Please fill in both fields.");
      return;
    }

    final storedPin = await _secureStorage.read(key: 'user_pin');
    if (storedPin == null || storedPin != enteredPin) {
           ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invalid PIN'), backgroundColor: Colors.red,),
              );
      return;
    }
    setState(() {
    transactionData = "c37b3a92cbedee435b49c8e6f598df29d895c60e0fb9815faf42792d54597960b40980ac9854deb34be798c0d4cb684f43356235243282579549308be03010d77b81aceb2fefcb0580263f0d925c0f2151de04a1df252f2563e6ca82a122a6459d893572b11391056b8f1c53f2472a2cd06b46348db1ee1a6854ffb096185ac71c3f5832560f5a90cf1cf649d4e5da7bfd825d146bf5af32e37b4d61a634517b7eead1232eb703fac0ac50ec63559a8055fd59704ea3bacdc512d0d48e560a678611771ddbd196c33d7c650c7c215d157206c0b539a855ff3571ff5dd2b7cc2c4893c39a0f5832fe73faf53b6e2c46f6bc079103624eece0ecb440054a27f2227a3594cbc53b62eb3d9f5cb21f9db9778703e6977b76d3734579a7a5dd406ae5e3532896b4bdc9191f794817fbd8bd2a2a98b417170e8889a37d4509acce180cc205a0165d0ff1851bf0e0e9d74ad5bc3d78e3c15514fc8240ded8b9bda4f52139b7ea49a2a9263e00d95e05cf7ccf9f732100cac027c616b9f6a5d7f3e3c2539cf34fcdc17cc9f890324276e10c0cf583547353d971cfda5ee9799acc7b41994075033a7c4c04eba9e0b58ffded4d5110a10067ab374ba51f3c1a11aa07e3a7a5ea70d890b7d9d9e64ccbbfe3bcafd7a2743e4b1dcf2e108ba31f56fc08705a97afe0b5ea9ca73bf560384e9a5356477d1bb77327bfbe2cd8ca156f3fadc1edb8e9badba5915d6bc8b577ed1e75c757b8b08a031661fa509ff412405e9ee9df8a2c52b4aa9cf7129d2dd3ba43d90a7ecb410996f701e935ed54021b1f3b2daf97bbb135c1979422a00f72741a9185ea0aa2f23e8dc1a7995da03d888483ccb84937c2aba666236cca7388230fe5bb218a461b3160cf6770d2c085c9b0470a882e3a7fabc0de7111d85f80c903e9b53ec00899dc2b284d97eee57636441b594f5b79e998f7feefe3fd51b52aa8ae4da0eeb85952cc36e4e3599549dadc3da9bc26e5837d747b62d2a4064f4b9a5a96039150d891c762c0927c013b315c09f5f1d4f781aee2886ffc6399db469f74d12d4a99868d6a83b58f353a5eb22e103eb083fd884b5025f9dd455a3f3615294fd93fb152926a82f12b81672f471cb41506b69475408dd241cce61518be36f23ae86c695d24a332bf563985a04d873ef49a2cb98ca283553ccedd08f27969c25d9667802ea46d625ff340256569cd5e4463ee26ab9fb6623e43000faaeab943fe96f08d662341e2045eed2200148a20d5b022cc98363afe272cd2409c808f9980523c6ad5da6d21e8344c0ffae9a87aa916444a14c820a2e56806a17c22c7214eab039c5a4a6627c587eef47175e3feabc614ad017441d5cca2300c03ddb29a34e112c3534cbd13eb8518c12d075f0ec1a20f63b0612d0ab03d0929b23406e1501e3e3526347eb0cadf804474f18682dff37c5344691fc36875d8a57bd277dd0a90e7f4253745d28c27fb6768c9d0736c39204796bd76ca55469e139672922ad5f2e9ffdfd56cef4203ab27d325e8104929";
    paymentsign = "02000002FD7F0000C223FCECFD7F0000FFFFFFFF000000003700000000000000F0E1CB6748020000280100000000000038775AEDFD7F0000000000002B00000000000000000000000000000000000000B007CB674802000060E8CB67480200008103000000000000000000000000000090030000000000000000000000000000390000000000000000000000000000000000C967480200009C92E873FE7F00000000C96748020000020000000000000081030000000000009003000000000000F804C9674802000060F2CFB08D00000003000000000000000000CFB00000000000E8CB674802000020F2CFB08D000000402A55074802000000000000000000006E2A550748020000402E550748020000000000000000000000000000000000000000000000000000402A55074802000000005AED00000000010000002B00000020F2CFB08D000000000000000000000000000000000000000000000000000000100000000000000081030000000000001807405048020000000000000000000001000000000000000900000000000000E0F3CFB08D000000A6003071FE7F000000000000000000008103000000000000402A5507480200000000000000000000010000000000000071202CEDFD7F00008103000000000000F0142AEDFD7F0000000000000000000000000000000000000900000000000000D669CAECFD7F000001000000000000008103000000000000C0F4CFB08D0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000C8CF5FEDFD7F000058181654480200000DF4CFB08D000000BA1B00000000000018F9A08B000000003C5D03EDFD7F0000F0E1CB6748020000214703EDFD7F000070E8CB674802000003000000280000004888530748020000F00200000000000090E5CB674802000039170A44FE7F000050F4CFB08D0000002801000000000000F0E1CB6748020000654EFCECFD7F000090F4CFB08D0000003436550748020000";
    });
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => sendTransactionKey()),
    );
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payments"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Amount",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter PIN",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSending ? null : sendAmount,
              child: isSending ? CircularProgressIndicator() : Text("Send"),
            ),
          ],
        ),
      ),
    );
  }
}

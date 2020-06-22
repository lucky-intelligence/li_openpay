import 'package:flutter/material.dart';
import 'package:li_openpay/li_openpay.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> { 

  @override
  void initState() {
    super.initState();
    this.genToken();
  }

  void genToken() async{
    var openpay = new LiOpenpay(merchantId: "mde9saj6yaypoi2ppvlq", apiKey: "sk_c263ce152f264a50bd94b3a3c257c3bb", production: false);
    openpay.createCard("Kevin Alexis Contreras Ramirez", "4111111111111111", 12, 24, "999").then((c) {
      print("Token: ${c.token}");
    }).catchError((err) => print(err));
    print("OPENPAY: ${await openpay.getDeviceSessionId()}");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Li_OpenPay'),
        ),
        body: Center(
          child: Text('See getToken method'),
        ),
      ),
    );
  }
}

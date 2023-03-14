import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:mob_vietduc/widgets/drawer.dart';
import 'package:mob_vietduc/constants/Theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mob_vietduc/screens/timkiemthietbi.dart';
import 'package:mob_vietduc/screens/dieuchuyenhang.dart';
import 'package:mob_vietduc/screens/yeucaubaotri.dart';

class scanqr extends StatefulWidget {
  @override
  _scanqrState createState() => _scanqrState();
}

class _scanqrState extends State<scanqr> {
  String _scanBarcode = 'Chưa quét';

  @override
  void initState() {
    super.initState();
  }

  Future<void> startBarcodeScanStream() async {
    String barcodeScanRes;
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
      '#ff6666',
      'Cancel',
      true,
      ScanMode.BARCODE,
    )?.listen((barcodeScanRes) {
      if (barcodeScanRes != null) {
        print(barcodeScanRes);
      }
    });
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text("SCAN QR"),
            ),
            backgroundColor: ArgonColors.bgColorScreen,
            drawer: ArgonDrawer(currentPage: "scanqr"),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () => {scanBarcodeNormal()},
                            child: Text('Quét barcode')),
                        ElevatedButton(
                            onPressed: () => scanQR(),
                            child: Text('Quét qr code')),
                        // ElevatedButton(
                        //     onPressed: () => startBarcodeScanStream(),
                        //     child: Text('Start barcode scan stream')),
                        Text('Mã quét: $_scanBarcode\n',
                            style: TextStyle(fontSize: 20)),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors
                                  .pinkAccent, //change background color of button
                              backgroundColor:
                                  Colors.green, //change text color of button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 15.0,
                            ),
                            child: Text(
                              'Yêu cầu Bảo trì',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              _scanBarcode = "EPC:" + _scanBarcode;
                              List<String> myStringList =
                                  _scanBarcode.split(",");
                              Set<String> mySet = Set.from(myStringList);

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      yeucaubaotri(epcSetLienTuc: mySet),
                                ),
                              );
                            }),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors
                                  .pinkAccent, //change background color of button
                              backgroundColor:
                                  Colors.green, //change text color of button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 15.0,
                            ),
                            child: Text(
                              'Điều chuyển',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              _scanBarcode = "EPC:" + _scanBarcode;
                              List<String> myStringList =
                                  _scanBarcode.split(",");
                              Set<String> mySet = Set.from(myStringList);

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      dieuchuyenhang(epcSetLienTuc: mySet),
                                ),
                              );
                            }),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors
                                  .pinkAccent, //change background color of button
                              backgroundColor:
                                  Colors.green, //change text color of button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 15.0,
                            ),
                            child: Text(
                              'Tìm Kiếm',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              _scanBarcode = "EPC:" + _scanBarcode;
                              List<String> myStringList =
                                  _scanBarcode.split(",");
                              Set<String> mySet = Set.from(myStringList);

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      timkiemthietbi(epcSetLienTuc: mySet),
                                ),
                              );
                            }),
                      ]));
            })));
  }
}

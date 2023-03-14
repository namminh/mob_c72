import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:mob_vietduc/widgets/drawer.dart';
import 'package:mob_vietduc/constants/Theme.dart';
import 'package:flutter/services.dart';
import 'package:uhf_c72_plugin/uhf_c72_plugin.dart';
import 'package:uhf_c72_plugin/tag_epc.dart';
import 'package:mob_vietduc/screens/timkiemthietbi.dart';
import 'package:mob_vietduc/screens/dieuchuyenhang.dart';
import 'package:mob_vietduc/screens/yeucaubaotri.dart';

class chainwayc72 extends StatefulWidget {
  @override
  _chainwayc72State createState() => _chainwayc72State();
}

class _chainwayc72State extends State<chainwayc72> {
  String _platformVersion = 'Unknown';
  bool _isStarted = false;
  bool _isStartedDon = false;
  bool _isEmptyTags = false;
  bool _isConnected = false;
  String temp = '';
  int countLientuc = 0;
  int countDon = 0;
  Set<String> epcSetDon = Set<String>();
  Set<String> epcSetLienTuc = Set<String>();
  TextEditingController powerLevelController = TextEditingController(text: '5');
  TextEditingController workAreaController = TextEditingController(text: '1');
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await UhfC72Plugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    UhfC72Plugin.connectedStatusStream
        .receiveBroadcastStream()
        .listen(updateIsConnected);
    UhfC72Plugin.tagsStatusStream.receiveBroadcastStream().listen(updateTags);
    await UhfC72Plugin.connect;
    await UhfC72Plugin.setWorkArea('2');
    await UhfC72Plugin.setPowerLevel('30');
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  List<String> _logs = [];
  void log(String msg) {
    setState(() {
      _logs.add(msg);
    });
  }

  List<TagEpc> _data = [];
  void updateTags(dynamic result) {
    // log('update tags');
    setState(() {
      _data = TagEpc.parseTags(result);
    });
  }

  void updateIsConnected(dynamic isConnected) {
    // log('connected $isConnected');
    //setState(() {
    _isConnected = isConnected;
    //});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QUÉT UHF"),
      ),
      backgroundColor: ArgonColors.bgColorScreen,
      drawer: ArgonDrawer(currentPage: "chainwayc72"),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Card(
            //   child: Padding(
            //     padding: const EdgeInsets.all(3.0),
            //     child: Image.asset(
            //       'assets/img/logovietduc.png',
            //       width: double.infinity,
            //       height: 80,
            //       fit: BoxFit.contain,
            //     ),
            //   ),
            // ),
            /*Text('Running on: $_platformVersion'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                      child: Text('Call connect'),
                      onPressed: () async {
                        await UhfC72Plugin.connect;
                      }),
                  ElevatedButton(
                      child: Text('Call is Connected'),
                      onPressed: () async {
                        bool isConnected = await UhfC72Plugin.isConnected;
                        setState(() {
                          this._isConnected = isConnected;
                        });
                      }),
                ],
              ),
              Text(
                'UHF Reader isConnected:$_isConnected',
                style: TextStyle(color: Colors.blue.shade800),
              ),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          Colors.pinkAccent, //change background color of button
                      backgroundColor:
                          Colors.green, //change text color of button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 15.0,
                    ),
                    child: Text(
                      'Đọc',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      bool isStartedDon = await UhfC72Plugin.startSingle;
                      // log('Start signle $isStarted');
                      _data.forEach((TagEpc tag) {
                        if (!epcSetLienTuc.contains(tag.epc)) {
                          // Nếu epc chưa có trong Set thì thêm vào

                          epcSetLienTuc.add('EPC:${tag.epc}');
                          print('Tag ${tag.epc} Count:${tag.count}');
                          print('Danh sach epcSet don ${epcSetLienTuc} ');
                        }
                      });
                      setState(() {
                        countLientuc = epcSetLienTuc.length;
                      });
                    }),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          Colors.pinkAccent, //change background color of button
                      backgroundColor:
                          Colors.green, //change text color of button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 15.0,
                    ),
                    child: Text(
                      'Đọc liên tục',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      bool isStarted = await UhfC72Plugin.startContinuous;
                      _data.forEach((TagEpc tag1) {
                        if (!epcSetLienTuc.contains(tag1.epc)) {
                          // Nếu epc chưa có trong Set thì thêm vào

                          epcSetLienTuc.add(tag1.epc);
                          print('Tag lien tuc ${tag1.epc} Count:${tag1.count}');
                        }

                        print('Danh sach epcSet lien tuc ${epcSetLienTuc} ');
                      });
                      setState(() {
                        countLientuc = epcSetLienTuc.length;
                      });
                      // log('Start Continuous $isStarted');
                    }),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          Colors.pinkAccent, //change background color of button
                      backgroundColor:
                          Colors.green, //change text color of button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 15.0,
                    ),
                    child: Text(
                      'Dừng',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      bool isStopped = await UhfC72Plugin.stop;
                      setState(() {
                        countLientuc = epcSetLienTuc.length;
                      });
                      print('so san pham ${countLientuc} ');
                      // log('Stop $isStopped');
                    }),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          Colors.pinkAccent, //change background color of button
                      backgroundColor:
                          Colors.green, //change text color of button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 15.0,
                    ),
                    child: Text(
                      'Xóa dữ liệu',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      await UhfC72Plugin.clearData;
                      setState(() {
                        _data = [];
                        epcSetLienTuc = Set<String>();

                        countLientuc = 0;
                      });
                    }),
                /* ElevatedButton(
                      child: Text('Call isStarted'),
                      onPressed: () async {
                        bool isStarted = await UhfC72Plugin.isStarted;
                        setState(() {
                          this._isStarted = isStarted;
                        });
                      }),*/
              ],
            ),
            /*Text(
                'UHF Reader isStarted:$_isStarted',
                style: TextStyle(color: Colors.blue.shade800),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[*/

            /*   ElevatedButton(
                      child: Text('Call Close'),
                      onPressed: () async {
                        await UhfC72Plugin.close;
                      }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[*/

            /* ElevatedButton(
                      child: Text('Call is Empty Tags'),
                      onPressed: () async {
                        bool isEmptyTags = await UhfC72Plugin.isEmptyTags;
                        setState(() {
                          this._isEmptyTags = isEmptyTags;
                        });
                      }),
                ],
              ),
              Text(
                'UHF Reader isEmptyTags:$_isEmptyTags',
                style: TextStyle(color: Colors.blue.shade800),
              ),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 100,
                  child: TextFormField(
                    controller: powerLevelController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(labelText: 'Power Level'),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          Colors.pinkAccent, //change background color of button
                      backgroundColor:
                          Colors.green, //change text color of button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 15.0,
                    ),
                    child: Text(
                      'Set Power Level',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      bool isSetPower = await UhfC72Plugin.setPowerLevel(
                          powerLevelController.text);
                      // log('isSetPower $isSetPower');
                    }),
              ],
            ),
            Text(
              'powers {"5" : "30" dBm}',
              style: TextStyle(color: Colors.blue.shade800, fontSize: 12),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: <Widget>[
            //     Container(
            //       width: 100,
            //       child: TextFormField(
            //         controller: workAreaController,
            //         keyboardType: TextInputType.number,
            //         textAlign: TextAlign.center,
            //         decoration: InputDecoration(labelText: 'Work Area'),
            //       ),
            //     ),
            //     ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //           foregroundColor:
            //               Colors.pinkAccent, //change background color of button
            //           backgroundColor:
            //               Colors.green, //change text color of button
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(18),
            //           ),
            //           elevation: 15.0,
            //         ),
            //         child: Text(
            //           'Set Work Area',
            //           style: TextStyle(color: Colors.white),
            //         ),
            //         onPressed: () async {
            //           bool isSetWorkArea = await UhfC72Plugin.setWorkArea(
            //               workAreaController.text);
            //           log('isSetWorkArea $isSetWorkArea');
            //         }),
            //   ],
            // ),
            // Text(
            //   'Work Area 1 China 920MHz - 2 China 840 - 3 ETSI 865\n4 Fixed 915 - 5 USA 902',
            //   style: TextStyle(color: Colors.blue.shade800, fontSize: 12),
            // ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          Colors.pinkAccent, //change background color of button
                      backgroundColor:
                          Colors.green, //change text color of button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 15.0,
                    ),
                    child: Text(
                      'Tìm kiếm',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      // Navigator.pushReplacementNamed(context, '/thietbi',
                      //     arguments: epcSetLienTuc);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              timkiemthietbi(epcSetLienTuc: epcSetLienTuc),
                        ),
                      );
                    }),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          Colors.pinkAccent, //change background color of button
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              dieuchuyenhang(epcSetLienTuc: epcSetLienTuc),
                        ),
                      );
                    }),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          Colors.pinkAccent, //change background color of button
                      backgroundColor:
                          Colors.green, //change text color of button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 15.0,
                    ),
                    child: Text(
                      'Bảo trì',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              yeucaubaotri(epcSetLienTuc: epcSetLienTuc),
                        ),
                      );
                    }),
              ],
            ),

            Text(
              'Số sản phẩm: ${countLientuc}',
              style: TextStyle(color: Colors.blue.shade800, fontSize: 16),
            ),
            Container(
              width: double.infinity,
              height: 2,
              margin: EdgeInsets.symmetric(vertical: 8),
              color: Colors.blueAccent,
            ),
            ..._logs.map((String msg) => Card(
                  color: Colors.blue.shade50,
                  child: Container(
                    width: 330,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Log: $msg',
                      style: TextStyle(color: Colors.blue.shade800),
                    ),
                  ),
                )),
            ..._data.map((TagEpc tag) => Card(
                  color: Colors.blue.shade50,
                  child: Container(
                    width: 330,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Tag ${tag.epc} Count:${tag.count}',
                      style: TextStyle(color: Colors.blue.shade800),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // Widget _buildBottomSheet() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(20),
  //         topRight: Radius.circular(20),
  //       ),
  //     ),
  //     child: Padding(
  //       padding: EdgeInsets.all(20),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text("Bottom Sheet"),
  //           SizedBox(height: 20),
  //           Text("Content"),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

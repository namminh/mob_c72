// ignore_for_file: avoid_null_checks_on_nullable_types
import 'dart:convert';
import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mob_vietduc/widgets/drawer.dart';
import 'package:mob_vietduc/constants/Theme.dart';
import 'package:mob_vietduc/widgets/input.dart';
import 'package:mob_vietduc/widgets/navbar.dart';
import 'package:mob_vietduc/screens/scanqr.dart';
import 'package:mob_vietduc/screens/hoatdongbaotri.dart';

import 'package:shared_preferences/shared_preferences.dart';

class yeucaubaotri extends StatefulWidget {
  final Set<String> epcSetLienTuc;
  yeucaubaotri({
    Key key,
    this.epcSetLienTuc,
  }) : super(key: key);
  @override
  State<yeucaubaotri> createState() => _yeucaubaotriState();
}

class _yeucaubaotriState extends State<yeucaubaotri> {
  List yeucaubaotriList = [];
  List<dynamic> myList = [];
  List<dynamic> myThieBi = [];
  String ichoice = 'đóng';

  List<dynamic> filteredList = [];
  List<String> stringList = [];
  List<String> epcList = [];
  List<String> variantIds = [];
  List<String> barcodeIds = [];
  int count = 0;
  int testID = 10;
  String selectDieuChuyen;
  String iselect = 'New Request';
  String tempSelect;
  TextEditingController _textController = TextEditingController();
  String NoiDung = 'sửa';
  List<String> _statuses = ['New Request', 'In Progress', 'Repaired', 'Scrap'];
  int state = 1;
  var username;
  var password;
  @override
  initState() {
    setState(() {});
    super.initState();
    // getUsername();
    // getPassword();
    getDatayeucaubaotri();
    getDataThietbi();
  }

  Future<void> putTrangThai(int ids, int status) async {
    try {
      String username = 'nammta@gmail.com';
      String password = '123456';
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      var headers = {
        "Accept": "application/json",
        "Authorization": basicAuth,
      };
      Uri _uri = Uri.parse(
          'http://13.213.133.99/api/v1/write/maintenance.request?db=demo&ids=["${ids}"]&values={ "stage_id": ${status}}&with_context={}&with_company=1');

      http.Response response = await http.put(_uri, headers: headers);
      print(response.statusCode);
      print(response.body);
      print("namnm06_2 ${_uri}");
    } catch (error) {
      print(error);
    }
  }

  Future<void> getDatayeucaubaotri() async {
    final prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username') ?? '';
    password = prefs.getString('password') ?? '';

    print("usernameyeucaubaotri ${username}");
    print("password ${password}");
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    var headers = {
      "Accept": "application/json",
      "Authorization": basicAuth,
    };
    Uri _uri1 =
        Uri.parse('http://13.213.133.99/api/v1/custom/YeuCauBaoTri?db=demo');

    http.Response response = await http.get(_uri1, headers: headers);
    if (response.statusCode == 200) {
      print("_uri1 ${_uri1}");

      // Map<String, dynamic> myMap = json.decode(response.body)["result"];
      // myList = [];
      // if (myMap != null) {
      //   myList = myMap.values.toList().cast<dynamic>();
      // }

      dynamic myMap = json.decode(response.body)["result"];
      myList = myMap;
      print("myList ${myList}");
    } else {
      myList = [];
      print("danh sach rong ${myList}");
    }
    setState(() {
      ichoice = 'đóng';
    });
  }

  Future<void> postData(List<String> barcodeList) async {
    try {
      // String username = 'nammta@gmail.com';
      // String password = '123456';
      print("username yeu cau sua ${username}");
      print("password ${password}");
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      var headers = {
        "Accept": "application/json",
        "Authorization": basicAuth,
      };
      print("Gia tri barcode ${barcodeList}");

      barcodeIds = myThieBi
          .where((element) => epcList.contains(element['barcode']))
          .map((element) => element['barcode'].toString())
          .toList();
      variantIds = myThieBi
          .where((element) => barcodeIds.contains(element['barcode']))
          .map((element) => element['id'].toString())
          .toList();
      print("Gia tri variantIds ${variantIds}");
      print("Gia tri barcodeIds ${barcodeIds}");
      print("Gia tri NoiDung ${NoiDung}");
      var apiUrl =
          'http://13.213.133.99/api/v1/create/maintenance.request?db=demo&ids=[9999]&values={"equipment_id":,"name":"sửa"}';
      for (var i = 0; i < variantIds.length; i++) {
        var productId =
            int.parse(variantIds[i].replaceAll('[', '').replaceAll(']', ''));
        print("product_ids ${productId}");
        var url = apiUrl
            .replaceAll('"equipment_id":', '"equipment_id":$productId')
            .replaceAll('"name":"sửa"', '"name":"$NoiDung"');

        // Thực hiện request HTTP tại URL mới
        http.Response response =
            await http.post(Uri.parse(url), headers: headers);
        print(response.statusCode);
        print(response.body);
        print("namnm06_1 $url");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              children: [
                Text(
                    'Đã nhập thêm yêu cầu bảo trì với thiết bị ! ${barcodeIds[i]}'),
              ],
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        await Future.delayed(Duration(milliseconds: 200));
      }
    } catch (error) {
      print(error);
      Text('Đã xảy ra lỗi ! ${error}');
    }
  }

  Future<void> getDataThietbi() async {
    try {
      String username = 'nammta@gmail.com';
      String password = '123456';
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      var headers = {
        "Accept": "application/json",
        "Authorization": basicAuth,
      };
      Uri _uri =
          Uri.parse('http://13.213.133.99/api/v1/custom/TrangThietBi?db=demo');

      http.Response response = await http.get(_uri, headers: headers);
      dynamic myMap1 = json.decode(response.body)["result"];
      myThieBi = myMap1;
      // epcList = [
      //   'E280117000000213900A68AF',
      //   // 'E2801170000002139004E900',
      //   // 'E28011700000021390005506',
      //   // 'E280117000000213900490C8',
      //   // 'E2801170000002139005026C',
      //   // 'E2801170000002139002559C',
      //   // 'E28011700000021390050D9E',
      //   // 'E280117000000213900B5B4E',
      //   // 'E28011700000021390033325',
      //   // 'E28011700000021390042315'
      // ];

      print("namnm06 ${_uri}");
      if (widget.epcSetLienTuc != null) {
        List<String> dataList = widget.epcSetLienTuc
            .toString()
            .split(','); // tách chuỗi thành các phần tử

        for (String element in dataList) {
          if (element.contains('EPC:')) {
            epcList.add(element.substring(
                5, 33)); // cắt chuỗi từ vị trí thứ 4 để lấy giá trị EPC
          }
        }
        print("namnm07 ${dataList}");
      }

      // print("namnm08 ${myThieBi}");
      print("namnm09 ${epcList}");

      stringList = myThieBi
          .where((element) => epcList.contains(element['barcode']))
          .map((element) => element['display_name'].toString())
          .toList();

      print("namnm11 ${stringList}");
    } catch (error) {
      print(error);
      Text('Đã xảy ra lỗi ! ${error}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Yêu cầu bảo trì"),
        ),
        backgroundColor: ArgonColors.bgColorScreen,
        drawer: ArgonDrawer(currentPage: "yeucaubaotri"),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(right: 12, left: 12, bottom: 18),
              child: SafeArea(
                bottom: true,
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () async {
                              getDataThietbi();
                              await postData(epcList);

                              setState(() {
                                getDatayeucaubaotri();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.pinkAccent,
                              backgroundColor: Colors.yellow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 15.0,
                            ),
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 16.0,
                                    right: 16.0,
                                    top: 12,
                                    bottom: 12),
                                child: Text("Yêu cầu bảo trì",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0))),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => scanqr(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.pinkAccent,
                              backgroundColor: Colors.yellow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 15.0,
                            ),
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 16.0,
                                    right: 16.0,
                                    top: 12,
                                    bottom: 12),
                                child: Text("SCAN QR",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0))),
                          ),
                        ]),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 20, right: 20, top: 5, bottom: 5),
                          hintText: "Nhập nội dung cần bảo trì",
                        ),
                        onChanged: (_textController) {
                          setState(() {
                            NoiDung = _textController;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 150.0, // set the width to 150.0
                      child: DropdownButton<String>(
                        value: iselect ?? 'New Request',
                        items: <String>[
                          'New Request',
                          'In Progress',
                          'Repaired',
                          'Scrap'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (selectDieuChuyen) {
                          getDatayeucaubaotri();
                          print("selectDieuChuyen ${selectDieuChuyen}");
                          setState(() {
                            iselect = selectDieuChuyen ?? 'New Request';
                          });
                        },
                      ),
                    ),
                    Offstage(
                        offstage: ichoice != "đóng",
                        child: SingleChildScrollView(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: myList.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (myList[index]["stage_id"][1].toString() !=
                                    iselect) {
                                  return SizedBox.shrink();
                                }
                                return GestureDetector(
                                    onTap: () {
                                      // getDatayeucaubaotri();
                                      // Hàm xử lý sự kiện khi nhấn vào Card ở đây
                                      print(
                                          'Bạn đã nhấn vào Card với display_name là ${myList[index]["display_name"].toString()}');
                                      // postPlan(
                                      //     myList[index]["equipment_id"][0]);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => hoatdongbaotri(
                                              equipmentid: myList[index]
                                                      ["equipment_id"][1]
                                                  .toString(),
                                              ID: myList[index]["equipment_id"]
                                                  [0]),
                                        ),
                                      );
                                    },
                                    child: Card(
                                        child: ListTile(
                                            title: Row(children: [
                                              Text(
                                                  '    ID: ${myList[index]["id"].toString()}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                  )),
                                              DropdownButton<String>(
                                                value: myList[index]["stage_id"]
                                                        [1]
                                                    .toString(),
                                                items: _statuses
                                                    .map((String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    myList[index]["stage_id"]
                                                        [1] = newValue;
                                                    if (newValue ==
                                                        "New Request") {
                                                      state = 1;
                                                    } else if (newValue ==
                                                        "In Progress") {
                                                      state = 2;
                                                    } else if (newValue ==
                                                        "Repaired") {
                                                      state = 3;
                                                    } else if (newValue ==
                                                        "Scrap") {
                                                      state = 4;
                                                    }
                                                    putTrangThai(
                                                        myList[index]["id"],
                                                        state);
                                                  });
                                                },
                                              ),
                                            ]),
                                            subtitle: Column(
                                              children: [
                                                Row(children: [
                                                  Text('Ngày tạo:   '),
                                                  Text(myList[index]
                                                          ["request_date"]
                                                      .toString()),
                                                ]),
                                                // Row(
                                                //   children: [
                                                //     Text('Tên yêu cầu: '),
                                                //     Expanded(
                                                //       child: Text(
                                                //         myList[index]["name"]
                                                //             .toString(),
                                                //         style: TextStyle(
                                                //           fontSize: 16,
                                                //           fontWeight:
                                                //               FontWeight.bold,
                                                //           color: Colors.blue,
                                                //         ),
                                                //       ),
                                                //     ),
                                                //   ],
                                                // ),
                                                Row(children: [
                                                  Text('Tên thiết bị:   '),
                                                  Expanded(
                                                    child: Text(
                                                      myList[index]
                                                              ["equipment_id"]
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                                Row(children: [
                                                  Text('Đội bảo trì:   '),
                                                  Text(
                                                      myList[index][
                                                              "maintenance_team_id"][1]
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue,
                                                      )),
                                                ]),
                                                // Row(children: [
                                                //   Text('Loại bảo trì:   '),
                                                //   Text(
                                                //       myList[index][
                                                //               "maintenance_kind_id"]
                                                //           .toString(),
                                                //       style: TextStyle(
                                                //         fontSize: 16,
                                                //         fontWeight:
                                                //             FontWeight.bold,
                                                //         color: Colors.blue,
                                                //       )),
                                                // ]),
                                                Row(children: [
                                                  Text('Người tạo:   '),
                                                  Text(
                                                      myList[index]
                                                              ["employee_id"]
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.green,
                                                      )),
                                                ]),
                                                Row(children: [
                                                  Text(
                                                      'Nhân viên kỹ thuật:   '),
                                                  Expanded(
                                                    child: Text(
                                                      myList[index]["user_id"]
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                              ],
                                            ))));
                              }),
                        )),
                  ],
                ),
              )),
        ));
  }
}

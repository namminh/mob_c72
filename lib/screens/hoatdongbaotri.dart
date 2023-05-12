// ignore_for_file: avoid_null_checks_on_nullable_types
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mob_vietduc/widgets/drawer.dart';
import 'package:mob_vietduc/constants/Theme.dart';
import 'package:mob_vietduc/widgets/input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class hoatdongbaotri extends StatefulWidget {
  final String equipmentid;
  final int ID;
  hoatdongbaotri({
    Key key,
    this.equipmentid,
    this.ID,
  }) : super(key: key);
  @override
  State<hoatdongbaotri> createState() => _hoatdongbaotriState();
}

class _hoatdongbaotriState extends State<hoatdongbaotri> {
  List hoatdongbaotriList = [];
  List<dynamic> filteredList = [];
  List<dynamic> myList = [];
  String ichoice = 'đóng';
  List<String> epcList = [];

  List<bool> icheck_ngoai;
  List<bool> icheck_nguon;

  List<bool> icheck_ket;
  List<bool> icheck_nang;
  List<bool> icheck_hien;
  List<bool> icheck_cap;
  List<bool> icheck_bang;

  List<String> S_icheck_ngoai;
  List<String> S_icheck_nguon;
  List<String> S_icheck_ket;
  List<String> S_icheck_nang;
  List<String> S_icheck_hien;
  List<String> S_icheck_cap;
  List<String> S_icheck_bang;
  int thietbiID;
  var username;
  var password;
  String TempEquipmentid;
  String status;

  @override
  initState() {
    setState(() {});
    super.initState();
    getDatahoatdongbaotri();
  }

  Future<void> postPlan(int id) async {
    try {
      String username1 = 'nammta@gmail.com';
      String password1 = '123456';
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username1:$password1'));
      var headers = {
        "Accept": "application/json",
        "Authorization": basicAuth,
      };
      Uri _uri = Uri.parse(
          'http://13.213.133.99/api/v1/create/maintenance.plan?db=demo&ids=[9999]&values={"equipment_id": ${id},"name":"${username}"}');

      http.Response response = await http.post(_uri, headers: headers);
      print(response.statusCode);
      print(response.body);
      print("namnm06_2 ${_uri}");
    } catch (error) {
      print(error);
    }
  }

  getDatahoatdongbaotri() async {
    TempEquipmentid = widget.equipmentid;
    thietbiID = widget.ID;
    print("thietbiID ${thietbiID}");
    // String username = 'nammta@gmail.com';
    // String password = '123456';
    final prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username') ?? '';
    password = prefs.getString('password') ?? '';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    var headers = {
      "Accept": "application/json",
      "Authorization": basicAuth,
    };
    Uri _uri =
        Uri.parse('http://13.213.133.99/api/v1/custom/hoatdongbaotri?db=demo');

    http.Response response = await http.get(_uri, headers: headers);
    if (response.statusCode == 200) {
      dynamic myMap = json.decode(response.body)["result"];
      myList = myMap;
      print("myList ${myList}");
      // hoatdongbaotriList = myList.map((item) => item["barcode"]).toList();
      // myList = filteredList
      //     .where((element) => element['equipment_id'][1] == TempEquipmentid)
      //     .toList();

      setState(() {
        icheck_ngoai = List.generate(
          myList.length,
          (index) =>
              myList[index]["x_ngoai_hinh"].toString() == "Đạt" ? true : false,
        );
        icheck_nguon = List.generate(
          myList.length,
          (index) =>
              myList[index]["x_nguon_dien"].toString() == "Đạt" ? true : false,
        );

        icheck_ket = List.generate(
          myList.length,
          (index) =>
              myList[index]["x_ket_noi"].toString() == "Đạt" ? true : false,
        );
        icheck_nang = List.generate(
          myList.length,
          (index) =>
              myList[index]["x_nang_luong"].toString() == "Đạt" ? true : false,
        );
        icheck_hien = List.generate(
          myList.length,
          (index) =>
              myList[index]["x_hien_thi"].toString() == "Đạt" ? true : false,
        );
        icheck_cap = List.generate(
          myList.length,
          (index) => myList[index]["x_cap"].toString() == "Đạt" ? true : false,
        );
        icheck_bang = List.generate(
          myList.length,
          (index) => myList[index]["x_bang_dieu_khien"].toString() == "Đạt"
              ? true
              : false,
        );

        S_icheck_ngoai = List.generate(
            myList.length, (index) => myList[index]["x_ngoai_hinh"].toString());

        S_icheck_nguon = List.generate(
            myList.length, (index) => myList[index]["x_nguon_dien"].toString());

        S_icheck_ket = List.generate(
            myList.length, (index) => myList[index]["x_ket_noi"].toString());

        S_icheck_nang = List.generate(
            myList.length, (index) => myList[index]["x_nang_luong"].toString());

        S_icheck_hien = List.generate(
            myList.length, (index) => myList[index]["x_hien_thi"].toString());
        S_icheck_cap = List.generate(
            myList.length, (index) => myList[index]["x_cap"].toString());
        S_icheck_bang = List.generate(myList.length,
            (index) => myList[index]["x_bang_dieu_khien"].toString());

        // thietbiID = myList[index]["equipment_id"][0];
        ichoice = 'đóng';
      });
    } else {
      myList = [];
    }
  }

  Future<void> putTrangThai(int ids, String Loai, String status) async {
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
          'http://13.213.133.99/api/v1/write/maintenance.plan?db=demo&ids=["${ids}"]&values={ "${Loai}": "${status}"}&with_context={}&with_company=1');

      http.Response response = await http.put(_uri, headers: headers);
      print(response.statusCode);
      print(response.body);
      print("namnm06_2 ${_uri}");
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hoạt động bảo trì"),
        ),
        backgroundColor: ArgonColors.bgColorScreen,
        drawer: ArgonDrawer(currentPage: "hoatdongbaotri"),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(right: 12, left: 12, bottom: 18),
              child: SafeArea(
                bottom: true,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await postPlan(thietbiID);
                        setState(() {
                          getDatahoatdongbaotri();
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
                              left: 16.0, right: 16.0, top: 12, bottom: 12),
                          child: Text("Thêm mới hoạt động bảo trì",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0))),
                    ),
                    Offstage(
                        offstage: false,
                        child: SingleChildScrollView(
                          child: ListView.builder(
                            shrinkWrap: true,
                            reverse: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: myList.length,
                            itemBuilder: (BuildContext context, int index) {
                              print("thietbiID ${thietbiID}");
                              if (myList[index]["equipment_id"][0] !=
                                  thietbiID) {
                                return SizedBox.shrink();
                              }
                              return Card(
                                  // leading: CircleAvatar(
                                  //   backgroundImage: NetworkImage(pokemonList[index]["img"]),
                                  // ),

                                  child: ListTile(
                                      title: Row(children: []),
                                      subtitle: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text('Người tạo yêu cầu: '),
                                              Expanded(
                                                child: Text(
                                                  myList[index]["name"]
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text('Tên thiết bị: '),
                                              Expanded(
                                                child: Text(
                                                  myList[index]["equipment_id"]
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text('Ngày bảo trì: '),
                                              Expanded(
                                                child: Text(
                                                  myList[index][
                                                          "start_maintenance_date"]
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                  'Ngày bảo trì tiếp theo: '),
                                              Expanded(
                                                child: Text(
                                                  myList[index][
                                                          "next_maintenance_date"]
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                  'Tần suất: ${myList[index]["interval"].toString()} ${myList[index]["interval_step"].toString()}'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Nguồn điện: ',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  // Text('Remember me'),
                                                  Text(
                                                    S_icheck_nguon[index],
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  Checkbox(
                                                    value: icheck_nguon[index],
                                                    onChanged: (bool newValue) {
                                                      setState(() {
                                                        if (newValue) {
                                                          icheck_nguon[index] =
                                                              newValue;
                                                          putTrangThai(
                                                              myList[index]
                                                                  ["id"],
                                                              "x_nguon_dien",
                                                              "Đạt");
                                                          S_icheck_nguon[
                                                              index] = "Đạt";
                                                        } else {
                                                          icheck_nguon[index] =
                                                              newValue;
                                                          putTrangThai(
                                                              myList[index]
                                                                  ["id"],
                                                              "x_nguon_dien",
                                                              "Lỗi");
                                                          S_icheck_nguon[
                                                              index] = "Lỗi";
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Offstage(
                                            offstage:
                                                S_icheck_nguon[index] != "Lỗi",
                                            child: TextFormField(
                                              initialValue: myList[index]
                                                      ['x_nguon_dien_false']
                                                  .toString(),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                    left: 0,
                                                    right: 0,
                                                    top: 5,
                                                    bottom: 5),
                                                hintText: "nhập lỗi nếu có",
                                              ),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  putTrangThai(
                                                      myList[index]["id"],
                                                      "x_nguon_dien_false",
                                                      "${newValue}");
                                                });
                                              },
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Ngoại hình: ',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    S_icheck_ngoai[index],
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  Checkbox(
                                                    value: icheck_ngoai[index],
                                                    onChanged: (bool newValue) {
                                                      setState(() {
                                                        if (newValue) {
                                                          icheck_ngoai[index] =
                                                              newValue;
                                                          putTrangThai(
                                                              myList[index]
                                                                  ["id"],
                                                              "x_ngoai_hinh",
                                                              "Đạt");
                                                          S_icheck_ngoai[
                                                              index] = "Đạt";
                                                        } else {
                                                          icheck_ngoai[index] =
                                                              newValue;
                                                          putTrangThai(
                                                              myList[index]
                                                                  ["id"],
                                                              "x_ngoai_hinh",
                                                              "Lỗi");
                                                          S_icheck_ngoai[
                                                              index] = "Lỗi";
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Offstage(
                                            offstage:
                                                S_icheck_ngoai[index] != "Lỗi",
                                            child: TextFormField(
                                              initialValue: myList[index]
                                                      ['x_ngoai_hinh_false']
                                                  .toString(),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                    left: 0,
                                                    right: 0,
                                                    top: 5,
                                                    bottom: 5),
                                                hintText: "nhập lỗi nếu có",
                                              ),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  putTrangThai(
                                                      myList[index]["id"],
                                                      "x_ngoai_hinh_false",
                                                      "${newValue}");
                                                });
                                              },
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Kết nối: ',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    S_icheck_ket[index],
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  Checkbox(
                                                    value: icheck_ket[index],
                                                    onChanged: (bool newValue) {
                                                      setState(() {
                                                        if (newValue) {
                                                          icheck_ket[index] =
                                                              newValue;
                                                          putTrangThai(
                                                              myList[index]
                                                                  ["id"],
                                                              "x_ket_noi",
                                                              "Đạt");
                                                          S_icheck_ket[index] =
                                                              "Đạt";
                                                        } else {
                                                          icheck_ket[index] =
                                                              newValue;
                                                          putTrangThai(
                                                              myList[index]
                                                                  ["id"],
                                                              "x_ket_noi",
                                                              "Lỗi");
                                                          S_icheck_ket[index] =
                                                              "Lỗi";
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Offstage(
                                            offstage:
                                                S_icheck_ket[index] != "Lỗi",
                                            child: TextFormField(
                                              initialValue: myList[index]
                                                      ['x_ket_noi_false']
                                                  .toString(),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                    left: 0,
                                                    right: 0,
                                                    top: 5,
                                                    bottom: 5),
                                                hintText: "nhập lỗi nếu có",
                                              ),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  putTrangThai(
                                                      myList[index]["id"],
                                                      "x_ket_noi_false",
                                                      "${newValue}");
                                                });
                                              },
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Năng lượng: ',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    S_icheck_nang[index],
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  Checkbox(
                                                    value: icheck_nang[index],
                                                    onChanged: (bool newValue) {
                                                      setState(() {
                                                        if (newValue) {
                                                          icheck_nang[index] =
                                                              newValue;
                                                          putTrangThai(
                                                              myList[index]
                                                                  ["id"],
                                                              "x_nang_luong",
                                                              "Đạt");
                                                          S_icheck_nang[index] =
                                                              "Đạt";
                                                        } else {
                                                          icheck_nang[index] =
                                                              newValue;
                                                          putTrangThai(
                                                              myList[index]
                                                                  ["id"],
                                                              "x_nang_luong",
                                                              "Lỗi");
                                                          S_icheck_nang[index] =
                                                              "Lỗi";
                                                        }
                                                        print(
                                                            "S_icheck_nang[index]  ${S_icheck_nang[index]}");
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Offstage(
                                            offstage:
                                                S_icheck_nang[index] != "Lỗi",
                                            child: TextFormField(
                                              initialValue: myList[index]
                                                      ['x_nang_luong_false']
                                                  .toString(),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                    left: 0,
                                                    right: 0,
                                                    top: 5,
                                                    bottom: 5),
                                                hintText: "nhập lỗi nếu có",
                                              ),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  putTrangThai(
                                                      myList[index]["id"],
                                                      "x_nang_luong_false",
                                                      "${newValue}");
                                                });
                                              },
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Hiển thị: ',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    S_icheck_hien[index],
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  Checkbox(
                                                    value: icheck_hien[index],
                                                    onChanged: (bool newValue) {
                                                      setState(() {
                                                        if (newValue) {
                                                          icheck_hien[index] =
                                                              newValue;
                                                          putTrangThai(
                                                              myList[index]
                                                                  ["id"],
                                                              "x_hien_thi",
                                                              "Đạt");
                                                          S_icheck_hien[index] =
                                                              "Đạt";
                                                        } else {
                                                          icheck_hien[index] =
                                                              newValue;
                                                          putTrangThai(
                                                              myList[index]
                                                                  ["id"],
                                                              "x_hien_thi",
                                                              "Lỗi");
                                                          S_icheck_hien[index] =
                                                              "Lỗi";
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Offstage(
                                            offstage:
                                                S_icheck_hien[index] != "Lỗi",
                                            child: TextFormField(
                                              initialValue: myList[index]
                                                      ['x_hien_thi_false']
                                                  .toString(),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                    left: 0,
                                                    right: 0,
                                                    top: 5,
                                                    bottom: 5),
                                                hintText: "nhập lỗi nếu có",
                                              ),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  putTrangThai(
                                                      myList[index]["id"],
                                                      "x_hien_thi_false",
                                                      "${newValue}");
                                                });
                                              },
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Cáp: ',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    S_icheck_cap[index],
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  Checkbox(
                                                    value: icheck_cap[index],
                                                    onChanged: (bool newValue) {
                                                      setState(() {
                                                        if (newValue) {
                                                          icheck_cap[index] =
                                                              newValue;
                                                          putTrangThai(
                                                              myList[index]
                                                                  ["id"],
                                                              "x_cap",
                                                              "Đạt");
                                                          S_icheck_cap[index] =
                                                              "Đạt";
                                                        } else {
                                                          icheck_cap[index] =
                                                              newValue;
                                                          putTrangThai(
                                                              myList[index]
                                                                  ["id"],
                                                              "x_cap",
                                                              "Lỗi");
                                                          S_icheck_cap[index] =
                                                              "Lỗi";
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Offstage(
                                            offstage:
                                                S_icheck_cap[index] != "Lỗi",
                                            child: TextFormField(
                                              initialValue: myList[index]
                                                      ['x_cap_false']
                                                  .toString(),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                    left: 0,
                                                    right: 0,
                                                    top: 5,
                                                    bottom: 5),
                                                hintText: "nhập lỗi nếu có",
                                              ),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  putTrangThai(
                                                      myList[index]["id"],
                                                      "x_cap_false",
                                                      "${newValue}");
                                                });
                                              },
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Bảng điều khiển: ',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    S_icheck_bang[index],
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  Checkbox(
                                                    value: icheck_bang[index],
                                                    onChanged: (bool newValue) {
                                                      setState(() {
                                                        if (newValue) {
                                                          icheck_bang[index] =
                                                              newValue;
                                                          putTrangThai(
                                                              myList[index]
                                                                  ["id"],
                                                              "x_bang_dieu_khien",
                                                              "Đạt");
                                                          S_icheck_bang[index] =
                                                              "Đạt";
                                                        } else {
                                                          icheck_bang[index] =
                                                              newValue;
                                                          putTrangThai(
                                                              myList[index]
                                                                  ["id"],
                                                              "x_bang_dieu_khien",
                                                              "Lỗi");
                                                          S_icheck_bang[index] =
                                                              "Lỗi";
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Offstage(
                                            offstage:
                                                S_icheck_bang[index] != "Lỗi",
                                            child: TextFormField(
                                              initialValue: myList[index][
                                                      'x_bang_dieu_khien_false']
                                                  .toString(),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                    left: 0,
                                                    right: 0,
                                                    top: 5,
                                                    bottom: 5),
                                                hintText: "nhập lỗi nếu có",
                                              ),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  putTrangThai(
                                                      myList[index]["id"],
                                                      "x_bang_dieu_khien_false",
                                                      "${newValue}");
                                                });
                                              },
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text('Kiểm tra khác: '),
                                            ],
                                          ),
                                          TextFormField(
                                            initialValue: myList[index]
                                                    ['x_kiem_tra_khac']
                                                .toString(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                putTrangThai(
                                                    myList[index]["id"],
                                                    "x_kiem_tra_khac",
                                                    "${newValue}");
                                              });
                                            },
                                          ),
                                        ],
                                      )));
                            },
                          ),
                        )),
                  ],
                ),
              )),
        ));
  }
}

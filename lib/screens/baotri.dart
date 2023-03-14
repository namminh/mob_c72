// ignore_for_file: avoid_null_checks_on_nullable_types
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mob_vietduc/widgets/drawer.dart';
import 'package:mob_vietduc/constants/Theme.dart';
import 'package:mob_vietduc/widgets/input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class baotri extends StatefulWidget {
  final Set<String> epcSetLienTuc;
  baotri({
    Key key,
    this.epcSetLienTuc,
  }) : super(key: key);
  @override
  State<baotri> createState() => _baotriState();
}

class _baotriState extends State<baotri> {
  List baotriList = [];
  List<dynamic> myList = [];
  String ichoice = 'đóng';
  List<String> epcList = [];
  String MaNoiBo = '';
  TextEditingController _textController = TextEditingController();
  var username;
  var password;
  @override
  initState() {
    setState(() {});
    super.initState();
    getDatabaotri();
    // getUsername();
    // getPassword();
    // Timer.periodic(Duration(seconds: 20), (timer) {
    //   // Gọi hàm cập nhật dữ liệu mỗi khi thời gian đến
    //   getDatabaotri();
    // });
  }

  getDatabaotri() async {
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
        Uri.parse('http://13.213.133.99/api/v1/custom/TrangThietBi?db=demo');

    http.Response response = await http.get(_uri, headers: headers);
    Map<String, dynamic> myMap = json.decode(response.body);
    myList = myMap["result"];
    print("namnm05 ${myList}");
    // baotriList = myList.map((item) => item["barcode"]).toList();
    print("namnm06 ${_uri}");
    setState(() {
      ichoice = 'đóng';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Trang Thiết bị bảo trì"),
        ),
        backgroundColor: ArgonColors.bgColorScreen,
        drawer: ArgonDrawer(currentPage: "baotri"),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(right: 12, left: 12, bottom: 18),
              child: SafeArea(
                bottom: true,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 20, right: 20, top: 5, bottom: 5),
                          hintText: "Nhập mã nội bộ",
                        ),
                        onChanged: (_textController) {
                          setState(() {
                            MaNoiBo = _textController;
                          });
                        },
                      ),
                    ),
                    Offstage(
                        offstage: ichoice != "đóng",
                        child: SingleChildScrollView(
                          child: ListView.builder(
                            shrinkWrap: true,
                            reverse: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: myList.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (!myList[index]["x_internal_code"]
                                  .toString()
                                  .toLowerCase()
                                  .contains(MaNoiBo.toLowerCase())) {
                                return SizedBox.shrink();
                              }
                              return Card(
                                  // leading: CircleAvatar(
                                  //   backgroundImage: NetworkImage(pokemonList[index]["img"]),
                                  // ),

                                  child: ListTile(
                                      title: Row(children: [
                                        Text(myList[index]["barcode"]
                                            .toString()),
                                      ]),
                                      subtitle: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text('Mã nội bộ: '),
                                              Expanded(
                                                child: Text(
                                                  myList[index]
                                                          ["x_internal_code"]
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
                                          Row(children: [
                                            Text('Ngày tạo:   '),
                                            Text(myList[index]["create_date"]
                                                .toString()),
                                          ]),
                                          Row(
                                            children: [
                                              Text('Tên thiết bị: '),
                                              Expanded(
                                                child: Text(
                                                  myList[index]["display_name"],
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Row(children: [
                                          //   Text('Khoa: '),
                                          //   Text(
                                          //       myList[index]["department_id"]
                                          //               [1]
                                          //           .toString(),
                                          //       style: TextStyle(
                                          //           fontSize: 16,
                                          //           fontWeight: FontWeight.bold,
                                          //           color: Colors.red)),
                                          // ]),
                                          // Row(children: [
                                          //   Text('Hãng sản xuất: '),
                                          //   Text(
                                          //       myList[index]["partner_id"][1]
                                          //           ,
                                          //       style: TextStyle(
                                          //           fontSize: 16,
                                          //           fontWeight: FontWeight.bold,
                                          //           color: Colors.red)),
                                          // ]),
                                          Row(children: [
                                            Text('Giá Vốn: '),
                                            Text(
                                                myList[index]["cost"]
                                                    .toString()
                                                    .split(".")[0],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red)),
                                            Text('VNĐ'),
                                          ]),
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

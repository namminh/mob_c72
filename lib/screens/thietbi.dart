// ignore_for_file: avoid_null_checks_on_nullable_types
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mob_vietduc/widgets/drawer.dart';
import 'package:mob_vietduc/constants/Theme.dart';
import 'package:mob_vietduc/widgets/input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class thietbi extends StatefulWidget {
  final Set<String> epcSetLienTuc;
  thietbi({
    Key key,
    this.epcSetLienTuc,
  }) : super(key: key);
  @override
  State<thietbi> createState() => _thietbiState();
}

class _thietbiState extends State<thietbi> {
  List thietbiList = [];
  List<dynamic> myList = [];
  String ichoice = 'đóng';
  List<String> epcList = [];
  TextEditingController _textController = TextEditingController();
  String MaNoiBo = '';
  var username;
  var password;
  @override
  initState() {
    setState(() {});
    super.initState();
    getDataThietbi();

    // Timer.periodic(Duration(seconds: 20), (timer) {
    //   // Gọi hàm cập nhật dữ liệu mỗi khi thời gian đến
    //   getDataThietbi();
    // });
  }

  getDataThietbi() async {
    myList = [];
    final prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username') ?? '';
    password = prefs.getString('password') ?? '';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    var headers = {
      "Accept": "application/json",
      "Authorization": basicAuth,
    };
    Uri _uri = Uri.parse('http://13.213.133.99/api/v1/custom/vattu?db=demo');

    http.Response response = await http.get(_uri, headers: headers);
    print(response.statusCode);
    if (response.statusCode == 200) {
      dynamic myMap = json.decode(response.body)["result"];
      myList = myMap;

      for (int i = 0; i < myList.length; i++) {
        if (myList[i]["x_co_so_dat"] > myList[i]["qty_available"]) {
          myList[i]["x_bu_hang"] =
              (myList[i]["x_co_so_dat"] - myList[i]["qty_available"])
                  .toString();
          putBuHang(myList[i]["id"], double.parse(myList[i]["x_bu_hang"]));
        } else {
          myList[i]["x_bu_hang"] = "0";
          putBuHang(myList[i]["id"], double.parse(myList[i]["x_bu_hang"]));
        }
      }
      myList.removeWhere((element) => element["x_bu_hang"] == 0);

      myList.sort((a, b) =>
          a["x_bu_hang"].toString().compareTo(b["x_bu_hang"].toString()));
    } else {
      myList = [];
    }

    print("namnm06 ${_uri}");
    setState(() {
      ichoice = 'đóng';
    });
  }

  Future<void> putBuHang(int ids, double x_bu_hang) async {
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
          'http://13.213.133.99/api/v1/write/product.template?db=demo&ids=["${ids}"]&values={ "x_bu_hang": ${x_bu_hang}}&with_context={}&with_company=1');

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
          title: Text("Vật tư"),
        ),
        backgroundColor: ArgonColors.bgColorScreen,
        drawer: ArgonDrawer(currentPage: "thietbi"),
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
                              if (!myList[index]["default_code"]
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
                                      title: Column(children: [
                                        Text(myList[index]["barcode"]
                                            .toString()),
                                        Row(
                                          children: [
                                            if (double.parse(myList[index]
                                                    ["x_bu_hang"]) >
                                                0)
                                              IconButton(
                                                icon: Icon(Icons.star,
                                                    color: Colors.yellow),
                                                onPressed: () {},
                                              ),
                                            Text('Bù hàng: '),
                                            Text(
                                                myList[index]["x_bu_hang"]
                                                    .toString()
                                                    .split(".")[0],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red)),
                                            Text(' Cái'),
                                          ],
                                        ),
                                      ]),
                                      subtitle: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text('Mã nội bộ: '),
                                              Expanded(
                                                child: Text(
                                                  myList[index]["default_code"]
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
                                              Text('Tên vật tư: '),
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
                                              Text('Hãng sản xuất: '),
                                              Expanded(
                                                child: Text(
                                                  myList[index]
                                                          ["x_hang_san_xuat"]
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
                                              Text('Tên nhà cung cấp: '),
                                              Expanded(
                                                child: Text(
                                                  myList[index]
                                                          ["x_ten_nha_cung_cap"]
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
                                              Text('Quy cách: '),
                                              Expanded(
                                                child: Text(
                                                  myList[index][
                                                          "x_quy_canh_hang_hoa"]
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
                                            Text('Giá Bán: '),
                                            Text(
                                                myList[index]["list_price"]
                                                    .toString()
                                                    .split(".")[0],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red)),
                                            Text('VNĐ'),
                                          ]),
                                          Row(
                                            children: [
                                              Text('Trong kho: '),
                                              Text(
                                                  myList[index]["qty_available"]
                                                      .toString()
                                                      .split(".")[0],
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red)),
                                              Text(' Cái'),
                                            ],
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

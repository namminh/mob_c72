// ignore_for_file: avoid_null_checks_on_nullable_types
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mob_vietduc/widgets/drawer.dart';
import 'package:mob_vietduc/constants/Theme.dart';
import 'package:mob_vietduc/widgets/input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mob_vietduc/screens/hoatdongbaotri.dart';

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
  List filteredList = [];
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
    String username = 'nammta@gmail.com';
    String password = '123456';
    // final prefs = await SharedPreferences.getInstance();
    // username = prefs.getString('username') ?? '';
    // password = prefs.getString('password') ?? '';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    var headers = {
      "Accept": "application/json",
      "Authorization": basicAuth,
    };
    Uri _uri =
        Uri.parse('http://13.213.133.99/api/v1/custom/TrangThietBi?db=demo');

    http.Response response = await http.get(_uri, headers: headers);
    if (response.statusCode == 200) {
      dynamic myMap = json.decode(response.body)["result"];
      myList = myMap;
      print("namnm05 ${myList}");
      print("namnm07 ${widget.epcSetLienTuc.toString()}");
      List<String> epcList = [];

      List<String> dataList = widget.epcSetLienTuc
          .toString()
          .split(','); // tách chuỗi thành các phần tử

      for (String element in dataList) {
        if (element.contains('EPC:')) {
          epcList.add(element.substring(
              5, 33)); // cắt chuỗi từ vị trí thứ 4 để lấy giá trị EPC
        }
      }
      // baotriList = myList.map((item) => item["barcode"]).toList();
      if (widget.epcSetLienTuc != null) {
        filteredList = myList
            .where((element) => epcList.contains(element['barcode']))
            .toList();
      } else {
        filteredList = myList;
      }
    } else {
      myList = [];
    }
    print("filteredList ${filteredList}");
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
                            itemCount: filteredList.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (!filteredList[index]["x_internal_code"]
                                  .toString()
                                  .toLowerCase()
                                  .contains(MaNoiBo.toLowerCase())) {
                                return SizedBox.shrink();
                              }
                              return GestureDetector(
                                  onTap: () {
                                    // getDatayeucaubaotri();
                                    // Hàm xử lý sự kiện khi nhấn vào Card ở đây
                                    print(
                                        'Bạn đã nhấn vào Card với display_name là ${filteredList[index]["display_name"].toString()}');
                                    // postPlan(
                                    //     myList[index]["equipment_id"][0]);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => hoatdongbaotri(
                                            equipmentid: filteredList[index]
                                                    ["name"]
                                                .toString(),
                                            ID: filteredList[index]["id"]),
                                      ),
                                    );
                                  },
                                  child: Card(
                                      // leading: CircleAvatar(
                                      //   backgroundImage: NetworkImage(pokemonList[index]["img"]),
                                      // ),

                                      child: ListTile(
                                          title: Column(children: [
                                            Text(filteredList[index]["barcode"]
                                                .toString()),
                                            Row(
                                              children: [
                                                Text(
                                                    'Tình trạng thiết bị: '),
                                                Expanded(
                                                  child: Text(
                                                    filteredList[index]["state"]
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
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
                                                      filteredList[index][
                                                              "x_internal_code"]
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(children: [
                                                Text('Ngày tạo:   '),
                                                Text(filteredList[index]
                                                        ["create_date"]
                                                    .toString()),
                                              ]),
                                              Row(
                                                children: [
                                                  Text('Tên thiết bị: '),
                                                  Expanded(
                                                    child: Text(
                                                      filteredList[index]
                                                          ["display_name"],
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color.fromARGB(
                                                            255, 156, 13, 192),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text('Số yêu cầu: '),
                                                  Expanded(
                                                    child: Text(
                                                      filteredList[index][
                                                              "maintenance_count"]
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                      'Số lần thực hiện : '),
                                                  Expanded(
                                                    child: Text(
                                                      filteredList[index][
                                                              "maintenance_plan_count"]
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text('Khoa phòng: '),
                                                  Expanded(
                                                    child: Text(
                                                      filteredList[index]
                                                              ["department_id"]
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // Row(
                                              //   children: [
                                              //     Text(
                                              //         'Lần bảo trì tiếp theo: '),
                                              //     Expanded(
                                              //       child: Text(
                                              //         filteredList[index][
                                              //                 "next_action_date"]
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
                                                Text('Giá Mua: '),
                                                Text(
                                                    filteredList[index]["cost"]
                                                        .toString()
                                                        .split(".")[0],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red)),
                                                Text('VNĐ'),
                                              ]),
                                              Row(
                                                children: [
                                                  Text(
                                                      'Đường dẫn tài liệu: '),
                                                  Expanded(
                                                    child: Text(
                                                      filteredList[index]["url"]
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ))));
                            },
                          ),
                        )),
                  ],
                ),
              )),
        ));
  }
}

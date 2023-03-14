// ignore_for_file: avoid_null_checks_on_nullable_types
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mob_vietduc/widgets/drawer.dart';
import 'package:mob_vietduc/constants/Theme.dart';

class danhsachdieuchuyen extends StatefulWidget {
  final String picking_id;
  danhsachdieuchuyen({
    Key key,
    this.picking_id,
  }) : super(key: key);
  @override
  State<danhsachdieuchuyen> createState() => _danhsachdieuchuyenState();
}

class _danhsachdieuchuyenState extends State<danhsachdieuchuyen> {
  List danhsachdieuchuyenList = [];
  List<dynamic> myList = [];
  List<dynamic> myThieBi = [];
  String ichoice = 'đóng';
  List<dynamic> filteredList = [];
  String tempPickingId;
  double qty;
  double value;
  TextEditingController _textController = TextEditingController();

  int index;
  // List<String> barcodes = [
  //   'E2801170000002139002559C',
  //   'E2801170000002139004E900',
  //   'E280117000000213900A68AF',
  // ];
  @override
  initState() {
    setState(() {});
    super.initState();
    getDatadanhsachdieuchuyen();
    // getDataThietbi();
  }

  getDatadanhsachdieuchuyen() async {
    tempPickingId = widget.picking_id;
    String username = 'nammta@gmail.com';
    String password = '123456';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    var headers = {
      "Accept": "application/json",
      "Authorization": basicAuth,
    };
    Uri _uri = Uri.parse(
        'http://13.213.133.99/api/v1/search_read/stock.move?db=demo&with_context&with_company=1');

    http.Response response = await http.get(_uri, headers: headers);
    myList = json.decode(response.body);
    // danhsachdieuchuyenList = myList.map((item) => item["barcode"]).toList();
    print("namnm06 ${_uri}");
    print("tempPickingId ${tempPickingId}");
    setState(() {
      ichoice = 'đóng';
    });
  }

  Future<void> putSoLuong(int ids, double product_uom_qty) async {
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
          'http://13.213.133.99/api/v1/write/stock.move?db=demo&ids=["${ids}"]&values={ "product_uom_qty": ${product_uom_qty}}&with_context={}&with_company=1');

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
          title: Text("Danh sách điều chuyển"),
        ),
        backgroundColor: ArgonColors.bgColorScreen,
        drawer: ArgonDrawer(currentPage: "danhsachdieuchuyen"),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(right: 12, left: 12, bottom: 18),
              child: SafeArea(
                bottom: true,
                child: Column(
                  children: [
                    Offstage(
                        offstage: ichoice != "đóng",
                        child: SingleChildScrollView(
                          child: ListView.builder(
                            shrinkWrap: true,
                            reverse: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: myList.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (!myList[index]["picking_id"]
                                  .toString()
                                  .toLowerCase()
                                  .contains(tempPickingId.toLowerCase())) {
                                return SizedBox.shrink();
                              }
                              return InkWell(
                                  child: Card(
                                      // leading: CircleAvatar(
                                      //   backgroundImage: NetworkImage(pokemonList[index]["img"]),
                                      // ),

                                      child: ListTile(
                                          title: Row(children: [
                                            Text(myList[index]["barcode"]
                                                .toString()),
                                            Text(
                                              "     ID:  ",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                              ),
                                            ),
                                            Text(
                                              myList[index]["id"].toString(),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ]),
                                          subtitle: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text('Mã đơn: '),
                                                  Expanded(
                                                    child: Text(
                                                      myList[index]
                                                              ["picking_id"][1]
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
                                              Row(
                                                children: [
                                                  Text('Tên sản phẩm: '),
                                                  Expanded(
                                                    child: Text(
                                                      myList[index]
                                                              ["product_id"][1]
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
                                                  Text('Số lượng: '),
                                                  // IconButton(
                                                  //   icon: Icon(Icons.remove),
                                                  //   onPressed: () {
                                                  //     setState(() {
                                                  //       myList[index][
                                                  //           "product_qty"] -= 1;
                                                  //       qty = myList[index]
                                                  //           ["product_qty"];
                                                  //     });
                                                  //   },
                                                  // ),
                                                  Expanded(
                                                    child: TextFormField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          qty = double.parse(
                                                              value);
                                                          print("qty ${qty}");
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.add),
                                                    onPressed: () {
                                                      print("qty 2 ${qty}");
                                                      putSoLuong(
                                                          myList[index]["id"],
                                                          qty);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Bạn đã lưu ID ${myList[index]["id"]} số lượng ${qty} vào CSDL'),
                                                          duration:
                                                              const Duration(
                                                                  seconds: 3),
                                                        ),
                                                      );
                                                    },
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

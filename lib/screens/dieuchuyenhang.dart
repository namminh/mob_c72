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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mob_vietduc/screens/danhsachdieuchuyen.dart';

class dieuchuyenhang extends StatefulWidget {
  final Set<String> epcSetLienTuc;
  dieuchuyenhang({
    Key key,
    this.epcSetLienTuc,
  }) : super(key: key);
  @override
  State<dieuchuyenhang> createState() => _dieuchuyenhangState();
}

class _dieuchuyenhangState extends State<dieuchuyenhang> {
  List dieuchuyenhangList = [];
  List<dynamic> myList = [];
  List<dynamic> myThieBi = [];
  String ichoice = 'đóng';
  List<dynamic> filteredList = [];
  List<String> stringList = [];
  List<String> epcList = [];
  List<String> variantIds = [];
  int count = 0;
  String selectDieuChuyen;
  String PickingID;
  String iselect = 'draft';
  String tempSelect;
  TextEditingController _textController = TextEditingController();
  String NoiDung = '';
  var username;
  var password;
  List<String> _statuses = ['draft', 'assigned', 'done'];

  @override
  initState() {
    setState(() {
      count = 0;
    });
    super.initState();
    getDatadieuchuyenhang();
    // getDataThietbi();
  }

  getDatadieuchuyenhang() async {
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
        Uri.parse('http://13.213.133.99/api/v1/custom/dieuchuyenhang?db=demo');

    http.Response response = await http.get(_uri, headers: headers);
    if (response.statusCode == 200) {
      dynamic myMap = json.decode(response.body)["result"];
      myList = myMap;
    } else {
      myList = [];
    }
    // dieuchuyenhangList = myList.map((item) => item["barcode"]).toList();
    print("namnm06 ${_uri}");
    setState(() {
      ichoice = 'đóng';
    });
  }

  Future<void> putTrangThai(int ids, String status) async {
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
          'http://13.213.133.99/api/v1/write/stock.picking?db=demo&ids=["${ids}"]&values={ "state": "${status}"}&with_context={}&with_company=1');

      http.Response response = await http.put(_uri, headers: headers);
      print(response.statusCode);
      print(response.body);
      print("namnm06_2 ${_uri}");
    } catch (error) {
      print(error);
    }
  }

  Future<void> postData(List<String> barcodeList, int id, int location_dest_id,
      int location_id) async {
    try {
      String username = 'nammta@gmail.com';
      String password = '123456';
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      var headers = {
        "Accept": "application/json",
        "Authorization": basicAuth,
      };
      print("Gia tri barcode ${barcodeList}");
      variantIds = myThieBi
          .where((element) => epcList.contains(element['barcode']))
          .map((element) => element['product_variant_ids'].toString())
          .toList();
      stringList = myThieBi
          .where((element) => epcList.contains(element['barcode']))
          .map((element) => element['barcode'].toString())
          .toList();

      print("Gia tri variantIds ${variantIds}");
      print("Gia tri stringList ${stringList}");

      var apiUrl =
          'http://13.213.133.99/api/v1/create/stock.move?db=demo&ids=[9999]&values={"name":"","product_id":,"picking_id":${id},"location_id":${location_id},"location_dest_id":${location_dest_id},"company_id":1, "product_uom_qty":1,"product_uom":1,"procure_method":"make_to_stock","barcode":""}';
      for (var i = 0; i < variantIds.length; i++) {
        var productId = variantIds[i].replaceAll('[', '').replaceAll(']', '');
        var barcode = stringList[i];
        print("product_ids ${productId}");
        var url = apiUrl
            .replaceAll('"barcode":""', '"barcode":"$barcode"')
            .replaceAll('"product_id":', '"product_id":$productId');

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
                Text('Đã nhập barcode ${barcode} !'),
              ],
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        await Future.delayed(Duration(milliseconds: 100));
      }
    } catch (error) {
      print(error);
      Text('Đã xảy ra lỗi ! ${error}');
    }
  }

  Future<void> postNhapHang(String x_so_hoa_don) async {
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
          'http://13.213.133.99/api/v1/create/stock.picking?db=demo&values={"picking_type_id":1,"move_type":"direct","location_id":"5","location_dest_id":"8","company_id":"1","state":"draft","x_so_hoa_don":"${x_so_hoa_don}"}');

      http.Response response = await http.post(_uri, headers: headers);
      print(response.statusCode);
      print(response.body);
      print("namnm06_2 ${_uri}");
    } catch (error) {
      print(error);
    }
  }

  Future<void> postXuatHang(String x_so_hoa_don) async {
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
          'http://13.213.133.99/api/v1/create/stock.picking?db=demo&values={"picking_type_id":2,"move_type":"direct","location_id":"8","location_dest_id":"5","company_id":"1","state":"draft","x_so_hoa_don":"${x_so_hoa_don}"}');

      http.Response response = await http.post(_uri, headers: headers);
      print(response.statusCode);
      print(response.body);
      print("namnm06_2 ${_uri}");
    } catch (error) {
      print(error);
    }
  }

  Future<void> getDataThietbi() async {
    String username = 'nammta@gmail.com';
    String password = '123456';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    var headers = {
      "Accept": "application/json",
      "Authorization": basicAuth,
    };
    Uri _uri = Uri.parse(
        'http://13.213.133.99/api/v1/search_read/product.template?db=demo&with_context&with_company=1&fields=["product_variant_ids","barcode"]');

    http.Response response = await http.get(_uri, headers: headers);
    dynamic myMap1 = json.decode(response.body);
    myThieBi = myMap1;

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
    print("namnm08 ${myThieBi}");
    print("namnm09 ${epcList}");

    setState(() {});

    // print("namnm10 ${productId}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Điều chuyển hàng"),
        ),
        backgroundColor: ArgonColors.bgColorScreen,
        drawer: ArgonDrawer(currentPage: "dieuchuyenhang"),
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
                              await postNhapHang(NoiDung);
                              setState(() {
                                getDatadieuchuyenhang();
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
                                child: Text("Nhập hàng",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0))),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await postXuatHang(NoiDung);
                              setState(() {
                                getDatadieuchuyenhang();
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
                                child: Text("Xuất hàng",
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
                          hintText: "Nhập số hóa đơn",
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
                        value: iselect ?? 'draft',
                        items: <String>['draft', 'assigned', 'done']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (selectDieuChuyen) {
                          getDatadieuchuyenhang();
                          print("selectDieuChuyen ${selectDieuChuyen}");
                          setState(() {
                            iselect = selectDieuChuyen ?? 'draft';
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
                                if (myList[index]["state"] != iselect) {
                                  return SizedBox.shrink();
                                }
                                return GestureDetector(
                                    onTap: () {
                                      getDataThietbi();
                                      // Hàm xử lý sự kiện khi nhấn vào Card ở đây
                                      print(
                                          'Bạn đã nhấn vào Card với id là ${myList[index]["location_dest_id"][0]} ${myList[index]["location_id"][0]} ${myList[index]["id"]}');
                                      var dest_id =
                                          myList[index]["location_dest_id"][0];
                                      var location_id =
                                          myList[index]["location_id"][0];

                                      postData(epcList, myList[index]["id"],
                                          dest_id, location_id);

                                      count = variantIds.length;
                                      if (count > 0) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Column(
                                              children: [
                                                Text(
                                                    'Đã nhập dữ liệu vào ${myList[index]["display_name"]} !'),
                                                Text('Số sản phẩm ${count}')
                                              ],
                                            ),
                                            duration:
                                                const Duration(seconds: 3),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Chưa có dữ liệu thiết bị, bạn nhập lại'),
                                            duration:
                                                const Duration(seconds: 3),
                                          ),
                                        );
                                      }
                                    },
                                    child: Card(
                                        child: ListTile(
                                            title: Row(children: [
                                              Text(
                                                  '    ID: ${myList[index]["id"]}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                  )),
                                              DropdownButton<String>(
                                                value: myList[index]["state"]
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
                                                    if (newValue != null) {
                                                      myList[index]["state"] =
                                                          newValue;

                                                      putTrangThai(
                                                          myList[index]["id"],
                                                          newValue);
                                                    }
                                                  });
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                    Icons.move_down_rounded),
                                                onPressed: () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          danhsachdieuchuyen(
                                                              picking_id: myList[
                                                                          index]
                                                                      ["id"]
                                                                  .toString()),
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'Bạn đã chuyển sang danh sách vật tư'),
                                                      duration: const Duration(
                                                          seconds: 3),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ]),
                                            subtitle: Column(
                                              children: [
                                                Row(children: [
                                                  Text('Mã đơn:   '),
                                                  Expanded(
                                                    child: Text(
                                                      myList[index]
                                                              ["display_name"]
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                                Text(
                                                    myList[index]
                                                        ["picking_type_id"][1],
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue,
                                                    )),
                                                Row(children: [
                                                  Text('Trạng thái:   '),
                                                  Expanded(
                                                    child: Text(
                                                      myList[index]["state"]
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                                Row(children: [
                                                  Text('Số hóa đơn:   '),
                                                  Expanded(
                                                    child: Text(
                                                      myList[index]
                                                              ["x_so_hoa_don"]
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red,
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

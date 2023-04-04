// ignore_for_file: avoid_null_checks_on_nullable_types
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mob_vietduc/widgets/drawer.dart';
import 'package:mob_vietduc/constants/Theme.dart';
import 'package:mob_vietduc/widgets/input.dart';

class timkiemthietbi extends StatefulWidget {
  final Set<String> epcSetLienTuc;
  timkiemthietbi({
    Key key,
    this.epcSetLienTuc,
  }) : super(key: key);
  @override
  State<timkiemthietbi> createState() => _timkiemthietbiState();
}

class _timkiemthietbiState extends State<timkiemthietbi> {
  List thietbiList = [];
  List<dynamic> myList = [];
  TextEditingController _textController = TextEditingController();
  String ichoice = 'đóng';
  List<String> epcList = [];
  List filteredList = [];
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
    String username = 'nammta@gmail.com';
    String password = '123456';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    var headers = {
      "Accept": "application/json",
      "Authorization": basicAuth,
    };
    Uri _uri = Uri.parse(
        'http://13.213.133.99/api/v1/search_read/product.template?db=demo&with_context={}&with_company=1&fields=["barcode","display_name","list_price","create_date","default_code","x_hang_san_xuat","x_ma_benh_vien","x_ma_hang","x_ten_nha_cung_cap","x_quy_canh_hang_hoa","qty_available"]');

    http.Response response = await http.get(_uri, headers: headers);
    if (response.statusCode == 200) {
      dynamic myMap = json.decode(response.body);
      myList = myMap;
      // thietbiList = myList.map((item) => item["barcode"]).toList();
      print("namnm06 ${_uri}");
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
      print("namnm08 ${myList}");
      print("namnm09 ${epcList}");

      filteredList = myList
          .where((element) => epcList.contains(element['barcode']))
          .toList();
    } else {
      myList = [];
    }
    print("namnm10 ${filteredList}");
    setState(() {
      ichoice = 'đóng';
    });
  }

  @override
  Widget build(BuildContext context) {
    // final String? data = ModalRoute.of(context)!.settings.arguments as String?;

    // var args = ModalRoute.of(context)!.settings.arguments;
    // if (args != null) {
    //   // sử dụng đối số ở đây
    // }
    // epcSetLienTuc = args as Set<String>;

    return Scaffold(
        appBar: AppBar(
          title: Text("Tìm kiếm kho"),
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
                    Offstage(
                        offstage: ichoice != "đóng",
                        child: SingleChildScrollView(
                          child: ListView.builder(
                            shrinkWrap: true,
                            reverse: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: filteredList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                  // leading: CircleAvatar(
                                  //   backgroundImage: NetworkImage(pokemonList[index]["img"]),
                                  // ),

                                  child: ListTile(
                                      title: Row(children: [
                                        Text(filteredList[index]["barcode"]
                                            .toString()),
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
                                          Row(
                                            children: [
                                              Text('Mã hàng hóa: '),
                                              Expanded(
                                                child: Text(
                                                  myList[index]["x_ma_hang"]
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
                                            Text(filteredList[index]
                                                ["create_date"]),
                                          ]),
                                          Row(
                                            children: [
                                              Text('Tên vật tư: '),
                                              Expanded(
                                                child: Text(
                                                  filteredList[index]
                                                          ["display_name"]
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
                                                  filteredList[index]
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
                                                  filteredList[index]
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
                                                  filteredList[index][
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
                                                filteredList[index]
                                                        ["list_price"]
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

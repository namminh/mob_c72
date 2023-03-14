import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mob_vietduc/widgets/drawer.dart';
import 'package:mob_vietduc/constants/Theme.dart';
import 'package:mob_vietduc/widgets/navbar.dart';

class xembando extends StatefulWidget {
  @override
  _xembandoState createState() => _xembandoState();
}

class _xembandoState extends State<xembando> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _textController = TextEditingController();
  GoogleMapController _mapController;
  List giadatList = [];
  List diadiemList = [];
  List toadoList = [];
  var place_id;
  var lat;
  var lng;
  String _showResult = 'chọn';
  String tenDuong;
  CameraPosition _currentPosition = CameraPosition(
    target: LatLng(11.578000306113399, 108.99346725962042),
    zoom: 17,
  );

  @override
  getDataGiaDat() async {
    // Uri _uri = Uri.parse(
    //     'https://csdlgia.ninhthuan.gov.vn/mwebapi/GetBaoCaoGiaThiTruong116?DIA_BAN_ID=${_selectedValueQuanHuyen}&KY_DU_LIEU_ID=${_selectedValuekydulieu}&KY_DU_LIEU_CHI_TIET_1_ID=${_selectedValuekydulieuchitietNgay}&KY_DU_LIEU_CHI_TIET_2_ID=${_selectedValuekydulieuchitietThang}&NAM=${_selectedNam}');
    Uri _uri = Uri.parse(
        "https://csdlgia.ninhthuan.gov.vn/mwebapi/TimGiaDatMobile?keyword=${tenDuong}");
    http.Response response = await http.get(_uri);
    Map<String, dynamic> myMap = json.decode(response.body);
    giadatList = myMap["Result"];
    print("namnm07 ${_uri} ");
    print("namnm08 ${tenDuong} ");
    setState(() {
      _showResult = "tìm kiếm";
    });
  }

  getDiaDiem() async {
    // Uri _uri = Uri.parse(
    //     'https://csdlgia.ninhthuan.gov.vn/mwebapi/GetBaoCaoGiaThiTruong116?DIA_BAN_ID=${_selectedValueQuanHuyen}&KY_DU_LIEU_ID=${_selectedValuekydulieu}&KY_DU_LIEU_CHI_TIET_1_ID=${_selectedValuekydulieuchitietNgay}&KY_DU_LIEU_CHI_TIET_2_ID=${_selectedValuekydulieuchitietThang}&NAM=${_selectedNam}');
    Uri _uri = Uri.parse(
        "https://rsapi.goong.io/Place/AutoComplete?api_key=3S6utgJppy4E4mmGUs7LJTdPmuj8CIh2y98mYKcA&input=${tenDuong}, Ninh Thuận");
    http.Response response = await http.get(_uri);
    Map<String, dynamic> myMap = json.decode(response.body);
    diadiemList = myMap["predictions"];
    print("namnm07_1 ${_uri} ");
    place_id = diadiemList[0]["place_id"];
    print("place_id ${place_id} ");

    Uri _uri1 = Uri.parse(
        "https://rsapi.goong.io/Place/Detail?place_id=${place_id}&api_key=3S6utgJppy4E4mmGUs7LJTdPmuj8CIh2y98mYKcA");
    http.Response response1 = await http.get(_uri1);
    Map<String, dynamic> myMap1 = json.decode(response1.body);
    lat = myMap1["result"]["geometry"]["location"]["lat"];
    lng = myMap1["result"]["geometry"]["location"]["lng"];
    print("lat ${lat} ");
    print("lng ${lng} ");
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Xem bản đồ"),
      ),
      backgroundColor: ArgonColors.bgColorScreen,
      drawer: ArgonDrawer(currentPage: "xembando"),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _currentPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                _mapController = controller;
              },
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.75,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[200],
                          blurRadius: 5,
                          spreadRadius: 5),
                    ],
                  ),
                  child: Row(children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 20, right: 20, top: 5, bottom: 5),
                          hintText: "Tên đường",
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _textController.clear();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () async {
                        setState(() {
                          tenDuong = _textController.text;
                        });
                        getDataGiaDat();
                        getDiaDiem();
                        GoogleMapController controller =
                            await _controller.future;
                        controller.animateCamera(CameraUpdate.newCameraPosition(
                            // on below line we have given positions of Location 5
                            CameraPosition(
                          target: LatLng(lat, lng),
                          zoom: 20,
                        )));
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 400,
                              child: SingleChildScrollView(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: giadatList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    // print(
                                    //     "TEN_LOAI_DAT: ${giadatList[index]["TEN_LOAI_DAT"]}");

                                    return Card(
                                      child: ListTile(
                                        title: Text(
                                            giadatList[index]["TEN_DUONG"]),
                                        subtitle: Column(
                                          children: [
                                            Text(giadatList[index]
                                                ["DOAN_DUONG"]),
                                            Text(giadatList[index]
                                                ["MO_TA_VI_TRI"]),
                                            Text(giadatList[index]
                                                ["TEN_LOAI_DAT"]),
                                            Text(
                                              giadatList[index]["GIA_DAT"]
                                                  .toString(),
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bottom Sheet"),
            SizedBox(height: 20),
            Text("Content"),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:mob_vietduc/constants/Theme.dart';

//widgets
import 'package:mob_vietduc/widgets/navbar.dart';

import 'package:mob_vietduc/widgets/drawer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Home extends StatelessWidget {
  // final GlobalKey _scaffoldKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Navbar(
          title: "Trang Chủ",

          // categoryOne: "Beauty",
          // categoryTwo: "Fashion",
        ),
        backgroundColor: ArgonColors.bgColorScreen,
        // key: _scaffoldKey,
        drawer: ArgonDrawer(currentPage: "Home"),
        body: Container(
          child: WebView(
            initialUrl: 'https://csdlgia.ninhthuan.gov.vn/adHome2.aspx',
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ));
  }
}

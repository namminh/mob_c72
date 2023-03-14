import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
// screens
import 'package:mob_vietduc/screens/onboarding.dart';
import 'package:mob_vietduc/screens/thietbi.dart';
import 'package:mob_vietduc/screens/dieuchuyenhang.dart';
import 'package:mob_vietduc/screens/baotri.dart';
import 'package:mob_vietduc/screens/yeucaubaotri.dart';
import 'package:mob_vietduc/screens/scanqr.dart';
import 'package:mob_vietduc/screens/register.dart';

import 'package:mob_vietduc/screens/chainwayc72.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Quản lý thiết bị',
        theme: ThemeData(fontFamily: 'OpenSans'),
        initialRoute: "/onboarding",
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          "/onboarding": (BuildContext context) => new Onboarding(),
          "/thietbi": (BuildContext context) => new thietbi(),
          "/baotri": (BuildContext context) => new baotri(),
          "/dieuchuyenhang": (BuildContext context) => new dieuchuyenhang(),
          "/yeucaubaotri": (BuildContext context) => new yeucaubaotri(),
          "/chainwayc72": (BuildContext context) => new chainwayc72(),
          "/scanqr": (BuildContext context) => new scanqr(),
          "/register": (BuildContext context) => new Register(),
        });
  }
}

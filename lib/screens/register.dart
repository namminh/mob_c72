import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mob_vietduc/constants/Theme.dart';
import 'package:mob_vietduc/screens/scanqr.dart';
import 'package:mob_vietduc/screens/yeucaubaotri.dart';
import 'package:shared_preferences/shared_preferences.dart';

//widgets
import 'package:mob_vietduc/widgets/navbar.dart';
import 'package:mob_vietduc/widgets/input.dart';

import 'package:mob_vietduc/widgets/drawer.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var username;
  var password;
  var temp;
  int check = 0;
  final double height = window.physicalSize.height;
  TextEditingController _textControllerUser = TextEditingController();
  TextEditingController _textControllerPass = TextEditingController();
  @override
  initState() {
    setState(() {});
    super.initState();

    // getDataGiaDat();
  }

  Future<void> remove() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    prefs.remove('password');
  }

  void saveUsername(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
    print("username register ${username} ");
    print("password ${password} ");
  }

  Future<void> checklogin(String username, String password) async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    var headers = {
      "Accept": "application/json",
      "Authorization": basicAuth,
    };
    // var headers = {
    //   "Accept": "application/json",
    //   "username": "${username}",
    //   "password": "${password}",
    // };
    Uri _uri = Uri.parse(
        "http://13.213.133.99/api/v1/session?db=demo&with_context=%7B%7D&with_company=1");

    http.Response response = await http.get(_uri, headers: headers);

    dynamic result = json.decode(response.body);
    if (response.statusCode == 200) {
      temp = result["username"];
      print("result ${result} ");
      if (username == temp) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => scanqr(),
          ),
        );
        print("kiem tra ${temp} ");
        saveUsername(username, password);
      } else {
        check = 0;
        print("kiem tra lỗi ");
        Navigator.pushNamed(context, '/onboarding');
      }
      setState(() {});
    } else {
      temp = [];
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/img/register-bg.png"),
                  fit: BoxFit.cover)),
        ),
        SafeArea(
          child: ListView(children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 150, left: 24.0, right: 24.0, bottom: 32),
              child: Card(
                  elevation: 5,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Column(
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height * 0.50,
                          color: Color.fromRGBO(244, 245, 247, 1),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          // obscureText: true, // ẩn mật khẩu
                                          controller: _textControllerUser,
                                          decoration: InputDecoration(
                                            prefixIcon:
                                                Icon(Icons.verified_user),
                                            hintText: 'Tên đăng nhập',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          obscureText: true, // ẩn mật khẩu
                                          controller: _textControllerPass,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.lock),
                                            hintText: 'Mật khẩu',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            username = _textControllerUser.text;
                                            password = _textControllerPass.text;
                                          });
                                          checklogin(username, password);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors
                                              .pinkAccent, //change background color of button
                                          backgroundColor: Colors
                                              .yellow, //change text color of button
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          elevation: 15.0,
                                        ),
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 16.0,
                                                right: 16.0,
                                                top: 12,
                                                bottom: 12),
                                            child: Text("Đăng nhập",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16.0))),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ))
                    ],
                  )),
            ),
          ]),
        )
      ],
    ));
  }
}

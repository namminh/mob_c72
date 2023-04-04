import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:mob_vietduc/constants/Theme.dart';
import 'package:mob_vietduc/screens/dieuchuyenhang.dart';
import 'package:mob_vietduc/screens/scanqr.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mob_vietduc/screens/yeucaubaotri.dart';

import 'package:mob_vietduc/screens/register.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  var username;
  var password;
  @override
  initState() {
    setState(() {});
    super.initState();
    getData();

    // Timer.periodic(Duration(seconds: 20), (timer) {
    //   // Gọi hàm cập nhật dữ liệu mỗi khi thời gian đến
    //   getDataThietbi();
    // });
  }

  getData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString('username') ?? '';
      password = prefs.getString('password') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/img/onboard-background.png"),
                  fit: BoxFit.cover))),
      Padding(
        padding:
            const EdgeInsets.only(top: 73, left: 32, right: 32, bottom: 16),
        child: Container(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 24.0),
                    //   child: Text("Bản quyền hipt",
                    //       style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 18,
                    //           fontWeight: FontWeight.w200)),
                    // ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => Register(),
                        //   ),
                        // );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Register(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors
                            .pinkAccent, //change background color of button
                        backgroundColor:
                            Colors.yellow, //change text color of button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 15.0,
                      ),
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 12, bottom: 12),
                          child: Text("BẮT ĐẦU",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0))),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    ]));
  }
}

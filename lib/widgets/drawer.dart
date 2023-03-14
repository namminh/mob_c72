import 'package:flutter/material.dart';
import 'package:mob_vietduc/screens/scanqr.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mob_vietduc/constants/Theme.dart';

import 'package:mob_vietduc/widgets/drawer-tile.dart';
import 'package:mob_vietduc/screens/chainwayc72.dart';
import 'package:mob_vietduc/screens/dieuchuyenhang.dart';
import 'package:mob_vietduc/screens/yeucaubaotri.dart';
import 'package:mob_vietduc/screens/thietbi.dart';
import 'package:mob_vietduc/screens/baotri.dart';

class ArgonDrawer extends StatelessWidget {
  final String currentPage;

  ArgonDrawer({this.currentPage});

  // _launchURL() async {
  //   const url = 'https://csdlgia.ninhthuan.gov.vn/adHome2.aspx?';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: ArgonColors.white,
      child: Column(children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.85,
            child: SafeArea(
              bottom: false,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Image.asset("assets/img/logovietduc.png"),
                ),
              ),
            )),
        Expanded(
          flex: 2,
          child: ListView(
            padding: EdgeInsets.only(top: 24, left: 16, right: 16),
            children: [
              DrawerTile(
                  icon: Icons.production_quantity_limits,
                  onTap: () {
                    if (currentPage != "thietbi")
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => thietbi(),
                        ),
                      );
                  },
                  iconColor: ArgonColors.primary,
                  title: "Thiết bị",
                  isSelected: currentPage == "thietbi" ? true : false),
              DrawerTile(
                  icon: Icons.manage_history_rounded,
                  onTap: () {
                    if (currentPage != "baotri")
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => baotri(),
                        ),
                      );
                  },
                  iconColor: ArgonColors.primary,
                  title: "Trang Thiết bị bảo trì",
                  isSelected: currentPage == "baotri" ? true : false),
              DrawerTile(
                  icon: Icons.model_training_outlined,
                  onTap: () {
                    if (currentPage != "yeucaubaotri")
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => yeucaubaotri(),
                        ),
                      );
                  },
                  iconColor: ArgonColors.primary,
                  title: "Yêu cầu bảo trì",
                  isSelected: currentPage == "yeucaubaotri" ? true : false),
              DrawerTile(
                  icon: Icons.transfer_within_a_station_sharp,
                  onTap: () {
                    if (currentPage != "dieuchuyenhang")
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => dieuchuyenhang(),
                        ),
                      );
                  },
                  iconColor: ArgonColors.primary,
                  title: "Điều chuyển hàng",
                  isSelected: currentPage == "dieuchuyenhang" ? true : false),
              DrawerTile(
                  icon: Icons.scanner_sharp,
                  onTap: () {
                    if (currentPage != "chainwayc72")
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => chainwayc72(),
                        ),
                      );
                  },
                  iconColor: ArgonColors.primary,
                  title: "QUÉT UHF",
                  isSelected: currentPage == "chainwayc72" ? true : false),
              DrawerTile(
                  icon: Icons.scanner,
                  onTap: () {
                    if (currentPage != "scanqr")
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => scanqr(),
                        ),
                      );
                  },
                  iconColor: ArgonColors.primary,
                  title: "SCAN QR",
                  isSelected: currentPage == "scanqr" ? true : false),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
              padding: EdgeInsets.only(left: 8, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(height: 4, thickness: 0, color: ArgonColors.muted),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, left: 16, bottom: 8),
                    child: Text("Hồ sơ",
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                          fontSize: 15,
                        )),
                  ),
                  // DrawerTile(
                  //     icon: Icons.pie_chart,
                  //     onTap: () {
                  //       if (currentPage != "Profile")
                  //         Navigator.pushReplacementNamed(context, '/profile');
                  //     },
                  //     iconColor: ArgonColors.warning,
                  //     title: "Profile",
                  //     isSelected: currentPage == "Profile" ? true : false),
                  DrawerTile(
                      icon: Icons.pie_chart,
                      onTap: () {
                        if (currentPage != "register")
                          Navigator.pushReplacementNamed(context, '/register');
                      },
                      iconColor: ArgonColors.warning,
                      title: "Thoát",
                      isSelected: currentPage == "register" ? true : false),
                ],
              )),
        ),
      ]),
    ));
  }
}

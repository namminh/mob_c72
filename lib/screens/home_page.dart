import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/cook_model.dart';
import '../ui/widgets/item_grid_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Cook> cookList = [];

  @override
  initState() {
    super.initState();
    getData();
  }

  getData() async {
    Uri _uri = Uri.parse(
        "https://hf-android-app.s3-eu-west-1.amazonaws.com/android-test/recipes.json");
    http.Response response = await http.get(_uri);
    var myList = json.decode(response.body);
    // print("namnm05 ${myList[0]}");
    cookList = (myList as List).map((e) => Cook.fromJson(e)).toList();

    // cookList = myList.map((e) => Cook.fromJson(e)).toList();
    print("namnm06 ${cookList[0]}");
    setState(() {
      this.cookList = cookList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cook"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.count(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.35,
                  children: cookList
                      .map<Widget>(
                        (dish) => ItemGridWidget(
                          // name: pokemon.name,
                          // image: pokemon.img,
                          // type: pokemon.type,
                          dish: dish,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ItemDataDishWidget extends StatelessWidget {
  final String title;
  final String data;

  const ItemDataDishWidget({
    this.title,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
          Expanded(
            child: Text(
              data,
              textAlign: TextAlign.center,
              maxLines: null,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../models/cook_model.dart';
import '../../screens/dish_detail_page.dart';
import '../general/colors.dart';

class ItemGridWidget extends StatelessWidget {
  Cook dish;

  ItemGridWidget({
    this.dish,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DishDetailPage(
                      dish: dish,
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
          color: colorDish[dish.difficulty],
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.network(
                dish.thumb,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          child: Text(
                            dish.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

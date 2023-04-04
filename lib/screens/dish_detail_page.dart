import 'package:flutter/material.dart';
import '../models/cook_model.dart';
import '../ui/general/colors.dart';
import '../ui/widgets/item_data_widget.dart';

class DishDetailPage extends StatelessWidget {
  final Cook dish;
  DishDetailPage({
    this.dish,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorDish[dish.difficulty.toString()],
      appBar: AppBar(
        backgroundColor: colorDish[dish.difficulty.toString()],
        elevation: 0,
        actions: [],
      ),
      body: Stack(
        children: [
          // Positioned(
          //   right: -20,
          //   top: MediaQuery.of(context).size.height * 0.09,
          //   child: Image.asset(
          //     'assets/images/register-bg.png',
          //     width: 200,
          //     color: Colors.white.withOpacity(0.26),
          //   ),
          // ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${dish.name}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 250,
                          child: Text(
                            dish.headline,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "#${dish.id}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              Expanded(
                flex: 4,
                child: SizedBox(),
              ),
              Expanded(
                flex: 9,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            const SizedBox(
                              height: 12.0,
                            ),
                            ItemDataDishWidget(
                              title: "calories",
                              data: dish.calories,
                            ),
                            ItemDataDishWidget(
                              title: "carbos",
                              data: dish.carbos.toString(),
                            ),
                            ItemDataDishWidget(
                              title: "fats",
                              data: dish.fats.toString(),
                            ),
                            ItemDataDishWidget(
                              title: "proteins",
                              data: dish.proteins.toString(),
                            ),
                            ItemDataDishWidget(
                              title: "description",
                              data: dish.description.toString(),
                            ),
                            ItemDataDishWidget(
                              title: "time",
                              data: dish.time.toString(),
                            ),
                            ItemDataDishWidget(
                              title: "difficulty",
                              data: dish.difficulty.toString(),
                            ),
                          ],
                        ),
                      ),
                      Positioned.fill(
                        top: -110,
                        //right: MediaQuery.of(context).size.width * 0.35,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Image.network(
                            dish.image,
                            height: 160.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

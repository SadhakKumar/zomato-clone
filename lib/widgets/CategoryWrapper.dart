import 'package:flutter/material.dart';
import 'package:zomato_clone/model/CategoriesModel.dart';
import 'CategoryWidget.dart';

class CategoryWrapper extends StatelessWidget {
  final List<CategoriesModel> categories = [
    CategoriesModel(name: "burger", image: "assets/images/burger.png"),
    CategoriesModel(name: "snacks", image: "assets/images/Snacks.png"),
    CategoriesModel(name: "pizza", image: "assets/images/pizza.png"),
    CategoriesModel(name: "drinks", image: "assets/images/drink.png"),
    CategoriesModel(name: "biryani", image: "assets/images/biryani.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Row(
          children: categories.map((category) {
            return CategoryWidget(imagePath: category.image!);
          }).toList(),
        ),
      ),
    );
  }
}

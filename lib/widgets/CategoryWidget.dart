import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/CategoriesModel.dart';

class CategoryWidget extends StatelessWidget {
  final CategoriesModel category;

  CategoryWidget({required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Image.asset(
          category.image!,
          height: 50,
          width: 50,
        ),
      ),
    );
  }
}

Future<List<CategoriesModel>> fetchCategoriesFromJson() async {
  final jsonString = await rootBundle.loadString('assets/categories.json');
  final jsonList = json.decode(jsonString) as List;

  return jsonList.map((jsonCategory) {
    return CategoriesModel.fromJson(jsonCategory);
  }).toList();
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:zomato_clone/model/CategoriesModel.dart';
import 'CategoryWidget.dart';
import 'package:flutter/services.dart';

class CategoryWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 70, // Define a suitable height
        child: FutureBuilder<List<CategoriesModel>>(
          future: fetchCategoriesFromJson(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No data available');
            } else {
              final categories = snapshot.data!;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: CategoryWidget(category: categories[index]),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

Future<List<CategoriesModel>> fetchCategoriesFromJson() async {
  final jsonString = await rootBundle.loadString('jsonfiles/category.json');
  final jsonList = json.decode(jsonString) as List;

  return jsonList.map((jsonCategory) {
    return CategoriesModel.fromJson(jsonCategory);
  }).toList();
}

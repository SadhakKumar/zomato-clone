import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final String imagePath;

  CategoryWidget({required this.imagePath});

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
          imagePath,
          width: 50,
          height: 50,
        ),
      ),
    );
  }
}

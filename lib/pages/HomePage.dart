import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zomato_clone/widgets/AppbarWidget.dart';
import 'package:zomato_clone/widgets/CategoryWrapper.dart';
import 'package:zomato_clone/widgets/SearchTab.dart';

import '../widgets/NewestListWidget.dart';
import '../widgets/PopularItems.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F3),
      body: ListView(
        children: [
          AppBarWidget(),
          SearchTab(),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 20),
            child: Text(
              "categories",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          CategoryWrapper(),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 20),
            child: Text(
              "Popular",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          PopularItems(),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 20),
            child: Text(
              "Newest",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          NewestListWidget(),
        ],
      ),
    );
  }
}

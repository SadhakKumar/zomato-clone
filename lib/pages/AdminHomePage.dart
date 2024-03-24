import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zomato_clone/pages/Cart.dart';
import 'package:zomato_clone/pages/HomePage.dart';
import 'package:zomato_clone/pages/LoginPage.dart';
import 'package:zomato_clone/widgets/BottomNavigation.dart';
import 'package:zomato_clone/widgets/PopularItems.dart';
import 'package:zomato_clone/widgets/PreviousOrdersWidget.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F3),
      appBar: AppBar(
        title: Text(
          "Admin Home Page",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20, left: 20),
            child: Text(
              "Your Items",
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
              "Your Orders",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          PreviousOrdersWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}

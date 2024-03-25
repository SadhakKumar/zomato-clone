import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zomato_clone/pages/LoginPage.dart';
import 'package:zomato_clone/pages/AdminHomePage.dart';
import 'package:zomato_clone/widgets/finger_print_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your fapplication.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zomato',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF5F5F3),
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 125, 11)),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159, // 2 * π, full circle
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    _controller.repeat();
    Timer(Duration(seconds: 2), () {
      _controller.stop();
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration:
              Duration(milliseconds: 500), // Adjust the duration as needed
          pageBuilder: (_, __, ___) =>
              LoginPage(), // Replace LoginPage() with your destination page
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Transform.rotate(
          angle: _animation.value,
          child: Icon(
            Icons.local_dining, // Use a food-related icon here
            size: 200,
            color: Colors.orange, // Customize color as needed
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

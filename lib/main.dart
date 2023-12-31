import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zomato_clone/pages/LoginPage.dart';

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
      home: LoginPage(),
    );
  }
}

import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zomato_clone/pages/AdminHomePage.dart';
import 'HomePage.dart';
import 'RegistrationPage.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  String role = 'Select Role';
  bool isTextFieldEmpty = true;

  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 255, 125, 11),
      ),
      body: Padding(
        padding: const EdgeInsets.all(45.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Welcome back you've been missed"),
                const SizedBox(height: 32),

                //LOGO
                Container(
                  width: 300,
                  height: 300,
                  child: Image.asset('assets/images/logo.jpg'),
                ),

                const SizedBox(height: 15),

                //EMAIL
                TextField(
                  controller: emailController,
                  onChanged: (value) {
                    setState(() {
                      isTextFieldEmpty = value.isEmpty;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter Email',
                  ),
                ),

                const SizedBox(height: 16),

                //PASSWRD
                TextField(
                  controller: passwordController,
                  onChanged: (value) {
                    setState(() {
                      isTextFieldEmpty = value.isEmpty;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter Password',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 32),

                DropdownButtonFormField(
                  value: role,
                  decoration: InputDecoration(labelText: 'Category'),
                  items: [
                    DropdownMenuItem(
                      value: 'Select Role',
                      child: Text('Select Role'),
                    ),
                    DropdownMenuItem(
                      value: 'User',
                      child: Text('User'),
                    ),
                    DropdownMenuItem(
                      value: 'Admin',
                      child: Text('Admin'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      role = value.toString();
                    });
                  },
                ),

                //button

                ElevatedButton(
                  onPressed: () {
                    signIn(emailController.text, passwordController.text);
                  },
                  child: const Text('Login'),
                ),

                const SizedBox(height: 32),

                //registration gateway
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationPage()),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Register here.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                //will open in new page
              ],
            ),
          ),
        ),
      ),
    );
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (emailController.text == 'sadhak@gmail.com') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminHomePage(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        route();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('User Not Found'),
                content: Text('No user found for that email.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );

          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('User Not Found'),
                content: Text('Wrong password provided for that user.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
          print('Wrong password provided for that user.');
        }
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'LoginPage.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  _RegistrationPageState();

  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController name = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController contactController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  String _name = '';
  String _contactNumber = '';
  String _email = '';
  String _password = '';
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Registration',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(45.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                //Role

                SizedBox(height: 25),

                //name
                TextField(
                  controller: name,
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: 'Name', hintText: 'Enter your name'),
                ),

                SizedBox(height: 25),

                //email
                TextField(
                  controller: emailController,
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: 'Email', hintText: 'Enter your email'),
                  keyboardType: TextInputType.emailAddress,
                ),

                SizedBox(height: 25),

                //contact
                TextFormField(
                  controller: contactController,
                  onChanged: (value) {
                    setState(() {
                      _contactNumber = value;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: 'Contact', hintText: 'Enter Contact number'),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Only allow digits
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your contact number';
                    }

                    return null;
                  },
                ),

                SizedBox(height: 25),

                //password
                TextField(
                  controller: passwordController,
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter password',
                    suffixIcon: IconButton(
                      color: const Color.fromARGB(255, 14, 28, 107),
                      icon: Icon(_showPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: !_showPassword,
                ),

                SizedBox(height: 35),

                //Button

                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      print('registered');
                      signUp(emailController.text, passwordController.text);
                    },
                    child: const Text('Register'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    CircularProgressIndicator();
    if (_formkey.currentState != null && _formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore(email)})
          .catchError((e) {
        print(e);
      });
    }
  }

  postDetailsToFirestore(String email) async {
    if (_auth.currentUser != null) {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      var user = _auth.currentUser;
      CollectionReference ref = FirebaseFirestore.instance.collection('users');
      await ref.doc(user!.uid).set({
        'name': _name,
        'email': email,
        'contactNumber': _contactNumber,
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }
}

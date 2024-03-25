import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zomato_clone/widgets/BottomNavigation.dart';
import 'package:local_auth/local_auth.dart';

class FoodFormPage extends StatefulWidget {
  @override
  _FoodFormPageState createState() => _FoodFormPageState();
}

class _FoodFormPageState extends State<FoodFormPage> {
  String _foodName = '';
  double _price = 0.0;
  String _imageUrl = '';
  String _description = '';
  String _category = 'Select Category';
  final _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  Future<void> _getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageUrl = pickedFile.path;
      } else {
        print('No image selected.');
      }
    });
  }

  final auth = LocalAuthentication();
  String authorized = " not authorized";
  bool _canCheckBiometric = false;
  late List<BiometricType> _availableBiometric;

  Future<void> _authenticate() async {
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
          localizedReason: "Scan your finger to authenticate",
          options: const AuthenticationOptions(biometricOnly: true));
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() {
      authorized =
          authenticated ? "Authorized success" : "Failed to authenticate";
      print(authorized);
    });
  }

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;

    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _canCheckBiometric = canCheckBiometric;
      print(_canCheckBiometric.toString());
    });
  }

  Future _getAvailableBiometric() async {
    List<BiometricType> availableBiometric = [];

    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() {
      _availableBiometric = availableBiometric;
      print(_availableBiometric.toString());
    });
  }

  @override
  void initState() {
    _checkBiometric();
    _getAvailableBiometric();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Food Item",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Food Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter food name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _foodName = value!;
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _price = double.parse(value!);
                  },
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: _getImageFromGallery,
                  child: Text('Select Image'),
                ),
                _imageUrl.isNotEmpty
                    ? Image.file(
                        File(_imageUrl),
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      )
                    : SizedBox(),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
                SizedBox(height: 10.0),
                DropdownButtonFormField(
                  value: _category,
                  decoration: InputDecoration(labelText: 'Category'),
                  items: [
                    DropdownMenuItem(
                      value: 'Select Category',
                      child: Text('Select Category'),
                    ),
                    DropdownMenuItem(
                      value: 'Veg',
                      child: Text('Veg'),
                    ),
                    DropdownMenuItem(
                      value: 'Non-Veg',
                      child: Text('Non-Veg'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _category = value.toString();
                    });
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      await _authenticate();
                      // Now you can use the form data
                      // For example, you can send it to an API or process it further
                      // Reset the form after saving if needed
                      _formKey.currentState!.reset();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Form submitted successfully')),
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}

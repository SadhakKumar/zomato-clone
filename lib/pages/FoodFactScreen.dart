import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shake/shake.dart';
import 'dart:math';

class FoodFactScreen extends StatefulWidget {
  @override
  _FoodFactScreenState createState() => _FoodFactScreenState();
}

class _FoodFactScreenState extends State<FoodFactScreen> {
  late ShakeDetector detector;
  List<String> foodFacts = [
    "The world's most expensive pizza costs 12,000 and takes 72 hours to make.",
    "Honey is the only natural food that never spoils.",
    "Apples float in water because they are 25% air.",
    "Carrots were originally purple.",
    "The most stolen food in the world is cheese.",
    "Honey is the only food that never spoils.",
    "Potatoes are 80% water.",
    "Strawberries are the only fruit with seeds on the outside.",
    "Bananas are berries, but strawberries aren't.",
    "The fear of cooking is known as Mageirocophobia.",
    "The fear of peanut butter sticking to the roof of your mouth is Arachibutyrophobia.",
    "Chocolate was once used as currency.",
    "Peanuts aren't nuts, they're legumes.",
    "The world's largest omelette weighed 14.7 tons.",
    "The world's largest pizza was 122 feet in diameter.",
  ];
  String currentFact = "";

  @override
  void initState() {
    super.initState();
    initShakeDetector();
  }

  @override
  void dispose() {
    super.dispose();
    detector.stopListening();
  }

  void initShakeDetector() {
    detector = ShakeDetector.autoStart(onPhoneShake: () {
      setState(() {
        currentFact = getRandomFact();
      });
    });
  }

  String getRandomFact() {
    Random random = Random();
    int index = random.nextInt(foodFacts.length);
    return foodFacts[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Facts'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                currentFact.isNotEmpty
                    ? currentFact
                    : 'Shake your phone for a random food fact!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

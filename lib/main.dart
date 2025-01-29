import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wanderlust/screens/BookingScreen.dart';
import 'package:wanderlust/screens/CreateDestinationScreen.dart';
import 'package:wanderlust/screens/HomeScreen.dart';
import 'package:wanderlust/screens/LandingScreen.dart';
import 'package:wanderlust/screens/LoginScreen.dart';
import 'package:wanderlust/screens/SignupScreen.dart';
import 'package:wanderlust/models/Destination.dart';  // Add this import

void main() {
  runApp(const MyApp());
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('Welcome to My Home Page!'),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(),
        // destination: Destination(
        //   id: 1,
        //   name: '',
        //   location: '',
        //   description: 'Sample Description',
        //   imageUrl: 'https://drive.google.com/uc?export=download&id=1eRFq0L5U9fDB7iCfJyyK8YM9Uld1Gino',
        //   price: '',
        //   rating: '',



    );
  }
}
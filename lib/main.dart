import 'package:flutter/material.dart';
import 'package:get/get.dart';  // Add this import
import 'package:wanderlust/screens/CreateDestinationScreen.dart';
import 'package:wanderlust/screens/HomeScreen.dart';
import 'package:wanderlust/screens/LandingScreen.dart';
import 'package:wanderlust/screens/LoginScreen.dart';
import 'package:wanderlust/screens/SignupScreen.dart';

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
    return GetMaterialApp(  // Change this from MaterialApp to GetMaterialApp
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(),
    );
  }
}
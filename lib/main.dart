import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wanderlust/screens/LandingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanderlust/screens/HomeScreen.dart';


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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    checkToken();
  }
  void checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    if (token != null) {
      setState(() {
        isLoggedIn = true;
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wanderlust',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn?HomeScreen(): LandingPage(),
    );
  }
}

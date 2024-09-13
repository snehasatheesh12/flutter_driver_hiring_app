import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users/DRIVER/driver_home.dart';
import 'package:users/DRIVER/driver_login.dart';

class DriverSplashscreen extends StatefulWidget {
  const DriverSplashscreen({super.key});

  @override
  State<DriverSplashscreen> createState() => _DriverSplashscreenState();
}

class _DriverSplashscreenState extends State<DriverSplashscreen> {
  @override
  void initState() {
    super.initState();
    _checkDriverStatus();
  }

  Future<void> _checkDriverStatus() async {
    final SharedPreferences sharedprefs = await SharedPreferences.getInstance();
    var driverKey = sharedprefs.getString('get_id'); // Ensure correct key is used

    print('Driver key: $driverKey'); // Debugging statement

    await Future.delayed(Duration(seconds: 1));

    if (driverKey == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DriverLogin()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DriverHome()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Loading......"),
              SizedBox(height: 20),
              CircularProgressIndicator(color: Colors.lightBlue),
            ],
          ),
        ),
      ),
    );
  }
}

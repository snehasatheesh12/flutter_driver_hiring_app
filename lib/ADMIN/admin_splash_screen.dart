import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users/ADMIN/admin_home1.dart';
import 'package:users/ADMIN/admin_login.dart'; // Ensure correct path for AdminLogin

class AdminSplashscreen extends StatefulWidget {
  const AdminSplashscreen({super.key});

  @override
  State<AdminSplashscreen> createState() => _AdminSplashscreenState();
}

class _AdminSplashscreenState extends State<AdminSplashscreen> {
  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    final SharedPreferences sharedprefs = await SharedPreferences.getInstance();
    var adminKey = sharedprefs.getString('admin_id'); // Ensure correct key is used

    print('Admin key: $adminKey'); // Debugging statement

    await Future.delayed(Duration(seconds: 1));

    if (adminKey == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminLogin()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminDashboard1()),
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

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users/USER/user_home.dart';
import 'package:users/USER/user_login.dart';

class UserSplashscreen extends StatefulWidget {
  const UserSplashscreen({super.key});

  @override
  State<UserSplashscreen> createState() => _UserSplashscreenState();
}

class _UserSplashscreenState extends State<UserSplashscreen> {
  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    final SharedPreferences sharedprefs = await SharedPreferences.getInstance();
    var userKey = sharedprefs.getString('user_id'); 
    print('User key: $userKey'); 
    await Future.delayed(Duration(seconds: 1));
    if (userKey == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserLogin()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserHome()),
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

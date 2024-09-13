import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverDrower extends StatefulWidget {
  const DriverDrower({super.key});

  @override
  State<DriverDrower> createState() => _DriverDrowerState();
}

class _DriverDrowerState extends State<DriverDrower> {
  String? username;
  String? userEmail;
  String? profilePicUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Username';
      userEmail = prefs.getString('userEmail') ?? 'info@gmail.com';
      profilePicUrl = prefs.getString('profilePicUrl') ?? 'assets/images/taxi.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[700],
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: profilePicUrl != null && !profilePicUrl!.startsWith('assets')
                    ? NetworkImage(profilePicUrl!) as ImageProvider
                    : AssetImage(profilePicUrl!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            username ?? 'Rapid Tech',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            userEmail ?? 'info@gmail.com',
            style: TextStyle(color: Colors.grey[200], fontSize: 14),
          ),
        ],
      ),
    );
  }
}

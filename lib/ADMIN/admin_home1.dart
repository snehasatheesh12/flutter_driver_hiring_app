import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users/ADMIN/admin_approved.dart';
import 'package:users/ADMIN/admin_login.dart';
import 'package:users/ADMIN/pendin_approval.dart';

class AdminDashboard1 extends StatefulWidget {
  @override
  _AdminDashboard1State createState() => _AdminDashboard1State();
}

class _AdminDashboard1State extends State<AdminDashboard1> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    ApprovedDriversScreen(),
PendingApprovalScreenforDriver()  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('admin_id');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AdminLogin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("admin Dashboard",style: GoogleFonts.poppins(color: Colors.white,fontSize: 20,fontWeight:FontWeight.w500),),
        centerTitle: true,
        backgroundColor: Colors.green.shade400,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Approved Drivers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pending),
            label: 'Pending Approval',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green.shade400,
        onTap: _onItemTapped,
      ),
    );
  }
}

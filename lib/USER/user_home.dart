import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users/USER/dashboard.dart';
import 'package:users/USER/myheder_drower.dart';
import 'package:users/USER/search2.dart';
import 'package:users/USER/user_login.dart';

class UserHome extends StatefulWidget {

  const UserHome({super.key});


  @override
  State<UserHome> createState() => _UserHomeState();

}

class _UserHomeState extends State<UserHome> {

  var currentPage = DrawerSections.dashboard;
  int _page = 0;


  final List<Widget> _pages = [
    userDashboard(), 
    // GoogleMapFlutter(),
    MainScreen4(),
    Center(child: Text("Settings Page")),
    Center(child: Text("Another Profile Page")), 
  ];
@override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Home", style: TextStyle(color: Colors.white))),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.green,
        color: Colors.green,
        animationDuration: const Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.home, size: 26, color: Colors.white),
          Icon(Icons.search, size: 26, color: Colors.white),
          Icon(Icons.settings, size: 26, color: Colors.white),
          Icon(Icons.person, size: 26, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: _pages[_page],
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyhederDrower(),
              MyDrawerlist(),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected, BuildContext context) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.dashboard;
              Navigator.push(context, MaterialPageRoute(builder: (context) => userDashboard()));
            }
            // Add more navigation cases if needed
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(child: Icon(icon, color: Colors.white)),
              Expanded(
                flex: 1,
                child: Text(title, style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget MyDrawerlist() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          menuItem(1, 'Dashboard', Icons.dashboard_outlined, currentPage == DrawerSections.dashboard, context),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserLogin()),
    );
  }
}
enum DrawerSections {
  dashboard,
}


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users/ADMIN/Driver_detail_screen.dart';
import 'package:users/ADMIN/admin_login.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Driver Home"),
        backgroundColor: Colors.green.shade400,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context), 
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('role', isEqualTo: 'driver')
                      .where('isApproved', isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final approvedDrivers = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: approvedDrivers.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(approvedDrivers[index]['username']),
                          subtitle: Text('Email: ${approvedDrivers[index]['email']}'),
                          trailing: Icon(Icons.check, color: Colors.green),
                        );
                      },
                    );
                  },
                ),
              ),
              Divider(),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('role', isEqualTo: 'driver')
                      .where('isApproved', isEqualTo: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final pendingDrivers = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: pendingDrivers.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(pendingDrivers[index]['username']),
                          subtitle: Text('Email: ${pendingDrivers[index]['email']}'),
                          trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DriverDetailsScreen(
                                    driverId: pendingDrivers[index].id,
                                  ),
                                ),
                              );
                            },
                            child: Text('Approve'),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('admin_id'); // Remove the saved email or user data

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AdminLogin()),
    );
  }
}

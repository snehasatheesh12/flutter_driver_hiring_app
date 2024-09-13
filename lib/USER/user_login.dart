import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users/USER/forget_user.dart';
import 'package:users/USER/user_register.dart';
import 'package:users/firebsae_auth.dart'; // Ensure correct path for AuthServices

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthServices authService = Provider.of<AuthServices>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset('assets/images/user.jpg'),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "User Sign in",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter an email";
                          }
                          return null;
                        },
                        obscureText: false,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Colors.green.shade300),
                          ),
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.green.shade900),
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green.shade500),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green.shade900),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a password";
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Colors.green.shade300),
                          ),
                          labelText: "Password",
                          labelStyle: TextStyle(color: Colors.green.shade900),
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green.shade500),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green.shade900),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();
                          try {
                            final user = await authService.signInWithEmailAndPassword(email, password);
                            if (user != null) {
                              await fetchAndStoreUserData();
                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                              await prefs.setString('user_id', email);
                              Navigator.pushNamed(context, '/user_home');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Login is successful')),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Login failed')),
                              );
                            }
                          } catch (e) {
                            print('Error during login: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Login error: ${e.toString()}')),
                            );
                          }
                        }
                      },
                      child: Text(
                        'Sign in',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'New User?',
                          style: TextStyle(color: Colors.black87, fontSize: 15),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => User_register()),
                            );
                          },
                          child: Text("Create Account"),
                        ),
                      ],
                    ),
                       SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgetUser()),
                          );
                        },
                        child: Text("Forgot Password?"),
                      ),
                    ),
                  ],
                )),
                  ],
                ),
              ),
          ),
        );
  }
Future<void> fetchAndStoreUserData() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    Map<String, dynamic>? userDetails = await AuthServices().getUserDetails(user.uid);
    if (userDetails != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', userDetails['username']);
      await prefs.setString('userEmail', userDetails['email']);
      await prefs.setString('profilePicUrl', userDetails['imageUrl'] ?? 'default_image_url');
    }
  }
}

}


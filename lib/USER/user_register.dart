import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:users/USER/user_login.dart';
import 'package:users/firebsae_auth.dart';

class User_register extends StatefulWidget {
  const User_register({super.key});

  @override
  State<User_register> createState() => _User_registerState();
}

class _User_registerState extends State<User_register> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repasswordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController Address = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

  Future<void>_pickImage()async{
    final picker=ImagePicker();
    final PickedFile=await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if(PickedFile!=null){
        _imageFile=File(PickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthServices authService = Provider.of<AuthServices>(context,listen: false);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Image.asset('assets/images/user.jpg'),
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Sign up here",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                       SizedBox(height: 20),
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                          child: _imageFile == null ? Icon(Icons.add_a_photo, size: 50) : null,
                        ),
                      ),
                      SizedBox(height: 2),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: TextFormField(
                          controller: usernameController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter a Username";
                            }
                            return null;
                          },
                          onSaved: (name) {},
                          obscureText: false,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.green.shade300),
                            ),
                            label: Text("Username"),
                            labelStyle: TextStyle(color: Colors.green.shade900),
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green.shade500,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green.shade900,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter an email";
                            }
                            if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                          onSaved: (name) {},
                          obscureText: false,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.green.shade300),
                            ),
                            label: Text("Email"),
                            labelStyle: TextStyle(color: Colors.green.shade900),
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green.shade500,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green.shade900,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: TextFormField(
                          controller: phoneNumberController,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter a phone number";
                            }
                            return null;
                          },
                          onSaved: (name) {},
                          obscureText: false,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.green.shade300),
                            ),
                            label: Text("Phone"),
                            labelStyle: TextStyle(color: Colors.green.shade900),
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green.shade500,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green.shade900,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2),
                        Padding(
                        padding: EdgeInsets.all(20),
                        child: TextFormField(
                          controller:Address,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your address";
                            }
                            return null;
                          },
                          onSaved: (name) {},
                          obscureText: false,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.green.shade300),
                            ),
                            label: Text("Address"),
                            labelStyle: TextStyle(color: Colors.green.shade900),
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green.shade500,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green.shade900,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter a password";
                            }
                            return null;
                          },
                          onSaved: (name) {},
                          obscureText: true,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.green.shade300),
                            ),
                            label: Text("Password"),
                            labelStyle: TextStyle(color: Colors.green.shade900),
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green.shade500,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green.shade900,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: TextFormField(
                          controller: repasswordController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter a confirm password";
                            }
                            if (passwordController.text != repasswordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                          onSaved: (name) {},
                          obscureText: true,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.green.shade300),
                            ),
                            label: Text("Confirm Password"),
                            labelStyle: TextStyle(color: Colors.green.shade900),
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green.shade500,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green.shade900,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade800,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: _isLoading ? null : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              _formKey.currentState!.save();
                              String email = emailController.text;
                              String password = passwordController.text;
                              String username = usernameController.text;
                              String phonenumber = phoneNumberController.text;
                              String address=Address.text;
                              String role = 'user';
                              User? user = await authService.registerWithEmailAndPassword(email, password, username, phonenumber, role, address,imageFile: _imageFile);
                              setState(() {
                                _isLoading = false;
                              });
                              if (user != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Registration is successful')),
                                );
                                Navigator.pushNamed(context, '/user_login');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Registration failed')),
                                );
                              }
                            }
                          },
                          child: _isLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                )
                              : Text(
                                  'Sign Up',
                                  style: TextStyle(color: Colors.white, fontSize: 15),
                                ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(color: Colors.black87, fontSize: 15),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UserLogin()),
                              );
                            },
                            child: Text("Login here"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

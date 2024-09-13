import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:users/DRIVER/driver_login.dart';
import 'package:users/firebsae_auth.dart';

class Diver_register extends StatefulWidget {
  const Diver_register({super.key});

  @override
  State<Diver_register> createState() => _Diver_registerState();
}

class _Diver_registerState extends State<Diver_register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repasswordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  File? _imageFile;
  File? _nonCriminalCertificate;
  bool _isLoading = false;

 Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }
  Future<void> _pickCertificate() async {
  final result = await FilePicker.platform.pickFiles(type: FileType.any);
  if (result != null && result.files.single.path != null) {
    setState(() {
      _nonCriminalCertificate = File(result.files.single.path!);
    });
  }
}


  @override
  Widget build(BuildContext context) {
    final AuthServices authService = Provider.of<AuthServices>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Image.asset('assets/images/taxi.png'),
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
                        "Driver Sign up",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                      SizedBox(height: 5),
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
                      SizedBox(height: 5),
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
                          controller: addressController,
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
                      SizedBox(height: 5),
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
                       SizedBox(height: 20),
                         ElevatedButton.icon(
                          
                              onPressed: _pickCertificate,
                                     icon: Icon(Icons.attach_file),
                           label: Text(_nonCriminalCertificate != null ? 'Certificate Selected' : 'Upload Non-Criminal Certificate'),
                       ),
                                    if (_nonCriminalCertificate != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Certificate: ${_nonCriminalCertificate!.path.split('/').last}',
                          style: TextStyle(color: Colors.green.shade900),
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
                              String address=addressController.text;
                              String role = 'driver';
                              User? user = await authService.registerWithEmailAndPassword(email, password, username, phonenumber, role,address,imageFile: _imageFile,nonCriminalCertificate: _nonCriminalCertificate);
                              setState(() {
                                _isLoading = false;
                              });
                              if (user != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Registration is successful')),
                                );
                                Navigator.pushNamed(context, '/driver_login');
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
                                MaterialPageRoute(builder: (context) => DriverLogin()),
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

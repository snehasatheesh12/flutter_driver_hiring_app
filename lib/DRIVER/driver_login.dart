import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users/DRIVER/driver_forget.dart';
import 'package:users/DRIVER/driver_register.dart';
import 'package:users/firebsae_auth.dart';

class DriverLogin extends StatefulWidget {
  const DriverLogin({super.key});
  @override
  State<DriverLogin> createState() => _DriverLoginState();
}
class _DriverLoginState extends State<DriverLogin> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final AuthServices authService = Provider.of<AuthServices>(context);
    return Scaffold(
       body: SafeArea
      (child: SingleChildScrollView(
        child: Column(
          children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Image.asset('assets/images/taxi.png',),
                ),
            ), 
            SizedBox(height: 20,), 
            Container(
            child: Form(
              key:_formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    " Rider Sign in",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                       SizedBox(height:5),
                  Padding(
                      padding: EdgeInsets.all(20),
                      child: TextFormField(
                         controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a email";
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
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              // color: Colors.grey[400],
                              color: Colors.green.shade500,
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green.shade900
                              )),
                        ),
                      )),
                       SizedBox(height:5),         
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
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              // color: Colors.grey[400],
                              color: Colors.green.shade500,
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green.shade900
                              )),
                        ),
                      )),                  
                       SizedBox(
                    
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade800,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                        ),
                      ),
                      onPressed: ()async {
                        if (_formKey.currentState!.validate()) {
                           
                          _formKey.currentState!.save();
                          final email=emailController.text;
                          final password=passwordController.text;
                          // final user =await authService.signInWithEmailAndPassword(email,password);
                          final user = await authService.signInDriverWithEmailAndPassword(email, password, context);

                          if(user != null)
                          {
                             final SharedPreferences prefs = await SharedPreferences.getInstance();
                             await prefs.setString('get_id', email);
                            // Navigator.pushNamed(context, '/driver_home');
                                  print('Driver login successful');


                             ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Login is successful')),
                                );
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Login is failed ')),
                                );
                          }
                        }
                      },
                      child: Text(
                        'Sign in',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
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
                              MaterialPageRoute(
                                  builder: (context) => Diver_register()));
                                },
                           child: Text("Create Account")),
                            Center(
                     
                      
                    ),
                       ],
                  ), 
                    Center(
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DriverForget()),
                            );
                          },
                          child: Text("Forgot Password?"),
                        ),
                    ),    
         ],
        ),
      )),
    ])))
    );
  }
}

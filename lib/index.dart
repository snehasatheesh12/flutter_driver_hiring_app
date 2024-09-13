import 'package:flutter/material.dart';
import 'package:users/ADMIN/admin_splash_screen.dart';
import 'package:users/DRIVER/driver_Splashscreen.dart';
import 'package:users/USER/user_splash_screen.dart';



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:Builder(
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child:Column(
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      child: Image.asset('assets/images/home.png',),
                    ),
                    SizedBox(height: 20,),
                      Column(
                        children: [
                          Container(
                          width: 300,
                          height: 48,
                          child: ElevatedButton(onPressed: (){
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>DriverSplashscreen()));
                          }, child: Text('DRIVER',style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w500),),
                          
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black
                          ),
                          ),
                         ),
                            SizedBox(height: 20,),

                          Container(
                          
                          width: 300,
                          height: 48,
                          child: ElevatedButton(onPressed: (){
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>UserSplashscreen()));
                          }, child: Text('USER',style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w500),),
                          
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black
                          ),
                          ), 
                        ),
                                                                          SizedBox(height: 20,),
                          Container(
                          
                          width: 300,
                          height: 48,
                          child: ElevatedButton(onPressed: (){
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminSplashscreen()));
                          }, child: Text('ADMIN',style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w500),),
                          
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black
                          ),
                          ),
                                              ),
                        ],
                      ),
                  ],
                )
                
              ),
            );
          }
        )
      ),
    );
  }
}

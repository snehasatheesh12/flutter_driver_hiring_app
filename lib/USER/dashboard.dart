import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class userDashboard extends StatefulWidget {
  const userDashboard({super.key});

  @override
  State<userDashboard> createState() => _userDashboardState();
}

class _userDashboardState extends State<userDashboard> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    backgroundColor: Colors.white,
    body: SingleChildScrollView(
        child: Column(

          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                    width: 600,
                    child: Image.asset('assets/images/passenger.jpg',fit: BoxFit.cover)

                ),

                // Center(
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(vertical:30),
                //     child: Container(
                //       height: 30,
                //       width: 350,
                //       child: Center(child: Text("are you waiting for a drive",style: GoogleFonts.aclonica(color: Colors.blueGrey,fontSize: 13),)),
                //       // child:Text("Welcome $user_key",style: GoogleFonts.b612(fontWeight: FontWeight.bold,fontSize:25,color: Colors.green.shade900),),
                //     ),
                //   ),
                // ),
            
              ],
            ),
            SizedBox(height: 5,),
            Row(
              children: [
                SizedBox(width: 15,),
                Card(
                  elevation: 10,
                  shadowColor: Colors.green,
                  child: InkWell(
                    child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(75), // Image radius
                              child: Image.asset('assets/images/abc.jpeg', fit: BoxFit.cover),
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            // child: Text("Craft",style: GoogleFonts.b612(fontSize: 22,color: Colors.green.shade900,fontWeight: FontWeight.bold),),
                          )
                        ]
                    ),
                    onTap: (){
                    },
                  ),

                ),
                SizedBox(width:15,),
                Stack(
                    children:[
                      Card(
                        elevation: 10,
                        shadowColor: Colors.green,
                        child: InkWell(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(75), // Image radius
                              child: Image.asset('assets/images/abc1.jpg', fit: BoxFit.cover),
                            ),

                          ),
                          onTap: ()
                          {
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        // child: Text("Events",style: GoogleFonts.b612(fontSize: 22,color: Colors.green.shade900,fontWeight: FontWeight.bold),),
                      )
                    ]
                ),
              ],
            ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10,horizontal:5),
              height: 40,
              width: 400,
              color: Colors.green.shade400,
            child: Center(child: Text("Explore your Drive with us",style: GoogleFonts.aclonica(color: Colors.grey.shade900,),)),
            ),
            Row(
              children: [
                SizedBox(width: 15,),
                Card(
                  elevation: 10,
                  shadowColor: Colors.green,
                  child: InkWell(
                    child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(75), // Image radius
                              child: Image.asset('assets/images/service1.jpg', fit: BoxFit.cover),
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.all(6),
                            // child: Text("My Orders",style: GoogleFonts.b612(fontSize: 22,color: Colors.green.shade900,fontWeight: FontWeight.bold),),
                          )
                        ]
                    ),
                    onTap: (){
                    },
                  ),

                ),
                SizedBox(width: 15,),
                Stack(
                    children:[
                      Card(
                        elevation: 10,
                        shadowColor: Colors.green,
                        child: InkWell(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(75), // Image radius
                              child: Image.asset('assets/images/women_car.jpg', fit: BoxFit.cover),
                            ),

                          ),
                          onTap: ()
                          {
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        // child: Text("Cart",style: GoogleFonts.b612(fontSize: 22,color: Colors.green.shade900,fontWeight: FontWeight.bold),),
                      )
                    ]
                ),
              ],
            ),
            SizedBox(height: 15,),
            Row(
              children: [
                SizedBox(width: 5,),
                Container(
                  color: Colors.white,
                  height: 100,
                  width: 350,
                  child: Image.asset('assets/images/women_car1.jpg', fit: BoxFit.fill),
                )
              ],
            )
          ],
        ),
      ),

   );
  }
}


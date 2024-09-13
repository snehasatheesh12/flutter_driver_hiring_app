import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users/ADMIN/admin_forget.dart';
import 'package:users/ADMIN/admin_home1.dart';
import 'package:users/ADMIN/admin_login.dart';
import 'package:users/ADMIN/admin_splash_screen.dart';
import 'package:users/DRIVER/driver_Splashscreen.dart';
import 'package:users/DRIVER/driver_forget.dart';
import 'package:users/DRIVER/driver_home.dart';
import 'package:users/DRIVER/driver_login.dart';
import 'package:users/DRIVER/driver_register.dart';
import 'package:users/DRIVER/pendng_approval.dart';
import 'package:users/USER/forget_user.dart';
import 'package:users/USER/user_home.dart';
import 'package:users/USER/user_login.dart';
import 'package:users/USER/user_register.dart';
import 'package:users/USER/user_splash_screen.dart';
import 'package:users/firebase_options.dart';
import 'package:users/firebsae_auth.dart';
import 'package:users/index.dart';
import 'package:users/infoHandeler/app_info.dart'; 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthServices>(
          create: (_) => AuthServices(),
        ),
        ChangeNotifierProvider<Appinfo>(
          create: (_) => Appinfo(),
        ),
      ],
      child: MaterialApp(
        title: 'Driver Booking App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
          '/driver_login': (context) => DriverLogin(),
          '/driver_reg': (context) => Diver_register(),
          '/driver_splash': (context) => DriverSplashscreen(),
          '/driver_home': (context) => DriverHome(),
          '/user_login': (context) => UserLogin(),
          '/user_reg': (context) => User_register(),
          '/user_splash': (context) => UserSplashscreen(),
          '/user_home': (context) => UserHome(),
          '/forget_user': (context) => ForgetUser(),
          '/forget_driver': (context) => DriverForget(),
          '/admin-login':(context)=>AdminLogin(),
          '/admin-password':(context)=>AdminForget(),
          '/admin_splashscreen':(context)=>AdminSplashscreen(),
          '/admin_home':(context)=>AdminDashboard1(),
          '/pendingApproval': (context) => PendingApprovalScreen(),
        },
      ),
    );
  }
}



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:karmac/screens/home_page.dart';
import 'package:karmac/screens/otp_screen_page.dart';
import 'package:karmac/screens/phone_auth_screen.dart';
import 'package:karmac/screens/profile_screen.dart';
import 'package:karmac/screens/service_center_details.dart';
import './screens/login_screen.dart';
import './screens/splash_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  HttpOverrides.global = new MyHttpOverrides();
  await dotenv.load(fileName: '.env');
  FirebaseApp? secondary;
  try {
    secondary = await Firebase.initializeApp(
      name: 'business',
      options: FirebaseOptions(
        projectId: 'karmac-business',
        appId: '1:1020312111053:android:0334acf1b869e7c55aa684',
        apiKey: 'AIzaSyAFA4nO-vfj4NOtwzI3FvX_Hex1KrBM7Ms',
        messagingSenderId: '1020312111053',
      ),
    );
  } on FirebaseException catch (e) {
    if (e.code == 'duplicate-app') {
      secondary = Firebase.app('business');
    } else {
      throw e;
    }
  } catch (e) {
    throw e;
  }
  await Firebase.initializeApp();
  runApp(Karmac());
}

class Karmac extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (ctx) => SplashScreen(),
        HomePage.routeName: (ctx) => HomePage(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        PhoneAuthScreen.routeName: (ctx) => PhoneAuthScreen(),
        OTPScreen.routeName: (ctx) => OTPScreen(),
        ServiceCenterDetailsScreen.routeName: (ctx) =>
            ServiceCenterDetailsScreen(),
      },
    );
  }
}

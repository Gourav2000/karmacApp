import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:karmac/screens/home_page.dart';
import 'package:karmac/screens/introduction_screen.dart';
import './profile_screen.dart';
import './login_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final data = GetStorage();
  @override
  void initState() {
    Timer(Duration(seconds: 3), () async {
      FirebaseAuth _auth = FirebaseAuth.instance;
      Iterable d = data.getKeys();
      if (!d.contains('showIntro')) {
        await data.write('showIntro', false);
        Get.offAll(() => IntroductionScreen());
        return;
      } else {
        if (_auth.currentUser == null) {
          Get.offAll(() => LoginScreen());
        } else {
          await FirebaseFirestore.instance
              .collection('Users')
              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .get()
              .then((value) {
            if (value.docs.isEmpty) {
              Get.offAll(() => ProfileScreen());
            } else {
              Get.offAll(() => HomePage());
            }
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Center(
          child: Container(
            width: Get.width,
            height: Get.width * 0.5,
            child: OverflowBox(
              minHeight: Get.width * 0.5,
              minWidth: Get.width,
              maxHeight: Get.width * 2,
              maxWidth: Get.width * 2,
              child: Image.asset(
                'assets/anim/logo.gif',
                width: Get.width * 3 / 2,
                gaplessPlayback: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

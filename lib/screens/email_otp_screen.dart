import 'package:flutter/material.dart';
import 'package:karmac/auth.config.dart';
import 'package:karmac/screens/home_page.dart';
import 'package:otp_screen/otp_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './profile_screen.dart';
import 'package:get/get.dart';
import '../models/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_auth/email_auth.dart';

class EmailOTPScreen extends StatefulWidget {
  @override
  State<EmailOTPScreen> createState() => _EmailOTPScreenState();
}

class _EmailOTPScreenState extends State<EmailOTPScreen> {
  Auth _auth = Get.put(Auth());
  var email = Get.arguments;
  late EmailAuth emailAuth;
  bool result = false;

  @override
  void initState() {
    super.initState();
    emailAuth = new EmailAuth(
      sessionName: 'Karmac',
    );
    emailAuth.config(remoteServerConfiguration);
  }

  void sendOtp() async {
    bool result = await emailAuth.sendOtp(
      recipientMail: email,
      otpLength: 5,
    );
    if (result) {
      print('email sent');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(
          color: Colors.grey.shade400,
        ),
      ),
      body: OtpScreen.withGradientBackground(
        otpLength: 5,
        subTitle: 'please enter the OTP sent to your email ${email}',
        validateOtp: (String otp) async {
          result = emailAuth.validateOtp(recipientMail: email, userOtp: otp);
          print(result);
          if (result) {
            Get.back(result: result);
            return 'Email verified';
          } else {
            return 'Invalid code!!';
          }
        },
        routeCallback: (context) async {
          //Get.back(result: result);
        },
        titleColor: Colors.lightGreen,
        themeColor: Colors.grey.shade400,
        topColor: Colors.black,
        bottomColor: Colors.black,
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:karmac/screens/home_page.dart';
import 'package:karmac/screens/phone_auth_screen.dart';
import 'package:karmac/screens/profile_screen.dart';
import 'package:sign_button/sign_button.dart';
import '../models/auth_controller.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Auth _auth = Get.put(Auth());
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: height * 0.45,
                    width: width,
                    child: Image.asset(
                      'assets/images/login.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      height: 120,
                      width: 200,
                      child: Image.asset(
                        'assets/images/logo2.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: (height * 0.45) * 0.05,
                      width: width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black,
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: height * 0.55,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.only(
                          right: 15,
                          left: 15,
                        ),
                        child: AutoSizeText(
                          'Experience the smoothest car servicing ever with Karmac',
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.lightGreen,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.only(
                          right: 15,
                          left: 15,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.lightGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 15,
                                    bottom: 15,
                                  ),
                                  child: Text(
                                    'Continue with phone number',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Get.to(() => PhoneAuthScreen());
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        width: Get.width,
                        padding: const EdgeInsets.only(
                          right: 15,
                          left: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                constraints: BoxConstraints(
                                  minHeight: 50,
                                ),
                                child: SignInButton(
                                  buttonSize: ButtonSize.large,
                                  btnText: 'Sign in with Google',
                                  btnColor: Colors.black,
                                  btnTextColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      width: 1,
                                      color: Colors.lightGreen,
                                    ),
                                  ),
                                  buttonType: ButtonType.google,
                                  onPressed: () async {
                                    await _auth.signInwithGoogle();
                                    if (FirebaseAuth.instance.currentUser !=
                                        null) {
                                      await FirebaseFirestore.instance
                                          .collection('Users')
                                          .where('uid',
                                              isEqualTo: FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          .get()
                                          .then((value) {
                                        if (value.docs.isEmpty) {
                                          Get.offAll(() => ProfileScreen());
                                        } else {
                                          Get.offAll(() => HomePage());
                                        }
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.only(
                          right: 15,
                          left: 15,
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    'By continuing you agree that you have read and accepted our T&Cs and privacy policies ',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 13,
                                ),
                              ),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.snackbar(
                                      'T&Cs',
                                      'hello',
                                      colorText: Colors.white,
                                    );
                                  },
                                text: 'T&Cs',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.lightGreen,
                                  fontSize: 13,
                                ),
                              ),
                              TextSpan(
                                text: ' and ',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 13,
                                ),
                              ),
                              TextSpan(
                                text: 'privacy policies',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.snackbar(
                                      'T&Cs',
                                      'hello',
                                      colorText: Colors.white,
                                    );
                                  },
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.lightGreen,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

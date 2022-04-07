import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karmac/screens/home_page.dart';
import 'package:karmac/screens/login_screen.dart';
import 'package:karmac/screens/profile_screen.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  PageController controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = Get.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: height,
        width: Get.width,
        child: Column(
          children: [
            Container(
              height: height * 0.8,
              width: Get.width,
              child: PageView(
                controller: controller,
                children: [
                  Container(
                    height: height * 0.8,
                    width: Get.width,
                    child: Column(
                      children: [
                        Container(
                          height: (height * 0.8) * 0.6,
                          width: Get.width,
                          child: Image.asset(
                            'assets/images/onboard1.png',
                            height: (height * 0.8) * 0.6,
                            width: Get.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: AutoSizeText(
                            'Welcome to Karmac',
                            minFontSize: 1,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 20,
                            ),
                            child: AutoSizeText(
                              'KARMAC makes your car servicing experience smoother, transparent and efficient',
                              minFontSize: 1,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: height * 0.8,
                    width: Get.width,
                    child: Column(
                      children: [
                        Container(
                          height: (height * 0.8) * 0.6,
                          width: Get.width,
                          child: Image.asset(
                            'assets/images/onboard2.png',
                            height: (height * 0.8) * 0.6,
                            width: Get.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: AutoSizeText(
                            'Monitor Progress',
                            minFontSize: 1,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 20,
                            ),
                            child: AutoSizeText(
                              'Keep track of your vehicle orders, manage it and have a personalised profile for your car for its unique needs',
                              minFontSize: 1,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: height * 0.8,
                    width: Get.width,
                    child: Column(
                      children: [
                        Container(
                          height: (height * 0.8) * 0.6,
                          width: Get.width,
                          child: Image.asset(
                            'assets/images/onboard3.png',
                            height: (height * 0.8) * 0.6,
                            width: Get.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: AutoSizeText(
                            'Seamless Process',
                            minFontSize: 1,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 20,
                            ),
                            child: AutoSizeText(
                              'Connect with service centres on chat and call while making payment seamlessly anytime',
                              minFontSize: 1,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 18,
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
            Container(
              height: height * 0.2,
              width: Get.width,
              child: Column(
                children: [
                  Container(
                    height: height * 0.1,
                    alignment: Alignment.center,
                    child: PageIndicator(
                      controller: controller,
                      count: 3,
                      size: 15,
                      space: 10,
                      color: Color.fromRGBO(0, 0, 255, 1),
                      activeColor: Colors.blue.shade200,
                    ),
                  ),
                  Container(
                    height: height * 0.1,
                    width: Get.width,
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () async {
                        if (FirebaseAuth.instance.currentUser == null) {
                          Get.offAll(() => LoginScreen());
                        } else {
                          await FirebaseFirestore.instance
                              .collection('Users')
                              .where('uid',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid)
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
                      child: Container(
                        height: (height * 0.1) - 20,
                        width: Get.width,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Colors.lightGreen,
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AutoSizeText(
                              'Get Started',
                              minFontSize: 1,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
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
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:karmac/widgets/app_drawer.dart';
import 'package:get/get.dart';
import 'package:karmac/widgets/karmac.dart';
import 'package:lottie/lottie.dart';
import './chat_list_screen.dart';
import './payment_screen.dart';
import './travel_screen.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RxInt index = 0.obs;
  var _pages = [
    KarmacScreen(),
    TravelScreen(),
    PaymentScreen(),
    ChatListScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        if(index.value==0)
          {
            print('exiting');
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
        return Future.delayed(Duration(milliseconds: 0), () {
          return false;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.lightGreen,
          ),
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
          title: Image.asset(
            'assets/images/logo2.png',
            height: 56,
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.lightGreen,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.grey.shade400,
              ),
              onPressed: () {},
            ),
          ],
        ),
        drawer: AppDrawer(),
        drawerScrimColor: Colors.black87,
        body: Obx(
          () => SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  _pages[index.value],
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 56,
                      width: Get.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black,
                            Colors.black,
                            Colors.black54,
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: BottomNavigationBar(
                        backgroundColor: Colors.transparent,
                        selectedFontSize: 12,
                        fixedColor: Colors.lightGreen,
                        onTap: (value) {
                          setState(() {
                            index.value = value;
                          });
                        },
                        currentIndex: index.value,
                        items: [
                          BottomNavigationBarItem(
                            backgroundColor: Colors.transparent,
                            activeIcon: Image.asset(
                              'assets/images/logo.png',
                              height: 24,
                            ),
                            icon: Image.asset(
                              'assets/images/logo1.png',
                              height: 24,
                            ),
                            label: 'Karmac',
                          ),
                          BottomNavigationBarItem(
                            backgroundColor: Colors.transparent,
                            activeIcon: LottieBuilder.asset(
                              'assets/anim/travel.json',
                              height: 28,
                              width: 28,
                            ),
                            /*Icon(
                            Icons.location_on,
                            color: Colors.red,
                          ),*/
                            icon: Icon(Icons.location_on_outlined),
                            label: 'Travel',
                          ),
                          BottomNavigationBarItem(
                            backgroundColor: Colors.transparent,
                            activeIcon: LottieBuilder.asset(
                              'assets/anim/payment.json',
                              height: 28,
                              width: 28,
                            ),
                            /*Icon(
                            Icons.payment,
                            color: Colors.lightGreen,
                          ),*/
                            icon: Icon(Icons.payment_outlined),
                            label: 'Payment',
                          ),
                          BottomNavigationBarItem(
                            backgroundColor: Colors.transparent,
                            activeIcon: LottieBuilder.asset(
                              'assets/anim/chat.json',
                              height: 28,
                              width: 28,
                            ),
                            /*Icon(
                            Icons.chat,
                            color: Colors.blue,
                          ),*/
                            icon: Icon(Icons.chat_outlined),
                            label: 'Chat',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:karmac/models/user_controller.dart';
import '../screens/contact_screen.dart';
import 'package:lottie/lottie.dart';
import '../screens/home_page.dart';
import '../screens/login_screen.dart';
import '../screens/my_car_screen.dart';
import '../screens/my_orders_screen.dart';
import '../screens/my_profile_screen.dart';
import '../screens/favorite_screen.dart';
import '../models/auth_controller.dart';
import 'package:get/get.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Auth _auth = Get.put(Auth());
  UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Obx(
      () => Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + height * 0.03,
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.7,
        color: Colors.white.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
                ),
                foregroundImage: NetworkImage(userController.isLoading.value
                    ? 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'
                    : userController.userDetails!.imgUrl),
                backgroundColor: Colors.grey.shade400,
              ),
              title: AutoSizeText(
                userController.isLoading.value
                    ? 'Loading...'
                    : userController.userDetails?.name,
                minFontSize: 1,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 20,
                ),
              ),
              subtitle: AutoSizeText(
                userController.isLoading.value
                    ? 'Loading...'
                    : userController.userDetails?.email,
                minFontSize: 1,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 12,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Divider(
                color: Colors.white,
              ),
            ),
            ListTile(
              onTap: () {
                Get.offAll(() => HomePage());
              },
              leading: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (rect) => LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.lightGreen,
                    Colors.lightGreen,
                    Colors.white,
                  ],
                ).createShader(rect),
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              title: AutoSizeText(
                'Home',
                minFontSize: 1,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 20,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(() => MyProfileScreen());
              },
              leading: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (rect) => LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.lightGreen,
                    Colors.lightGreen,
                    Colors.white,
                  ],
                ).createShader(rect),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              /*Icon(
              Icons.person,
              color: Colors.white,
            ),*/
              title: AutoSizeText(
                'Profile',
                minFontSize: 1,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 20,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(() => MyCarScreen());
              },
              leading: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (rect) => LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.lightGreen,
                    Colors.lightGreen,
                    Colors.white,
                  ],
                ).createShader(rect),
                child: FaIcon(
                  FontAwesomeIcons.car,
                  color: Colors.white,
                  size: 24,
                ),
              ),

              /*FaIcon(
              FontAwesomeIcons.car,
              color: Colors.white,
            ),*/
              title: AutoSizeText(
                'My Cars',
                minFontSize: 1,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 20,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(() => MyOrdersScreen());
              },
              leading: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (rect) => LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.lightGreen,
                    Colors.lightGreen,
                    Colors.white,
                  ],
                ).createShader(rect),
                child: FaIcon(
                  FontAwesomeIcons.list,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              /*FaIcon(
              FontAwesomeIcons.listAlt,
              color: Colors.white,
            ),*/
              title: AutoSizeText(
                'My Orders',
                minFontSize: 1,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 20,
                ),
              ),
            ),
            /*ListTile(
              onTap: () {
                Get.to(() => FavoriteScreen());
              },
              leading: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (rect) => LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.lightGreen,
                    Colors.lightGreen,
                    Colors.white,
                  ],
                ).createShader(rect),
                child: FaIcon(
                  FontAwesomeIcons.tools,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              /*FaIcon(
              FontAwesomeIcons.tools,
              color: Colors.white,
            ),*/
              title: AutoSizeText(
                'Service Centers',
                minFontSize: 1,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 20,
                ),
              ),
            ),*/
            Expanded(
              child: ListTile(
                onTap: () {
                  Get.to(() => ContactScreen());
                },
                leading: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (rect) => LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.lightGreen,
                      Colors.lightGreen,
                      Colors.white,
                    ],
                  ).createShader(rect),
                  child: Icon(
                    Icons.phone,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                /*Icon(
                Icons.phone,
                color: Colors.white,
              ),*/
                title: AutoSizeText(
                  'Contact Us',
                  minFontSize: 1,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            /*ListTile(
            onTap: () {
              _auth.signOut();
              Get.to(() => LoginScreen());
            },
            leading: FaIcon(
              FontAwesomeIcons.signOutAlt,
              color: Colors.white,
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                color: Colors.lightGreen,
                fontSize: 20,
              ),
            ),
          ),*/
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Divider(
                color: Colors.white,
                height: 0,
              ),
            ),
            ListTile(
              leading: Text(
                'version:',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

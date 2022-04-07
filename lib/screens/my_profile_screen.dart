import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:karmac/models/car_details_controller.dart';
import 'package:karmac/models/karmac_controller.dart';
import 'package:karmac/models/order_controller.dart';
import 'package:karmac/models/service_center.dart';
import 'package:karmac/models/user_address_controller.dart';
import 'package:karmac/screens/book_slot_screen.dart';
import 'package:lottie/lottie.dart';
import './my_address_screen.dart';
import '../models/user_car_controller.dart';
import './login_screen.dart';
import './edit_profile_screen.dart';
import '../widgets/app_drawer.dart';
import '../models/user_controller.dart';
import '../models/auth_controller.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  UserController userController = Get.put(UserController());
  UserCarDetails userCarDetails = Get.put(UserCarDetails());
  CarDetailsController carDetailsController = Get.put(CarDetailsController());
  OrderController orderController = Get.put(OrderController());
  KarmacController karmacController = Get.put(KarmacController());
  UserAddressController userAddressController =
      Get.put(UserAddressController());
  Auth _auth = Get.put(Auth());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 26, 26, 1),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.lightGreen,
        ),
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
              Icons.bookmark,
              color: Colors.grey.shade400,
            ),
            onPressed: () {},
          ),
        ],
      ),
      drawer: AppDrawer(),
      drawerScrimColor: Colors.black87,
      body: Obx(
        () => userController.isLoading.value ||
                orderController.isLoading.value ||
                userCarDetails.isLoading.value ||
                karmacController.isLoading.value ||
                userAddressController.isLoading.value ||
                carDetailsController.isLoading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.lightGreen,
                ),
              )
            : ListView(
                children: [
                  Stack(
                    children: [
                      Container(
                        color: Colors.black,
                        width: Get.width,
                        height: 406,
                      ),
                      Positioned(
                        top: 0,
                        child: Container(
                          height: (Get.width * 9 / 16) + 186,
                          width: Get.width,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: Get.width,
                                    height: (Get.width * 9 / 16) + 50,
                                  ),
                                  Positioned(
                                    top: 0,
                                    child: Container(
                                      height: Get.width * 9 / 16,
                                      width: Get.width,
                                      color: Colors.white,
                                      child: userCarDetails.cars.length == 0
                                          ? CachedNetworkImage(
                                              width: Get.width,
                                              height: Get.width * 9 / 16,
                                              imageUrl:
                                                  'https://drive.google.com/uc?export=view&id=1ObDONVXqRXSraNmTWBd4OvJg4jWlYqHZ',
                                              placeholder: (context, val) {
                                                return LottieBuilder.asset(
                                                  'assets/anim/bimg.json',
                                                  fit: BoxFit.contain,
                                                  width: Get.width,
                                                  height: Get.width * 9 / 16,
                                                );
                                              },
                                            )
                                          : Swiper(
                                              itemCount:
                                                  userCarDetails.cars.length,
                                              autoplay: true,
                                              itemBuilder: (context, i) {
                                                return CachedNetworkImage(
                                                  imageUrl: carDetailsController
                                                              .brands
                                                              .firstWhere((e) =>
                                                                  e.name.toUpperCase() ==
                                                                  userCarDetails
                                                                      .cars[i]
                                                                      .brand
                                                                      .toUpperCase())
                                                              .models
                                                              .firstWhere((e) =>
                                                                  e.name.toUpperCase() ==
                                                                  userCarDetails
                                                                      .cars[i]
                                                                      .model
                                                                      .toUpperCase())
                                                              .side ==
                                                          ''
                                                      ? 'https://drive.google.com/uc?export=view&id=1ObDONVXqRXSraNmTWBd4OvJg4jWlYqHZ'
                                                      : carDetailsController.brands
                                                          .firstWhere((e) =>
                                                              e.name.toUpperCase() ==
                                                              userCarDetails
                                                                  .cars[i].brand
                                                                  .toUpperCase())
                                                          .models
                                                          .firstWhere(
                                                              (e) => e.name.toUpperCase() == userCarDetails.cars[i].model.toUpperCase())
                                                          .side,
                                                  placeholder: (context, val) {
                                                    return LottieBuilder.asset(
                                                      'assets/anim/bimg.json',
                                                      fit: BoxFit.contain,
                                                      width: Get.width,
                                                      height:
                                                          Get.width * 9 / 16,
                                                    );
                                                  },
                                                );
                                              },
                                              viewportFraction: 1,
                                              scale: 1,
                                            ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: Get.width * 0.5 - 57,
                                    child: Container(
                                      height: 114,
                                      width: 114,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.lightGreen,
                                      ),
                                      child: CircleAvatar(
                                        radius: 55,
                                        foregroundImage: NetworkImage(FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .photoURL !=
                                                null
                                            ? FirebaseAuth
                                                .instance.currentUser!.photoURL
                                                .toString()
                                            : 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'),
                                        backgroundImage: NetworkImage(
                                            'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'),
                                        backgroundColor: Colors.grey.shade400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  left: 10,
                                  right: 10,
                                  bottom: 10,
                                ),
                                alignment: Alignment.center,
                                child: AutoSizeText(
                                  '${userController.userDetails?.name}',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  left: 10,
                                  right: 10,
                                ),
                                alignment: Alignment.center,
                                child: AutoSizeText(
                                  '+91-${userController.userDetails?.phoneNumber}',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    ),
                                    onPressed: null,
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        bottom: 10,
                                      ),
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        '${userController.userDetails?.email}',
                                        minFontSize: 1,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.grey.shade400,
                                    ),
                                    onPressed: () {
                                      Get.to(() => EditProfileScreen());
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: (Get.width - 20) / 3,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            left: 4,
                            right: 4,
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 3,
                            color: Colors.black,
                            shadowColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                left: 5,
                                right: 5,
                                bottom: 10,
                              ),
                              child: Column(
                                children: [
                                  AutoSizeText(
                                    'Cars registered on Karmac',
                                    minFontSize: 5,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  AutoSizeText(
                                    userCarDetails.cars.length.toString(),
                                    minFontSize: 1,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.lightGreenAccent.shade400,
                                      fontSize: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: (Get.width - 20) / 3,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 3,
                            color: Colors.black,
                            shadowColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                left: 5,
                                right: 5,
                                bottom: 10,
                              ),
                              child: Column(
                                children: [
                                  AutoSizeText(
                                    'Service Centers visited',
                                    minFontSize: 5,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  AutoSizeText(
                                    orderController.sIds.length.toString(),
                                    minFontSize: 1,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.lightGreenAccent.shade400,
                                      fontSize: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: (Get.width - 20) / 3,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            left: 4,
                            right: 4,
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 3,
                            color: Colors.black,
                            shadowColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                left: 5,
                                right: 5,
                                bottom: 10,
                              ),
                              child: Column(
                                children: [
                                  AutoSizeText(
                                    'Total orders on Karmac',
                                    minFontSize: 5,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  AutoSizeText(
                                    orderController.orders.length.toString(),
                                    minFontSize: 1,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.lightGreenAccent.shade400,
                                      fontSize: 25,
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
                  Container(
                    width: Get.width,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      left: 4,
                      right: 4,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      color: Colors.black,
                      shadowColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 10,
                          right: 10,
                          bottom: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              'My Addresses',
                              minFontSize: 5,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            AutoSizeText(
                              userAddressController.addresses.length == 0
                                  ? 'You don\'t have any address added yet'
                                  : '${userAddressController.addresses[0].flat}, ${userAddressController.addresses[0].address}',
                              minFontSize: 1,
                              maxLines: null,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Divider(
                              color: Colors.grey.shade600,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => MyAddressScreen());
                                },
                                child: AutoSizeText(
                                  'View more',
                                  style: TextStyle(
                                    color: Colors.lightGreen,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: Get.width,
                    padding: const EdgeInsets.only(
                      top: 4,
                      bottom: 4,
                      left: 4,
                      right: 4,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      color: Colors.black,
                      shadowColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 10,
                          right: 10,
                          bottom: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              'Payment Methods',
                              minFontSize: 5,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            AutoSizeText(
                              'HDFC Bank 4585',
                              minFontSize: 1,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 15,
                              ),
                            ),
                            AutoSizeText(
                              'Savings Account',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Divider(
                              color: Colors.grey.shade600,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: AutoSizeText(
                                'View 2 more',
                                style: TextStyle(
                                  color: Colors.lightGreen,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: Get.width,
                    padding: const EdgeInsets.only(
                      top: 4,
                      bottom: 8,
                      left: 4,
                      right: 4,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      color: Colors.black,
                      shadowColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 10,
                          right: 10,
                          bottom: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              'Past Transactions',
                              minFontSize: 5,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AutoSizeText(
                                  'TRANSFER TO',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                AutoSizeText(
                                  '09 AUG 2021',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            AutoSizeText(
                              '3199523162095-INB State Bank Collect',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Divider(
                              color: Colors.grey.shade600,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: AutoSizeText(
                                'View 20+ Details',
                                style: TextStyle(
                                  color: Colors.lightGreen,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 15,
                    ),
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.tools,
                          color: Colors.grey.shade400,
                          size: 18,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        AutoSizeText(
                          'Service Centers Visited',
                          minFontSize: 1,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 250,
                    width: Get.width,
                    child: orderController.sIds.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/empty.png',
                                  height: 130,
                                  fit: BoxFit.fitHeight,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 40,
                                    right: 40,
                                    top: 30,
                                  ),
                                  child: AutoSizeText(
                                    "Your order with service center hasn't been completed yet. If you have initiated the order, the service center will appear here once it is completed.",
                                    minFontSize: 1,
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: orderController.sIds.length,
                            itemBuilder: (context, i) {
                              ServiceCenter s = karmacController.serviceCenters
                                  .firstWhere(
                                      (e) => e.id == orderController.sIds[i]);
                              return Padding(
                                padding: i == 0
                                    ? const EdgeInsets.only(
                                        top: 10,
                                        left: 8,
                                        right: 2,
                                        bottom: 5,
                                      )
                                    : i == orderController.sIds.length - 1
                                        ? const EdgeInsets.only(
                                            top: 10,
                                            left: 2,
                                            right: 8,
                                            bottom: 5,
                                          )
                                        : const EdgeInsets.only(
                                            top: 10,
                                            left: 2,
                                            right: 2,
                                            bottom: 5,
                                          ),
                                child: Container(
                                  height: 230,
                                  width: 180,
                                  child: Material(
                                    elevation: 0,
                                    color: Colors.transparent,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.grey.shade800,
                                          width: 1,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                width: 178,
                                                height: 120,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        'https://drive.google.com/uc?export=view&id=1WADBO26yNIOozbH-IHTXtrejFlpjWnNn',
                                                    width: 178,
                                                    height: 95,
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        (context, val) {
                                                      return LottieBuilder
                                                          .asset(
                                                        'assets/anim/bimg.json',
                                                        fit: BoxFit.contain,
                                                        width: 178,
                                                        height: 95,
                                                      );
                                                    },
                                                  ),
                                                  /*FadeInImage.assetNetwork(
                                              placeholder:
                                                  'assets/anim/bgImg.gif',
                                              image:
                                                  'https://drive.google.com/uc?export=view&id=1WADBO26yNIOozbH-IHTXtrejFlpjWnNn',
                                              width: 178,
                                              height: 95,
                                              fit: BoxFit.fill,
                                            ),*/
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                left: 180 * 0.5 - 25,
                                                child: CircleAvatar(
                                                  radius: 25,
                                                  backgroundImage: NetworkImage(
                                                    carDetailsController.brands
                                                        .firstWhere((element) =>
                                                            element.name ==
                                                            s.brand)
                                                        .imageUrl,
                                                  ),
                                                  backgroundColor: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              top: 8,
                                            ),
                                            child: AutoSizeText(
                                              s.company,
                                              minFontSize: 1,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          /*Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8,
                                        right: 8,
                                        top: 8,
                                      ),
                                      child: AutoSizeText(
                                        s.address,
                                        minFontSize: 1,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),*/
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              top: 4,
                                            ),
                                            child: AutoSizeText(
                                              '${s.city}, ${s.state}',
                                              minFontSize: 1,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                            ),
                                            child: AutoSizeText(
                                              'last visited: ${orderController.orders.firstWhere((e) => e.serviceCentreId == s.id).date}',
                                              minFontSize: 1,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              top: 4,
                                              bottom: 8,
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      Get.to(
                                                          () =>
                                                              BookSlotScreen(),
                                                          arguments: {
                                                            'index': karmacController
                                                                .serviceCenters
                                                                .indexWhere(
                                                                    (element) =>
                                                                        element
                                                                            .id ==
                                                                        s.id),
                                                            'id': s.id,
                                                          });
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.lightGreen,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: AutoSizeText(
                                                        'Book Now',
                                                        style: TextStyle(
                                                          color: Colors.black,
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
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Divider(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.settings,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        AutoSizeText(
                          'User Settings',
                          minFontSize: 1,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                    ),
                    child: Divider(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            _auth.signOut();
                            Get.offAll(() => LoginScreen());
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            //color: Colors.green,
                            padding: EdgeInsets.all(7.5),
                            decoration: BoxDecoration(
                                color: Colors.lightGreen,
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: Text(
                              'Logout of this app',
                              style: TextStyle(
                                color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                        //Spacer(),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            alignment: Alignment.centerLeft,
                            //color: Colors.green,
                            decoration: BoxDecoration(
                              color: Colors.lightGreen,
                              borderRadius: BorderRadius.circular(5)
                            ),
                            padding: EdgeInsets.all(7.5),
                            child: Text(
                              'Logout of all devices',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold
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

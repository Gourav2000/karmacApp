import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:karmac/models/user_car_controller.dart';
import 'package:lottie/lottie.dart';
import '../widgets/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:auto_size_text/auto_size_text.dart';
import './manage_car_screen.dart';
import '../models/car_details_controller.dart';

class MyCarScreen extends StatefulWidget {
  @override
  _MyCarScreenState createState() => _MyCarScreenState();
}

class _MyCarScreenState extends State<MyCarScreen> {
  UserCarDetails userCarDetails = Get.put(UserCarDetails());
  CarDetailsController carDetailsController = Get.put(CarDetailsController());
  var index = 0.obs;
  RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.lightGreen,
        ),
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: Text(
          'My Cars',
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
        () => userCarDetails.isLoading.value ||
                carDetailsController.isLoading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.lightGreen,
                ),
              )
            : Stack(
                children: [
                  Container(
                    width: width,
                    height: height,
                    color: Colors.black,
                  ),
                  Positioned(
                    top: 0,
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/mycars.png',
                          fit: BoxFit.fill,
                          height: height * 0.35 + 15,
                          width: width,
                        ),
                        Positioned(
                          bottom: 25,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: width * 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                    bottom: 8,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'karmac allows you to Switch between your car collection, check its health status and get every relevant update related to it',
                                        maxLines: null,
                                        style: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 10,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.grey.shade800,
                                          ),
                                          child: Text(
                                            'Learn more',
                                            style: TextStyle(
                                              fontSize: 8,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: width * 0.5,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8,
                                        bottom: 8,
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary:
                                              Colors.lightGreenAccent.shade400,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        child: Text(
                                          'Manage Cars',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        onPressed: () {
                                          isLoading.value = true;
                                          Get.to(() => ManageCarScreen())
                                              ?.then((value) {
                                            index.value = 0;
                                            isLoading.value = false;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            blurRadius: 10,
                          )
                        ],
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      height: height * 0.65,
                      width: width,
                      child: isLoading.value
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Colors.lightGreen,
                              ),
                            )
                          : userCarDetails.cars.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 200,
                                        child: OverflowBox(
                                          minHeight: 400,
                                          maxHeight: 400,
                                          minWidth: 400,
                                          maxWidth: 400,
                                          child: LottieBuilder.asset(
                                            'assets/anim/car.json',
                                          ),
                                        ),
                                      ),
                                      /*Image.asset(
                                        'assets/anim/car1.gif',
                                        fit: BoxFit.fitWidth,
                                        height: 200,
                                      ),*/
                                      Text(
                                        'You don\'t have any cars in your collection',
                                        style: TextStyle(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView(
                                  physics: BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics(),
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 16,
                                        left: 16,
                                        top: 16,
                                      ),
                                      child: Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.car,
                                            color: Colors.grey.shade400,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '${FirebaseAuth.instance.currentUser!.displayName}\'s Collection',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8,
                                        left: 8,
                                        top: 4,
                                      ),
                                      child: Divider(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    Container(
                                      width: width,
                                      height: 300,
                                      child: Swiper(
                                        itemCount: userCarDetails.cars.length,
                                        index: index.value,
                                        loop: userCarDetails.cars.length == 1
                                            ? false
                                            : true,
                                        onIndexChanged: (val) {
                                          index.value = val;
                                        },
                                        itemBuilder: (context, i) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: [
                                                i == index.value
                                                    ? BoxShadow(
                                                        color: Color.fromRGBO(
                                                            0, 0, 255, 1),
                                                        blurRadius: 10,
                                                      )
                                                    : BoxShadow()
                                              ],
                                              border: Border.all(
                                                width: 2,
                                                color: i == index.value
                                                    ? Colors.blue.shade900
                                                    : Colors.grey.shade700,
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 8,
                                                    ),
                                                    child: CachedNetworkImage(
                                                      imageUrl: carDetailsController
                                                                  .brands
                                                                  .firstWhere((e) =>
                                                                      e.name.toUpperCase() ==
                                                                      userCarDetails.cars[i].brand
                                                                          .toUpperCase())
                                                                  .models
                                                                  .firstWhere((e) =>
                                                                      e.name.toUpperCase() ==
                                                                      userCarDetails.cars[i].model
                                                                          .toUpperCase())
                                                                  .up ==
                                                              ''
                                                          ? 'https://drive.google.com/uc?export=view&id=1ZTngu9nhlaucu150aU2XJ_6NMQry8xzC'
                                                          : carDetailsController
                                                              .brands
                                                              .firstWhere((e) =>
                                                                  e.name.toUpperCase() ==
                                                                  userCarDetails
                                                                      .cars[i]
                                                                      .brand
                                                                      .toUpperCase())
                                                              .models
                                                              .firstWhere(
                                                                  (e) => e.name.toUpperCase() == userCarDetails.cars[i].model.toUpperCase())
                                                              .up,
                                                      width:
                                                          (Get.width * 0.5) - 4,
                                                      height: 140,
                                                      placeholder:
                                                          (context, val) {
                                                        return Center(
                                                          child: LottieBuilder
                                                              .asset(
                                                            'assets/anim/bimg.json',
                                                            fit: BoxFit.contain,
                                                            width: (Get.width *
                                                                    0.5) -
                                                                4,
                                                            height: 140,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Flexible(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 8,
                                                        ),
                                                        child: Image.network(
                                                          carDetailsController
                                                              .brands
                                                              .firstWhere((e) =>
                                                                  e.name
                                                                      .toUpperCase() ==
                                                                  userCarDetails
                                                                      .cars[i]
                                                                      .brand
                                                                      .toUpperCase())
                                                              .imageUrl,
                                                          height: 40,
                                                          width: 40,
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex: 3,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 10,
                                                          right: 10,
                                                        ),
                                                        child: AutoSizeText(
                                                          '${userCarDetails.cars[i].model}',
                                                          minFontSize: 1,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey.shade400,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: Colors
                                                                .grey.shade900,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 4,
                                                            bottom: 4,
                                                            left: 4,
                                                            right: 4,
                                                          ),
                                                          child: AutoSizeText(
                                                            userCarDetails
                                                                .cars[i]
                                                                .variant,
                                                            minFontSize: 1,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              color: Colors.grey
                                                                  .shade400,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors.black,
                                                          border: Border.all(
                                                            width: 2,
                                                            color: Colors
                                                                .blue.shade900,
                                                          ),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                        child: AutoSizeText(
                                                          userCarDetails
                                                              .cars[i].type,
                                                          minFontSize: 1,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey.shade400,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: Colors
                                                                .grey.shade900,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 4,
                                                            bottom: 4,
                                                            left: 4,
                                                            right: 4,
                                                          ),
                                                          child: AutoSizeText(
                                                            userCarDetails
                                                                .cars[i].number,
                                                            minFontSize: 1,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              color: Colors.grey
                                                                  .shade400,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 4,
                                                    left: 4,
                                                    right: 4,
                                                    bottom: 8,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: Colors
                                                                .grey.shade900,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 4,
                                                            bottom: 4,
                                                            left: 4,
                                                            right: 4,
                                                          ),
                                                          child: AutoSizeText(
                                                            userCarDetails
                                                                .cars[i].color,
                                                            maxLines: 1,
                                                            minFontSize: 1,
                                                            style: TextStyle(
                                                              color: Colors.grey
                                                                  .shade400,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        outer: true,
                                        scale: 0.7,
                                        viewportFraction: 0.5,
                                        pagination: SwiperPagination(
                                            alignment: Alignment.bottomCenter,
                                            margin: const EdgeInsets.only(
                                              bottom: 0,
                                              right: 10,
                                              left: 10,
                                              top: 10,
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 16,
                                        left: 16,
                                        top: 16,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.health_and_safety,
                                            color: Colors.grey.shade400,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Car Health Status',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8,
                                        left: 8,
                                        top: 4,
                                      ),
                                      child: Divider(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.network(
                                          carDetailsController.brands
                                              .firstWhere((e) =>
                                                  e.name ==
                                                  userCarDetails
                                                      .cars[index.value].brand)
                                              .imageUrl,
                                          height: 40,
                                          width: 40,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                          ),
                                          child: AutoSizeText(
                                            userCarDetails
                                                .cars[index.value].model,
                                            minFontSize: 1,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 4,
                                        bottom: 4,
                                        left: 8,
                                        right: 8,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.grey.shade900,
                                              ),
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 8,
                                                left: 5,
                                                right: 5,
                                              ),
                                              child: AutoSizeText(
                                                userCarDetails
                                                    .cars[index.value].variant,
                                                minFontSize: 1,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Flexible(
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.grey.shade900,
                                              ),
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 8,
                                                left: 5,
                                                right: 5,
                                              ),
                                              child: AutoSizeText(
                                                userCarDetails
                                                    .cars[index.value].color,
                                                minFontSize: 1,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.grey.shade900,
                                              ),
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 8,
                                                left: 5,
                                                right: 5,
                                              ),
                                              child: AutoSizeText(
                                                userCarDetails
                                                    .cars[index.value].number,
                                                minFontSize: 1,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Flexible(
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.black,
                                                border: Border.all(
                                                  width: 2,
                                                  color: Colors.blue.shade900,
                                                ),
                                              ),
                                              padding: const EdgeInsets.only(
                                                left: 5,
                                                right: 5,
                                                top: 5,
                                                bottom: 5,
                                              ),
                                              child: AutoSizeText(
                                                userCarDetails
                                                    .cars[index.value].type,
                                                minFontSize: 1,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8,
                                        left: 8,
                                        top: 4,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade900,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ListTile(
                                          title: Text(
                                            'Total Distance Travelled',
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                          subtitle: Text(
                                            '35,000 Km',
                                            style: TextStyle(
                                              color: Colors
                                                  .lightGreenAccent.shade400,
                                            ),
                                          ),
                                          trailing: FaIcon(
                                            FontAwesomeIcons.locationArrow,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8,
                                        left: 8,
                                        top: 8,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade900,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ListTile(
                                          title: Text(
                                            'Total Trip',
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                          subtitle: Text(
                                            '5,000 Km',
                                            style: TextStyle(
                                              color: Colors
                                                  .lightGreenAccent.shade400,
                                            ),
                                          ),
                                          trailing: Icon(
                                            Icons.location_on,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8,
                                        left: 8,
                                        top: 8,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade900,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ListTile(
                                          title: Text(
                                            'Visual Inspection',
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                          subtitle: Text(
                                            'brakes, wheels, tyres, exhaust, steering and wiper blades, etc.',
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.lightGreen,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8,
                                        right: 8,
                                        top: 8,
                                        bottom: 8,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors
                                                    .lightGreenAccent.shade400,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: AutoSizeText(
                                                'Schedule a Service Now',
                                                maxLines: 1,
                                                minFontSize: 1,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              onPressed: () {},
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 3,
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {},
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Flexible(
                                                            child: Icon(
                                                              Icons.download,
                                                              color: Colors.grey
                                                                  .shade600,
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex: 3,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 8,
                                                              ),
                                                              child:
                                                                  AutoSizeText(
                                                                'Download',
                                                                minFontSize: 1,
                                                                maxLines: 1,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade600,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 4,
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {},
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Flexible(
                                                            child: Icon(
                                                              Icons.print,
                                                              color: Colors.grey
                                                                  .shade600,
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex: 3,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 8,
                                                              ),
                                                              child:
                                                                  AutoSizeText(
                                                                'Print',
                                                                maxLines: 1,
                                                                minFontSize: 11,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade600,
                                                                ),
                                                              ),
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
                                  ],
                                ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:karmac/widgets/filter.dart';
import 'package:lottie/lottie.dart';
import 'package:karmac/models/karmac_controller.dart';
import 'package:karmac/screens/service_center_details.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../models/car_details_controller.dart';
import 'package:like_button/like_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:smart_select/smart_select.dart';

class KarmacScreen extends StatefulWidget {
  @override
  _KarmacScreenState createState() => _KarmacScreenState();
}

class _KarmacScreenState extends State<KarmacScreen> {
  FirebaseApp secondary = Firebase.app("business");
  KarmacController karmacController = Get.put(KarmacController());
  CarDetailsController addCarController = Get.put(CarDetailsController());
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  RxBool isConnected = true.obs;
  FloatingSearchBarController searchController = FloatingSearchBarController();

  @override
  void initState() {
    super.initState();
    findConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        isConnected.value = false;
      } else {
        isConnected.value = true;
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    searchController.dispose();
    super.dispose();
  }

  void findConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
      if (result == ConnectivityResult.none) {
        isConnected.value = false;
      } else {
        isConnected.value = true;
      }
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => isConnected.value
          ? karmacController.isLoading.value || addCarController.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.lightGreen,
                  ),
                )
              : Stack(
                  children: [
                    Image.asset(
                      'assets/images/homebg.png',
                      height: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          kToolbarHeight,
                      width: MediaQuery.of(context).size.width,
                    ),
                    FloatingSearchBar(
                      borderRadius: BorderRadius.circular(20),
                      leadingActions: [
                        FloatingSearchBarAction.back(
                          showIfClosed: false,
                        ),
                        FloatingSearchBarAction.icon(
                          icon: Icons.search,
                          onTap: () {},
                          showIfOpened: false,
                        )
                      ],
                      backdropColor: Colors.black87,
                      automaticallyImplyDrawerHamburger: false,
                      hint: 'Search...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 18,
                      ),
                      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
                      transitionDuration: const Duration(milliseconds: 800),
                      transitionCurve: Curves.easeInOut,
                      physics: const BouncingScrollPhysics(),
                      axisAlignment: 0.0,
                      openAxisAlignment: 0.0,
                      width: Get.width,
                      onQueryChanged: (query) {
                        karmacController.searchService(searchController.query);
                      },
                      transition: SlideFadeFloatingSearchBarTransition(),
                      actions: [
                        FloatingSearchBarAction.icon(
                          icon: Icon(
                            Icons.tune,
                          ),
                          showIfOpened: false,
                          onTap: () {
                            Get.bottomSheet(
                              Filter(),
                            );
                          },
                        ),
                        FloatingSearchBarAction.searchToClear(
                          showIfClosed: false,
                        ),
                      ],
                      isScrollControlled: true,
                      controller: searchController,
                      builder: (context, transition) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            right: 10,
                            left: 10,
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.height -
                                MediaQuery.of(context).padding.top -
                                kToolbarHeight -
                                150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Obx(
                              () => ListView.builder(
                                itemCount: karmacController.s.length,
                                itemBuilder: (context, i) {
                                  return ListTile(
                                    onTap: () {
                                      int index = karmacController
                                          .serviceCenters
                                          .indexWhere((element) =>
                                              element.id ==
                                              karmacController.s[i].id);
                                      Get.to(() => ServiceCenterDetailsScreen(),
                                              arguments: index)
                                          ?.then((value) {
                                        searchController.query = '';
                                        FloatingSearchBar.of(context)?.close();
                                      });
                                    },
                                    title: Text(
                                      karmacController.s[i].company,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${karmacController.s[i].city}, ${karmacController.s[i].state}',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      backgroundColor: Colors.black,
                      border: BorderSide(
                        width: 2,
                        color: Colors.grey.shade600,
                      ),
                      showAfter: Duration(milliseconds: 0),
                      autocorrect: true,
                      toolbarOptions: ToolbarOptions(
                        copy: true,
                        paste: true,
                        selectAll: true,
                      ),
                      elevation: 10,
                      iconColor: Colors.lightGreen,
                      queryStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      body: Stack(
                        children: [
                          karmacController.filtered.isEmpty
                              ? ListView.builder(
                                  itemCount:
                                      karmacController.serviceCenters.length,
                                  physics: BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics(),
                                  ),
                                  itemBuilder: (context, i) {
                                    return Padding(
                                      padding: i == 0
                                          ? const EdgeInsets.only(
                                              top: 64,
                                              bottom: 8,
                                              left: 4,
                                              right: 4,
                                            )
                                          : i ==
                                                  karmacController
                                                          .serviceCenters
                                                          .length -
                                                      1
                                              ? const EdgeInsets.only(
                                                  top: 8,
                                                  bottom: 64,
                                                  left: 4,
                                                  right: 4,
                                                )
                                              : const EdgeInsets.only(
                                                  top: 8,
                                                  bottom: 8,
                                                  left: 4,
                                                  right: 4,
                                                ),
                                      child: Container(
                                        width: Get.width - 8,
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(
                                                () =>
                                                    ServiceCenterDetailsScreen(),
                                                arguments: i);
                                          },
                                          child: Material(
                                            elevation: 10,
                                            shadowColor: Colors.grey,
                                            color: Colors.transparent,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black87,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                  color: Colors.grey.shade800,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  15),
                                                          topRight:
                                                              Radius.circular(
                                                                  15),
                                                        ),
                                                        child: Hero(
                                                          tag: karmacController
                                                              .serviceCenters[i]
                                                              .id
                                                              .toString(),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                'https://drive.google.com/uc?export=view&id=1WADBO26yNIOozbH-IHTXtrejFlpjWnNn',
                                                            height: 180,
                                                            width:
                                                                Get.width - 10,
                                                            fit: BoxFit.cover,
                                                            placeholder:
                                                                (context, val) {
                                                              return LottieBuilder
                                                                  .asset(
                                                                'assets/anim/bimg.json',
                                                                fit: BoxFit
                                                                    .contain,
                                                                height: 180,
                                                                width:
                                                                    Get.width -
                                                                        10,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 5,
                                                        right: 5,
                                                        child: StreamBuilder(
                                                          stream: FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Users')
                                                              .doc(FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid)
                                                              .collection(
                                                                  'Favorites')
                                                              .where('sid',
                                                                  isEqualTo:
                                                                      karmacController
                                                                          .serviceCenters[
                                                                              i]
                                                                          .id)
                                                              .snapshots(),
                                                          builder: (context,
                                                              AsyncSnapshot<
                                                                      QuerySnapshot>
                                                                  snapshot) {
                                                            if (snapshot
                                                                .hasData) {
                                                              return LikeButton(
                                                                circleColor:
                                                                    CircleColor(
                                                                  start: Colors
                                                                      .lightGreen,
                                                                  end: Colors
                                                                      .lightGreen,
                                                                ),
                                                                bubblesColor:
                                                                    BubblesColor(
                                                                  dotPrimaryColor:
                                                                      Colors
                                                                          .lightGreen,
                                                                  dotSecondaryColor: Colors
                                                                      .lightGreenAccent
                                                                      .shade400,
                                                                ),
                                                                isLiked: snapshot
                                                                        .data!
                                                                        .docs
                                                                        .isEmpty
                                                                    ? false
                                                                    : snapshot.data!.docs.first['isFavorite'] ==
                                                                            true
                                                                        ? true
                                                                        : false,
                                                                likeBuilder:
                                                                    (val) {
                                                                  return Icon(
                                                                    Icons
                                                                        .bookmark,
                                                                    color: val
                                                                        ? Colors
                                                                            .redAccent
                                                                            .shade700
                                                                        : Colors
                                                                            .grey,
                                                                    size: 30,
                                                                  );
                                                                },
                                                                onTap:
                                                                    (val) async {
                                                                  try {
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'Users')
                                                                        .doc(FirebaseAuth
                                                                            .instance
                                                                            .currentUser!
                                                                            .uid)
                                                                        .collection(
                                                                            'Favorites')
                                                                        .doc(karmacController
                                                                            .serviceCenters[i]
                                                                            .id)
                                                                        .set({
                                                                      'sid': karmacController
                                                                          .serviceCenters[
                                                                              i]
                                                                          .id,
                                                                      'isFavorite':
                                                                          !val,
                                                                    });
                                                                    return !val;
                                                                  } on FirebaseException catch (e) {
                                                                    return val;
                                                                  } catch (error) {
                                                                    return val;
                                                                  }
                                                                },
                                                              );
                                                            } else {
                                                              return CircularProgressIndicator(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Flexible(
                                                                child:
                                                                    AutoSizeText(
                                                                  karmacController
                                                                      .serviceCenters[
                                                                          i]
                                                                      .company,
                                                                  minFontSize:
                                                                      1,
                                                                  maxLines: 1,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        25,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.verified,
                                                                color: Colors
                                                                    .lightGreen,
                                                                size: 15,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Image.network(
                                                          addCarController
                                                              .brands
                                                              .firstWhere((element) =>
                                                                  element
                                                                      .name ==
                                                                  karmacController
                                                                      .serviceCenters[
                                                                          i]
                                                                      .brand)
                                                              .imageUrl,
                                                          height: 40,
                                                          width: 40,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        /*AutoSizeText(
                                                karmacController
                                                    .serviceCenters[i].address,
                                                minFontSize: 1,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),*/
                                                        Flexible(
                                                          child: AutoSizeText(
                                                            '${karmacController.serviceCenters[i].city}, ${karmacController.serviceCenters[i].state}',
                                                            minFontSize: 1,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .lightGreen,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        3),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 4,
                                                            right: 4,
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                double.parse(karmacController
                                                                        .serviceCenters[
                                                                            i]
                                                                        .rating)
                                                                    .toPrecision(
                                                                        1)
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .black,
                                                                size: 15,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  /*Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                            ),
                                            child: AutoSizeText(
                                              '${karmacController.serviceCenters[i].city}, ${karmacController.serviceCenters[i].state}',
                                              minFontSize: 1,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),*/
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      right: 10,
                                                      left: 10,
                                                      top: 5,
                                                    ),
                                                    child: Divider(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      bottom: 10,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              AutoSizeText(
                                                                'Timing: ',
                                                                minFontSize: 1,
                                                                maxLines: 1,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              AnimatedTextKit(
                                                                animatedTexts: [
                                                                  FadeAnimatedText(
                                                                    '${karmacController.serviceCenters[i].startTime} - ${karmacController.serviceCenters[i].endTime}',
                                                                    textStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .lightGreenAccent
                                                                          .shade400,
                                                                    ),
                                                                    duration: Duration(
                                                                        seconds:
                                                                            5),
                                                                    fadeInEnd:
                                                                        0.1,
                                                                    fadeOutBegin:
                                                                        0.9,
                                                                  ),
                                                                  FadeAnimatedText(
                                                                    '${karmacController.serviceCenters[i].startTime} - ${karmacController.serviceCenters[i].endTime}',
                                                                    textStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .lightGreenAccent
                                                                          .shade400,
                                                                    ),
                                                                    duration: Duration(
                                                                        seconds:
                                                                            5),
                                                                    fadeInEnd:
                                                                        0.1,
                                                                    fadeOutBegin:
                                                                        0.9,
                                                                  ),
                                                                ],
                                                                repeatForever:
                                                                    true,
                                                                isRepeatingAnimation:
                                                                    true,
                                                                pause: Duration(
                                                                    seconds: 0),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 30,
                                                        ),
                                                        karmacController
                                                                .serviceCenters[
                                                                    i]
                                                                .isOpen
                                                            ? Flexible(
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    AnimatedTextKit(
                                                                      animatedTexts: [
                                                                        FadeAnimatedText(
                                                                          'Open',
                                                                          textStyle:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.lightGreenAccent.shade400,
                                                                          ),
                                                                          duration:
                                                                              Duration(seconds: 5),
                                                                          fadeInEnd:
                                                                              0.1,
                                                                          fadeOutBegin:
                                                                              0.9,
                                                                        ),
                                                                        FadeAnimatedText(
                                                                          'Open',
                                                                          textStyle:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.lightGreenAccent.shade400,
                                                                          ),
                                                                          duration:
                                                                              Duration(seconds: 5),
                                                                          fadeInEnd:
                                                                              0.1,
                                                                          fadeOutBegin:
                                                                              0.9,
                                                                        ),
                                                                      ],
                                                                      repeatForever:
                                                                          true,
                                                                      pause: Duration(
                                                                          seconds:
                                                                              0),
                                                                      isRepeatingAnimation:
                                                                          true,
                                                                    ),
                                                                    AutoSizeText(
                                                                      ' now',
                                                                      minFontSize:
                                                                          1,
                                                                      maxLines:
                                                                          1,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : Flexible(
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    AnimatedTextKit(
                                                                      animatedTexts: [
                                                                        FadeAnimatedText(
                                                                          'Closed',
                                                                          textStyle:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          duration:
                                                                              Duration(seconds: 5),
                                                                          fadeInEnd:
                                                                              0.1,
                                                                          fadeOutBegin:
                                                                              0.9,
                                                                        ),
                                                                        FadeAnimatedText(
                                                                          'Closed',
                                                                          textStyle:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          duration:
                                                                              Duration(seconds: 5),
                                                                          fadeInEnd:
                                                                              0.1,
                                                                          fadeOutBegin:
                                                                              0.9,
                                                                        ),
                                                                      ],
                                                                      repeatForever:
                                                                          true,
                                                                      pause: Duration(
                                                                          seconds:
                                                                              0),
                                                                      isRepeatingAnimation:
                                                                          true,
                                                                    ),
                                                                    AutoSizeText(
                                                                      ' now',
                                                                      minFontSize:
                                                                          1,
                                                                      maxLines:
                                                                          1,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
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
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : ListView.builder(
                                  itemCount: karmacController.filtered.length,
                                  physics: BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics(),
                                  ),
                                  itemBuilder: (context, i) {
                                    return Padding(
                                      padding: i == 0
                                          ? const EdgeInsets.only(
                                              top: 64,
                                              bottom: 8,
                                              left: 4,
                                              right: 4,
                                            )
                                          : i ==
                                                  karmacController
                                                          .filtered.length -
                                                      1
                                              ? const EdgeInsets.only(
                                                  top: 8,
                                                  bottom: 64,
                                                  left: 4,
                                                  right: 4,
                                                )
                                              : const EdgeInsets.only(
                                                  top: 8,
                                                  bottom: 8,
                                                  left: 4,
                                                  right: 4,
                                                ),
                                      child: Container(
                                        width: Get.width - 8,
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(
                                                () =>
                                                    ServiceCenterDetailsScreen(),
                                                arguments: karmacController
                                                    .serviceCenters
                                                    .indexWhere((e) =>
                                                        e.id ==
                                                        karmacController
                                                            .filtered[i].id));
                                          },
                                          child: Material(
                                            elevation: 10,
                                            shadowColor: Colors.grey,
                                            color: Colors.transparent,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black87,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                  color: Colors.grey.shade800,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  15),
                                                          topRight:
                                                              Radius.circular(
                                                                  15),
                                                        ),
                                                        child: Hero(
                                                          tag: karmacController
                                                              .filtered[i].id
                                                              .toString(),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                'https://drive.google.com/uc?export=view&id=1WADBO26yNIOozbH-IHTXtrejFlpjWnNn',
                                                            height: 180,
                                                            width:
                                                                Get.width - 10,
                                                            fit: BoxFit.cover,
                                                            placeholder:
                                                                (context, val) {
                                                              return LottieBuilder
                                                                  .asset(
                                                                'assets/anim/bimg.json',
                                                                fit: BoxFit
                                                                    .contain,
                                                                height: 180,
                                                                width:
                                                                    Get.width -
                                                                        10,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 5,
                                                        right: 5,
                                                        child: StreamBuilder(
                                                          stream: FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Users')
                                                              .doc(FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid)
                                                              .collection(
                                                                  'Favorites')
                                                              .where('sid',
                                                                  isEqualTo:
                                                                      karmacController
                                                                          .filtered[
                                                                              i]
                                                                          .id)
                                                              .snapshots(),
                                                          builder: (context,
                                                              AsyncSnapshot<
                                                                      QuerySnapshot>
                                                                  snapshot) {
                                                            if (snapshot
                                                                .hasData) {
                                                              return LikeButton(
                                                                circleColor:
                                                                    CircleColor(
                                                                  start: Colors
                                                                      .lightGreen,
                                                                  end: Colors
                                                                      .lightGreen,
                                                                ),
                                                                bubblesColor:
                                                                    BubblesColor(
                                                                  dotPrimaryColor:
                                                                      Colors
                                                                          .lightGreen,
                                                                  dotSecondaryColor: Colors
                                                                      .lightGreenAccent
                                                                      .shade400,
                                                                ),
                                                                isLiked: snapshot
                                                                        .data!
                                                                        .docs
                                                                        .isEmpty
                                                                    ? false
                                                                    : snapshot.data!.docs.first['isFavorite'] ==
                                                                            true
                                                                        ? true
                                                                        : false,
                                                                likeBuilder:
                                                                    (val) {
                                                                  return Icon(
                                                                    Icons
                                                                        .bookmark,
                                                                    color: val
                                                                        ? Colors
                                                                            .redAccent
                                                                            .shade700
                                                                        : Colors
                                                                            .grey,
                                                                    size: 30,
                                                                  );
                                                                },
                                                                onTap:
                                                                    (val) async {
                                                                  try {
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'Users')
                                                                        .doc(FirebaseAuth
                                                                            .instance
                                                                            .currentUser!
                                                                            .uid)
                                                                        .collection(
                                                                            'Favorites')
                                                                        .doc(karmacController
                                                                            .filtered[i]
                                                                            .id)
                                                                        .set({
                                                                      'sid': karmacController
                                                                          .filtered[
                                                                              i]
                                                                          .id,
                                                                      'isFavorite':
                                                                          !val,
                                                                    });
                                                                    return !val;
                                                                  } on FirebaseException catch (e) {
                                                                    return val;
                                                                  } catch (error) {
                                                                    return val;
                                                                  }
                                                                },
                                                              );
                                                            } else {
                                                              return CircularProgressIndicator(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Flexible(
                                                                child:
                                                                    AutoSizeText(
                                                                  karmacController
                                                                      .filtered[
                                                                          i]
                                                                      .company,
                                                                  minFontSize:
                                                                      1,
                                                                  maxLines: 1,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        25,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons.verified,
                                                                color: Colors
                                                                    .lightGreen,
                                                                size: 15,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Image.network(
                                                          addCarController
                                                              .brands
                                                              .firstWhere((element) =>
                                                                  element
                                                                      .name ==
                                                                  karmacController
                                                                      .filtered[
                                                                          i]
                                                                      .brand)
                                                              .imageUrl,
                                                          height: 40,
                                                          width: 40,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        /*AutoSizeText(
                                                karmacController
                                                    .serviceCenters[i].address,
                                                minFontSize: 1,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),*/
                                                        Flexible(
                                                          child: AutoSizeText(
                                                            '${karmacController.filtered[i].city}, ${karmacController.filtered[i].state}',
                                                            minFontSize: 1,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .lightGreen,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        3),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 4,
                                                            right: 4,
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                double.parse(karmacController
                                                                        .filtered[
                                                                            i]
                                                                        .rating)
                                                                    .toPrecision(
                                                                        1)
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .black,
                                                                size: 15,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  /*Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                            ),
                                            child: AutoSizeText(
                                              '${karmacController.serviceCenters[i].city}, ${karmacController.serviceCenters[i].state}',
                                              minFontSize: 1,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),*/
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      right: 10,
                                                      left: 10,
                                                      top: 5,
                                                    ),
                                                    child: Divider(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      bottom: 10,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              AutoSizeText(
                                                                'Timing: ',
                                                                minFontSize: 1,
                                                                maxLines: 1,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              AnimatedTextKit(
                                                                animatedTexts: [
                                                                  FadeAnimatedText(
                                                                    '${karmacController.filtered[i].startTime} - ${karmacController.filtered[i].endTime}',
                                                                    textStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .lightGreenAccent
                                                                          .shade400,
                                                                    ),
                                                                    duration: Duration(
                                                                        seconds:
                                                                            5),
                                                                    fadeInEnd:
                                                                        0.1,
                                                                    fadeOutBegin:
                                                                        0.9,
                                                                  ),
                                                                  FadeAnimatedText(
                                                                    '${karmacController.filtered[i].startTime} - ${karmacController.filtered[i].endTime}',
                                                                    textStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .lightGreenAccent
                                                                          .shade400,
                                                                    ),
                                                                    duration: Duration(
                                                                        seconds:
                                                                            5),
                                                                    fadeInEnd:
                                                                        0.1,
                                                                    fadeOutBegin:
                                                                        0.9,
                                                                  ),
                                                                ],
                                                                repeatForever:
                                                                    true,
                                                                isRepeatingAnimation:
                                                                    true,
                                                                pause: Duration(
                                                                    seconds: 0),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 30,
                                                        ),
                                                        karmacController
                                                                .filtered[i]
                                                                .isOpen
                                                            ? Flexible(
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    AnimatedTextKit(
                                                                      animatedTexts: [
                                                                        FadeAnimatedText(
                                                                          'Open',
                                                                          textStyle:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.lightGreenAccent.shade400,
                                                                          ),
                                                                          duration:
                                                                              Duration(seconds: 5),
                                                                          fadeInEnd:
                                                                              0.1,
                                                                          fadeOutBegin:
                                                                              0.9,
                                                                        ),
                                                                        FadeAnimatedText(
                                                                          'Open',
                                                                          textStyle:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.lightGreenAccent.shade400,
                                                                          ),
                                                                          duration:
                                                                              Duration(seconds: 5),
                                                                          fadeInEnd:
                                                                              0.1,
                                                                          fadeOutBegin:
                                                                              0.9,
                                                                        ),
                                                                      ],
                                                                      repeatForever:
                                                                          true,
                                                                      pause: Duration(
                                                                          seconds:
                                                                              0),
                                                                      isRepeatingAnimation:
                                                                          true,
                                                                    ),
                                                                    AutoSizeText(
                                                                      ' now',
                                                                      minFontSize:
                                                                          1,
                                                                      maxLines:
                                                                          1,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : Flexible(
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    AnimatedTextKit(
                                                                      animatedTexts: [
                                                                        FadeAnimatedText(
                                                                          'Closed',
                                                                          textStyle:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          duration:
                                                                              Duration(seconds: 5),
                                                                          fadeInEnd:
                                                                              0.1,
                                                                          fadeOutBegin:
                                                                              0.9,
                                                                        ),
                                                                        FadeAnimatedText(
                                                                          'Closed',
                                                                          textStyle:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          duration:
                                                                              Duration(seconds: 5),
                                                                          fadeInEnd:
                                                                              0.1,
                                                                          fadeOutBegin:
                                                                              0.9,
                                                                        ),
                                                                      ],
                                                                      repeatForever:
                                                                          true,
                                                                      pause: Duration(
                                                                          seconds:
                                                                              0),
                                                                      isRepeatingAnimation:
                                                                          true,
                                                                    ),
                                                                    AutoSizeText(
                                                                      ' now',
                                                                      minFontSize:
                                                                          1,
                                                                      maxLines:
                                                                          1,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
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
                                        ),
                                      ),
                                    );
                                  },
                                ),
                          Positioned(
                            top: 0,
                            child: Container(
                              width: Get.width,
                              height: 64,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black,
                                    Colors.black54,
                                    Colors.black54,
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/load.png',
                    height: 100,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AutoSizeText(
                    'Your car is away from servicing',
                    minFontSize: 1,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AutoSizeText(
                    'No Internet Connection',
                    minFontSize: 1,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  AutoSizeText(
                    'you are currently offline',
                    minFontSize: 1,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CircularProgressIndicator(
                    color: Colors.lightGreen,
                  ),
                ],
              ),
            ),
    );
  }
}

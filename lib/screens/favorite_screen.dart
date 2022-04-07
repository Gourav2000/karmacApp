import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../widgets/app_drawer.dart';
import '../models/car_details_controller.dart';
import '../models/karmac_controller.dart';
import './service_center_details.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  FirebaseApp secondary = Firebase.app("business");
  CarDetailsController addCarController = Get.put(CarDetailsController());
  KarmacController favoriteController = Get.put(KarmacController());
  RxBool isLoading = false.obs;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  RxBool isConnected = true.obs;

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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.lightGreen,
        ),
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: Text(
          'Service Centers',
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
        () => isConnected.value
            ? addCarController.isLoading.value ||
                    favoriteController.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.lightGreen,
                    ),
                  )
                : ListView(
                    physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 15,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.bookmark_border,
                              color: Colors.red,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                ),
                                child: AutoSizeText(
                                  'Service centers in your wishlist',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      /*Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                    ),
                    child: Divider(
                      color: Colors.grey.shade200,
                    ),
                  ),*/
                      Container(
                        height: 305,
                        width: Get.width,
                        child: isLoading.value
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Colors.lightGreen,
                                ),
                              )
                            : StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection('Favorites')
                                    .where('isFavorite', isEqualTo: true)
                                    .snapshots(),
                                builder:
                                    (context, AsyncSnapshot<QuerySnapshot> s) {
                                  if (s.hasData) {
                                    if (s.data!.docs.isNotEmpty) {
                                      return ListView.builder(
                                        itemCount: favoriteController
                                            .serviceCenters.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, i) {
                                          return StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection('Users')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .collection('Favorites')
                                                  .where('sid',
                                                      isEqualTo:
                                                          favoriteController
                                                              .serviceCenters[i]
                                                              .id)
                                                  .snapshots(),
                                              builder: (context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snap) {
                                                if (snap.hasData) {
                                                  if (snap.data!.docs
                                                          .isNotEmpty &&
                                                      snap.data!.docs.first[
                                                              'isFavorite'] ==
                                                          true) {
                                                    return Padding(
                                                      padding: i == 0
                                                          ? const EdgeInsets
                                                              .only(
                                                              top: 8,
                                                              bottom: 8,
                                                              left: 8,
                                                              right: 4,
                                                            )
                                                          : i ==
                                                                  favoriteController
                                                                          .serviceCenters
                                                                          .length -
                                                                      1
                                                              ? const EdgeInsets
                                                                  .only(
                                                                  top: 8,
                                                                  bottom: 8,
                                                                  left: 4,
                                                                  right: 8,
                                                                )
                                                              : const EdgeInsets
                                                                  .only(
                                                                  top: 8,
                                                                  bottom: 8,
                                                                  left: 4,
                                                                  right: 4,
                                                                ),
                                                      child: Container(
                                                        height: 295,
                                                        width: 200,
                                                        child: InkWell(
                                                          onTap: () {
                                                            Get.to(
                                                                () =>
                                                                    ServiceCenterDetailsScreen(),
                                                                arguments: i);
                                                          },
                                                          child: Card(
                                                            elevation: 7,
                                                            shadowColor:
                                                                Colors.grey,
                                                            color:
                                                                Colors.black87,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              side: BorderSide(
                                                                color: Colors
                                                                    .grey
                                                                    .shade800,
                                                                width: 1,
                                                              ),
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Stack(
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                          200,
                                                                      height:
                                                                          130,
                                                                    ),
                                                                    Positioned(
                                                                      top: 0,
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          topLeft:
                                                                              Radius.circular(15),
                                                                          topRight:
                                                                              Radius.circular(15),
                                                                        ),
                                                                        child:
                                                                            /*Container(
                                                                                                                      width: double.infinity,
                                                                                                                      height: MediaQuery.of(context)
                                                                                                                              .size
                                                                                                                              .height *
                                                                                                                          0.2,
                                                                                                                      child: BlurHash(
                                                                                                                        hash:
                                                                                                                            'LAJu4KD+ogxv0000-;M_~qx]-;V@',
                                                                                                                        image:
                                                                                                                            'https://drive.google.com/uc?export=view&id=1WADBO26yNIOozbH-IHTXtrejFlpjWnNn',
                                                                                                                        imageFit: BoxFit.fitWidth,
                                                                                                                      ),
                                                                                                                    )*/
                                                                            Image.network(
                                                                          'https://drive.google.com/uc?export=view&id=1WADBO26yNIOozbH-IHTXtrejFlpjWnNn',
                                                                          height:
                                                                              100,
                                                                          width:
                                                                              192,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      top: 1,
                                                                      right: 1,
                                                                      child:
                                                                          StreamBuilder(
                                                                        stream: FirebaseFirestore
                                                                            .instance
                                                                            .collection(
                                                                                'Users')
                                                                            .doc(FirebaseAuth
                                                                                .instance.currentUser!.uid)
                                                                            .collection(
                                                                                'Favorites')
                                                                            .where('sid',
                                                                                isEqualTo: favoriteController.serviceCenters[i].id)
                                                                            .snapshots(),
                                                                        builder:
                                                                            (context,
                                                                                AsyncSnapshot<QuerySnapshot> snapshot) {
                                                                          if (snapshot
                                                                              .hasData) {
                                                                            return IconButton(
                                                                              icon: snapshot.data!.docs.isEmpty
                                                                                  ? Icon(
                                                                                      Icons.bookmark_border,
                                                                                      color: Colors.black,
                                                                                      size: 30,
                                                                                    )
                                                                                  : snapshot.data!.docs.first['isFavorite'] == true
                                                                                      ? Icon(
                                                                                          Icons.bookmark,
                                                                                          color: Colors.redAccent.shade700,
                                                                                          size: 30,
                                                                                        )
                                                                                      : Icon(
                                                                                          Icons.bookmark_border,
                                                                                          color: Colors.black,
                                                                                          size: 30,
                                                                                        ),
                                                                              onPressed: () {
                                                                                if (snapshot.data!.docs.isEmpty) {
                                                                                  FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Favorites').doc(favoriteController.serviceCenters[i].id).set({
                                                                                    'sid': favoriteController.serviceCenters[i].id,
                                                                                    'isFavorite': true,
                                                                                  });
                                                                                } else {
                                                                                  if (snapshot.data!.docs.first['isFavorite'] == false) {
                                                                                    FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Favorites').doc(favoriteController.serviceCenters[i].id).update({
                                                                                      'isFavorite': true,
                                                                                    });
                                                                                  } else {
                                                                                    FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Favorites').doc(favoriteController.serviceCenters[i].id).update({
                                                                                      'isFavorite': false,
                                                                                    });
                                                                                  }
                                                                                }
                                                                              },
                                                                            );
                                                                          } else {
                                                                            return CircularProgressIndicator(
                                                                              color: Colors.grey.shade400,
                                                                            );
                                                                          }
                                                                        },
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      bottom: 2,
                                                                      left: 100 -
                                                                          25,
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Colors.grey,
                                                                              blurRadius: 3,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        child:
                                                                            CircleAvatar(
                                                                          radius:
                                                                              25,
                                                                          backgroundColor:
                                                                              Colors.black,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(5),
                                                                            child:
                                                                                Image.network(
                                                                              addCarController.brands.firstWhere((element) => element.name == favoriteController.serviceCenters[i].brand).imageUrl,
                                                                              height: 40,
                                                                              width: 40,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(10),
                                                                  child:
                                                                      AutoSizeText(
                                                                    favoriteController
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
                                                                          20,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    left: 10,
                                                                    right: 10,
                                                                  ),
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Flexible(
                                                                        child:
                                                                            AutoSizeText(
                                                                          favoriteController
                                                                              .serviceCenters[i]
                                                                              .address,
                                                                          minFontSize:
                                                                              1,
                                                                          maxLines:
                                                                              2,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                      FittedBox(
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.lightGreen,
                                                                            borderRadius:
                                                                                BorderRadius.circular(3),
                                                                          ),
                                                                          padding:
                                                                              const EdgeInsets.only(
                                                                            left:
                                                                                4,
                                                                            right:
                                                                                4,
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              AutoSizeText(
                                                                                double.parse(favoriteController.serviceCenters[i].rating).toPrecision(1).toString(),
                                                                                minFontSize: 1,
                                                                                maxLines: 1,
                                                                                style: TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontSize: 12,
                                                                                ),
                                                                              ),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors.black,
                                                                                size: 12,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      left: 10,
                                                                      right: 10,
                                                                    ),
                                                                    child:
                                                                        AutoSizeText(
                                                                      '${favoriteController.serviceCenters[i].city}, ${favoriteController.serviceCenters[i].state}',
                                                                      minFontSize:
                                                                          1,
                                                                      maxLines:
                                                                          1,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    right: 10,
                                                                    left: 10,
                                                                  ),
                                                                  child:
                                                                      Divider(
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
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
                                                                        flex: 5,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Flexible(
                                                                              flex: 3,
                                                                              child: AutoSizeText(
                                                                                'Timing: ',
                                                                                minFontSize: 1,
                                                                                maxLines: 1,
                                                                                style: TextStyle(
                                                                                  color: Colors.lightGreenAccent.shade400,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Flexible(
                                                                              flex: 2,
                                                                              child: AutoSizeText(
                                                                                '${favoriteController.serviceCenters[i].startTime}',
                                                                                maxLines: 1,
                                                                                minFontSize: 1,
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            AutoSizeText(
                                                                              ' - ',
                                                                              maxLines: 1,
                                                                              minFontSize: 1,
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 10,
                                                                              ),
                                                                            ),
                                                                            Flexible(
                                                                              flex: 2,
                                                                              child: AutoSizeText(
                                                                                favoriteController.serviceCenters[i].endTime,
                                                                                minFontSize: 1,
                                                                                maxLines: 1,
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Flexible(
                                                                        flex: 3,
                                                                        child: favoriteController.serviceCenters[i].isOpen
                                                                            ? Row(
                                                                                children: [
                                                                                  Flexible(
                                                                                    child: AutoSizeText(
                                                                                      'Open',
                                                                                      minFontSize: 1,
                                                                                      maxLines: 1,
                                                                                      style: TextStyle(
                                                                                        color: Colors.lightGreenAccent.shade400,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Flexible(
                                                                                    child: AutoSizeText(
                                                                                      ' now',
                                                                                      minFontSize: 1,
                                                                                      maxLines: 1,
                                                                                      style: TextStyle(
                                                                                        color: Colors.white,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            : Row(
                                                                                children: [
                                                                                  Flexible(
                                                                                    child: AutoSizeText(
                                                                                      'Currently ',
                                                                                      minFontSize: 1,
                                                                                      maxLines: 1,
                                                                                      style: TextStyle(
                                                                                        color: Colors.white,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Flexible(
                                                                                    child: AutoSizeText(
                                                                                      'Closed',
                                                                                      minFontSize: 1,
                                                                                      maxLines: 1,
                                                                                      style: TextStyle(
                                                                                        color: Colors.red,
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
                                                      ),
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                } else {
                                                  return Container();
                                                }
                                              });
                                        },
                                      );
                                    } else {
                                      return Center(
                                        child: Text(
                                          'You don\'t have any service centers added in your wishlist',
                                          style: TextStyle(
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.lightGreen,
                                      ),
                                    );
                                  }
                                },
                              ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 30,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                ),
                                child: AutoSizeText(
                                  'Highest rated service centers',
                                  minFontSize: 1,
                                  maxLines: 1,
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
                      /*Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                    ),
                    child: Divider(
                      color: Colors.grey.shade500,
                    ),
                  ),*/
                      Container(
                        height: 305,
                        width: Get.width,
                        child: isLoading.value
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Colors.lightGreen,
                                ),
                              )
                            : ListView.builder(
                                itemCount: favoriteController.highRated.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, i) {
                                  return Padding(
                                    padding: i == 0
                                        ? const EdgeInsets.only(
                                            top: 8,
                                            bottom: 8,
                                            left: 8,
                                            right: 4,
                                          )
                                        : i ==
                                                favoriteController
                                                        .highRated.length -
                                                    1
                                            ? const EdgeInsets.only(
                                                top: 8,
                                                bottom: 8,
                                                left: 4,
                                                right: 8,
                                              )
                                            : const EdgeInsets.only(
                                                top: 8,
                                                bottom: 8,
                                                left: 4,
                                                right: 4,
                                              ),
                                    child: Container(
                                      height: 295,
                                      width: 200,
                                      child: InkWell(
                                        onTap: () {
                                          var index = favoriteController
                                              .serviceCenters
                                              .indexWhere((element) =>
                                                  element.id ==
                                                  favoriteController
                                                      .highRated[i].id);
                                          Get.to(
                                              () =>
                                                  ServiceCenterDetailsScreen(),
                                              arguments: index);
                                        },
                                        child: Card(
                                          elevation: 7,
                                          shadowColor: Colors.grey,
                                          color: Colors.black87,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            side: BorderSide(
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
                                                  Container(
                                                    width: 200,
                                                    height: 130,
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(15),
                                                        topRight:
                                                            Radius.circular(15),
                                                      ),
                                                      child: Image.network(
                                                        'https://drive.google.com/uc?export=view&id=1WADBO26yNIOozbH-IHTXtrejFlpjWnNn',
                                                        height: 100,
                                                        width: 192,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 1,
                                                    right: 1,
                                                    child: StreamBuilder(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection('Users')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .collection(
                                                              'Favorites')
                                                          .where('sid',
                                                              isEqualTo:
                                                                  favoriteController
                                                                      .highRated[
                                                                          i]
                                                                      .id)
                                                          .snapshots(),
                                                      builder: (context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                        if (snapshot.hasData) {
                                                          return IconButton(
                                                            icon: snapshot
                                                                    .data!
                                                                    .docs
                                                                    .isEmpty
                                                                ? Icon(
                                                                    Icons
                                                                        .bookmark_border,
                                                                    color: Colors
                                                                        .black,
                                                                    size: 30,
                                                                  )
                                                                : snapshot
                                                                            .data!
                                                                            .docs
                                                                            .first['isFavorite'] ==
                                                                        true
                                                                    ? Icon(
                                                                        Icons
                                                                            .bookmark,
                                                                        color: Colors
                                                                            .redAccent
                                                                            .shade700,
                                                                        size:
                                                                            30,
                                                                      )
                                                                    : Icon(
                                                                        Icons
                                                                            .bookmark_border,
                                                                        color: Colors
                                                                            .black,
                                                                        size:
                                                                            30,
                                                                      ),
                                                            onPressed: () {
                                                              if (snapshot
                                                                  .data!
                                                                  .docs
                                                                  .isEmpty) {
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
                                                                    .doc(favoriteController
                                                                        .highRated[
                                                                            i]
                                                                        .id)
                                                                    .set({
                                                                  'sid': favoriteController
                                                                      .highRated[
                                                                          i]
                                                                      .id,
                                                                  'isFavorite':
                                                                      true,
                                                                });
                                                              } else {
                                                                if (snapshot
                                                                            .data!
                                                                            .docs
                                                                            .first[
                                                                        'isFavorite'] ==
                                                                    false) {
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
                                                                      .doc(favoriteController
                                                                          .highRated[
                                                                              i]
                                                                          .id)
                                                                      .update({
                                                                    'isFavorite':
                                                                        true,
                                                                  });
                                                                } else {
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
                                                                      .doc(favoriteController
                                                                          .highRated[
                                                                              i]
                                                                          .id)
                                                                      .update({
                                                                    'isFavorite':
                                                                        false,
                                                                  });
                                                                }
                                                              }
                                                            },
                                                          );
                                                        } else {
                                                          return CircularProgressIndicator(
                                                            color: Colors
                                                                .grey.shade400,
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 2,
                                                    left: 100 - 25,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey,
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: CircleAvatar(
                                                        radius: 25,
                                                        backgroundColor:
                                                            Colors.black,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child: Image.network(
                                                            addCarController
                                                                .brands
                                                                .firstWhere((element) =>
                                                                    element
                                                                        .name ==
                                                                    favoriteController
                                                                        .highRated[
                                                                            i]
                                                                        .brand)
                                                                .imageUrl,
                                                            height: 40,
                                                            width: 40,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: AutoSizeText(
                                                  favoriteController
                                                      .highRated[i].company,
                                                  minFontSize: 1,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: AutoSizeText(
                                                        favoriteController
                                                            .highRated[i]
                                                            .address,
                                                        minFontSize: 1,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    FittedBox(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.lightGreen,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 4,
                                                          right: 4,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            AutoSizeText(
                                                              double.parse(favoriteController
                                                                      .highRated[
                                                                          i]
                                                                      .rating)
                                                                  .toPrecision(
                                                                      1)
                                                                  .toString(),
                                                              minFontSize: 1,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.black,
                                                              size: 12,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                  ),
                                                  child: AutoSizeText(
                                                    '${favoriteController.highRated[i].city}, ${favoriteController.highRated[i].state}',
                                                    minFontSize: 1,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 10,
                                                  left: 10,
                                                ),
                                                child: Divider(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
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
                                                      flex: 5,
                                                      child: Row(
                                                        children: [
                                                          Flexible(
                                                            flex: 3,
                                                            child: AutoSizeText(
                                                              'Timing: ',
                                                              minFontSize: 1,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .lightGreenAccent
                                                                    .shade400,
                                                              ),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex: 2,
                                                            child: AutoSizeText(
                                                              '${favoriteController.highRated[i].startTime}',
                                                              maxLines: 1,
                                                              minFontSize: 1,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          AutoSizeText(
                                                            ' - ',
                                                            maxLines: 1,
                                                            minFontSize: 1,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex: 2,
                                                            child: AutoSizeText(
                                                              favoriteController
                                                                  .highRated[i]
                                                                  .endTime,
                                                              minFontSize: 1,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Flexible(
                                                      flex: 3,
                                                      child: favoriteController
                                                              .highRated[i]
                                                              .isOpen
                                                          ? Row(
                                                              children: [
                                                                Flexible(
                                                                  child:
                                                                      AutoSizeText(
                                                                    'Open',
                                                                    minFontSize:
                                                                        1,
                                                                    maxLines: 1,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .lightGreenAccent
                                                                          .shade400,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Flexible(
                                                                  child:
                                                                      AutoSizeText(
                                                                    ' now',
                                                                    minFontSize:
                                                                        1,
                                                                    maxLines: 1,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Row(
                                                              children: [
                                                                Flexible(
                                                                  child:
                                                                      AutoSizeText(
                                                                    'Currently ',
                                                                    minFontSize:
                                                                        1,
                                                                    maxLines: 1,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Flexible(
                                                                  child:
                                                                      AutoSizeText(
                                                                    'Closed',
                                                                    minFontSize:
                                                                        1,
                                                                    maxLines: 1,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .red,
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
                                    ),
                                  );
                                },
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
      ),
    );
  }
}

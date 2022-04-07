import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:karmac/models/car_details.dart';
import 'package:karmac/models/car_details_controller.dart';
import 'package:karmac/models/karmac_controller.dart';
import 'package:karmac/models/order_controller.dart';
import 'package:karmac/models/service_center.dart';
import 'package:karmac/models/user_car_controller.dart';
import 'package:lottie/lottie.dart';
import './order_details_screen.dart';
import '../widgets/app_drawer.dart';
import 'package:tabbar/tabbar.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  OrderController orderController = Get.put(OrderController());
  UserCarDetails userCarDetails = Get.put(UserCarDetails());
  CarDetailsController carDetailsController = Get.put(CarDetailsController());
  KarmacController karmacController = Get.put(KarmacController());
  RxBool isLoading = false.obs;
  final tabController = PageController();
  final dateg = AutoSizeGroup();
  RxString start = ''.obs;
  RxString end = ''.obs;
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
          'My Orders',
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
        () => Stack(
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
                    'assets/images/myorders.png',
                    fit: BoxFit.fitHeight,
                    height: height * 0.3 + 15,
                    width: width,
                  ),
                  Positioned(
                    bottom: 25,
                    left: 5,
                    child: Container(
                      width: width * 0.5,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          bottom: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Karmac monitors and tracks all your orders in one place without worrying about losing your invoices',
                              maxLines: null,
                              style: TextStyle(
                                color: Colors.grey.shade200,
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
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey.shade900,
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
                height: height * 0.7,
                width: width,
                child: isConnected.value
                    ? orderController.orders.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/empty.png',
                                  width: Get.width * 0.5,
                                  fit: BoxFit.fitWidth,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 40,
                                    right: 40,
                                    top: 30,
                                  ),
                                  child: AutoSizeText(
                                    "You haven't placed any orders yet, visit homepage to initiate your Karmac journey.",
                                    minFontSize: 1,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 16,
                                  left: 16,
                                  bottom: 5,
                                  top: 5,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: Get.width - 32,
                                      child: TabbarHeader(
                                        backgroundColor: Colors.black,
                                        indicatorColor: Colors.lightGreen,
                                        foregroundColor: Colors.grey.shade400,
                                        controller: tabController,
                                        tabs: [
                                          Tab(
                                            //height: 30,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.list,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                AutoSizeText(
                                                  'All Orders',
                                                  minFontSize: 1,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    color: Colors.grey.shade400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Tab(
                                            //height: 30,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.event,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                AutoSizeText(
                                                  'Date',
                                                  minFontSize: 1,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    color: Colors.grey.shade400,
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
                              Expanded(
                                child:
                                    orderController.isLoading.value ||
                                            carDetailsController
                                                .isLoading.value ||
                                            karmacController.isLoading.value
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.lightGreen,
                                            ),
                                          )
                                        : TabbarContent(
                                            controller: tabController,
                                            children: [
                                              ListView.builder(
                                                physics: BouncingScrollPhysics(
                                                  parent:
                                                      AlwaysScrollableScrollPhysics(),
                                                ),
                                                itemCount: orderController
                                                    .orders.length,
                                                itemBuilder: (context, i) {
                                                  ServiceCenter s = karmacController
                                                      .serviceCenters
                                                      .firstWhere((element) =>
                                                          element.id ==
                                                          orderController
                                                              .orders[i]
                                                              .serviceCentreId);
                                                  return Container(
                                                    width: Get.width,
                                                    height: 135,
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 5,
                                                      bottom: 5,
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Get.to(
                                                            () =>
                                                                OrderDetailScreen(),
                                                            arguments:
                                                                orderController
                                                                    .orders[i]
                                                                    .id);
                                                      },
                                                      child: Card(
                                                        elevation: 5,
                                                        shadowColor: Colors
                                                            .grey.shade400,
                                                        color: Color.fromRGBO(
                                                            26, 26, 26, 1),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10),
                                                              ),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: carDetailsController
                                                                            .brands
                                                                            .firstWhere((e) =>
                                                                                e.name.toUpperCase() ==
                                                                                orderController.orders[i].car.brand
                                                                                    .toUpperCase())
                                                                            .models
                                                                            .firstWhere((e) =>
                                                                                e.name.toUpperCase() ==
                                                                                orderController.orders[i].car.model
                                                                                    .toUpperCase())
                                                                            .up ==
                                                                        ''
                                                                    ? 'https://drive.google.com/uc?export=view&id=1ZTngu9nhlaucu150aU2XJ_6NMQry8xzC'
                                                                    : carDetailsController
                                                                        .brands
                                                                        .firstWhere((e) =>
                                                                            e.name.toUpperCase() ==
                                                                            orderController.orders[i].car.brand
                                                                                .toUpperCase())
                                                                        .models
                                                                        .firstWhere(
                                                                            (e) => e.name.toUpperCase() == orderController.orders[i].car.model.toUpperCase())
                                                                        .up,
                                                                fit: BoxFit
                                                                    .fitWidth,
                                                                width:
                                                                    Get.width *
                                                                        0.4,
                                                                height: 125,
                                                                placeholder:
                                                                    (context,
                                                                        val) {
                                                                  return LottieBuilder
                                                                      .asset(
                                                                    'assets/anim/bimg.json',
                                                                    fit: BoxFit
                                                                        .fitWidth,
                                                                    width:
                                                                        Get.width *
                                                                            0.4,
                                                                    height: 125,
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  left: 5,
                                                                  top: 5,
                                                                  right: 10,
                                                                  bottom: 5,
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Flexible(
                                                                          child:
                                                                              AutoSizeText(
                                                                            orderController.orders[i].car.model,
                                                                            minFontSize:
                                                                                1,
                                                                            maxLines:
                                                                                1,
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        FittedBox(
                                                                          child:
                                                                              Image.network(
                                                                            carDetailsController.brands.firstWhere((e) => e.name.toUpperCase() == orderController.orders[i].car.brand.toUpperCase()).imageUrl,
                                                                            width:
                                                                                40,
                                                                            height:
                                                                                40,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          AutoSizeText(
                                                                            'Reg No.: ${orderController.orders[i].car.number}',
                                                                            minFontSize:
                                                                                1,
                                                                            maxLines:
                                                                                1,
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.grey.shade500,
                                                                              fontSize: 10,
                                                                            ),
                                                                          ),
                                                                          AutoSizeText(
                                                                            '${s.company}, ${s.city}',
                                                                            minFontSize:
                                                                                1,
                                                                            maxLines:
                                                                                1,
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.grey.shade500,
                                                                              fontSize: 10,
                                                                            ),
                                                                          ),
                                                                          AutoSizeText(
                                                                            'Booking Slot: ${orderController.orders[i].date}  ${orderController.orders[i].time}',
                                                                            minFontSize:
                                                                                1,
                                                                            maxLines:
                                                                                1,
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.grey.shade500,
                                                                              fontSize: 10,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Column(
                                                                      children: [
                                                                        Divider(
                                                                          color: Colors
                                                                              .grey
                                                                              .shade500,
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            AutoSizeText(
                                                                              orderController.orders[i].status == '2'
                                                                                  ? 'Waiting for approval'
                                                                                  : orderController.orders[i].status == '3'
                                                                                      ? 'Order approved'
                                                                                      : orderController.orders[i].status == '1'
                                                                                          ? 'Order completed'
                                                                                          : 'Order declined',
                                                                              minFontSize: 1,
                                                                              maxLines: 1,
                                                                              style: TextStyle(
                                                                                color: orderController.orders[i].status == '2'
                                                                                    ? Colors.yellow
                                                                                    : orderController.orders[i].status == '3'
                                                                                        ? Colors.lightGreenAccent.shade400
                                                                                        : orderController.orders[i].status == '1'
                                                                                            ? Colors.green.shade600
                                                                                            : Colors.red,
                                                                                fontSize: 10,
                                                                              ),
                                                                            ),
                                                                            AutoSizeText(
                                                                              'View Details',
                                                                              minFontSize: 1,
                                                                              maxLines: 1,
                                                                              style: TextStyle(
                                                                                color: Colors.blue,
                                                                                fontSize: 10,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Flexible(
                                                                child:
                                                                    AutoSizeText(
                                                                  'Start date: ',
                                                                  group: dateg,
                                                                  minFontSize:
                                                                      1,
                                                                  maxLines: 1,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400,
                                                                  ),
                                                                ),
                                                              ),
                                                              Flexible(
                                                                child: InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    var date = await showDatePicker(
                                                                        context:
                                                                            context,
                                                                        initialDate: DateTime
                                                                            .now(),
                                                                        firstDate: DateTime.now().subtract(Duration(
                                                                            days:
                                                                                700)),
                                                                        lastDate:
                                                                            DateTime.now().add(Duration(days: 30)));
                                                                    if (date !=
                                                                        null) {
                                                                      start
                                                                          .value = DateFormat(
                                                                              'yyyy-MM-dd')
                                                                          .format(
                                                                              date);
                                                                      if (start.value !=
                                                                              '' &&
                                                                          end.value !=
                                                                              '') {
                                                                        await orderController.filterOrders(
                                                                            start.value,
                                                                            end.value);
                                                                      }
                                                                    }
                                                                  },
                                                                  child:
                                                                      AutoSizeText(
                                                                    start.value ==
                                                                            ''
                                                                        ? 'choose date'
                                                                        : start
                                                                            .value,
                                                                    group:
                                                                        dateg,
                                                                    minFontSize:
                                                                        1,
                                                                    maxLines: 1,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .lightGreen,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 40,
                                                        ),
                                                        Flexible(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Flexible(
                                                                child:
                                                                    AutoSizeText(
                                                                  'End date: ',
                                                                  group: dateg,
                                                                  minFontSize:
                                                                      1,
                                                                  maxLines: 1,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400,
                                                                  ),
                                                                ),
                                                              ),
                                                              Flexible(
                                                                child: InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    var date = await showDatePicker(
                                                                        context:
                                                                            context,
                                                                        initialDate: DateTime
                                                                            .now(),
                                                                        firstDate: DateTime.now().subtract(Duration(
                                                                            days:
                                                                                700)),
                                                                        lastDate:
                                                                            DateTime.now().add(Duration(days: 30)));
                                                                    if (date !=
                                                                        null) {
                                                                      end.value = DateFormat(
                                                                              'yyyy-MM-dd')
                                                                          .format(
                                                                              date);
                                                                      if (start.value !=
                                                                              '' &&
                                                                          end.value !=
                                                                              '') {
                                                                        await orderController.filterOrders(
                                                                            start.value,
                                                                            end.value);
                                                                      }
                                                                    }
                                                                  },
                                                                  child:
                                                                      AutoSizeText(
                                                                    end.value ==
                                                                            ''
                                                                        ? 'choose date'
                                                                        : end
                                                                            .value,
                                                                    group:
                                                                        dateg,
                                                                    minFontSize:
                                                                        1,
                                                                    maxLines: 1,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .lightGreen,
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
                                                  /*Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8,
                                        right: 8,
                                        bottom: 4,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.lightGreen,
                                            ),
                                            onPressed: () async {
                                              if (start.value != '' &&
                                                  end.value != '') {
                                                await orderController
                                                    .filterOrders(
                                                        start.value, end.value);
                                              }
                                            },
                                            child: AutoSizeText(
                                              'save',
                                              minFontSize: 1,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.grey.shade800,
                                            ),
                                            onPressed: () {
                                              start.value = '';
                                              end.value = '';
                                              orderController.dateFilter.value =
                                                  [];
                                            },
                                            child: AutoSizeText(
                                              'reset',
                                              minFontSize: 1,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Colors.grey.shade400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),*/
                                                  Expanded(
                                                    child:
                                                        orderController
                                                                .isLoading1
                                                                .value
                                                            ? Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: Colors
                                                                      .lightGreen,
                                                                ),
                                                              )
                                                            : ListView.builder(
                                                                physics:
                                                                    BouncingScrollPhysics(
                                                                  parent:
                                                                      AlwaysScrollableScrollPhysics(),
                                                                ),
                                                                itemCount:
                                                                    orderController
                                                                        .dateFilter
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        i) {
                                                                  ServiceCenter s = karmacController
                                                                      .serviceCenters
                                                                      .firstWhere((element) =>
                                                                          element
                                                                              .id ==
                                                                          orderController
                                                                              .dateFilter[i]
                                                                              .serviceCentreId);
                                                                  return Container(
                                                                    width: Get
                                                                        .width,
                                                                    height: 135,
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      top: 5,
                                                                      bottom: 5,
                                                                    ),
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Get.to(
                                                                            () =>
                                                                                OrderDetailScreen(),
                                                                            arguments:
                                                                                orderController.dateFilter[i].id);
                                                                      },
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            5,
                                                                        shadowColor: Colors
                                                                            .grey
                                                                            .shade400,
                                                                        color: Color.fromRGBO(
                                                                            26,
                                                                            26,
                                                                            26,
                                                                            1),
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            ClipRRect(
                                                                              borderRadius: BorderRadius.only(
                                                                                topLeft: Radius.circular(10),
                                                                                bottomLeft: Radius.circular(10),
                                                                              ),
                                                                              child: CachedNetworkImage(
                                                                                imageUrl: carDetailsController.brands.firstWhere((e) => e.name.toUpperCase() == orderController.dateFilter[i].car.brand.toUpperCase()).models.firstWhere((e) => e.name.toUpperCase() == orderController.dateFilter[i].car.model.toUpperCase()).up == '' ? 'https://drive.google.com/uc?export=view&id=1ZTngu9nhlaucu150aU2XJ_6NMQry8xzC' : carDetailsController.brands.firstWhere((e) => e.name.toUpperCase() == orderController.dateFilter[i].car.brand.toUpperCase()).models.firstWhere((e) => e.name.toUpperCase() == orderController.dateFilter[i].car.model.toUpperCase()).up,
                                                                                fit: BoxFit.fitWidth,
                                                                                width: Get.width * 0.4,
                                                                                height: 125,
                                                                                placeholder: (context, val) {
                                                                                  return LottieBuilder.asset(
                                                                                    'assets/anim/bimg.json',
                                                                                    fit: BoxFit.fitWidth,
                                                                                    width: Get.width * 0.4,
                                                                                    height: 125,
                                                                                  );
                                                                                },
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(
                                                                                  left: 5,
                                                                                  top: 5,
                                                                                  right: 10,
                                                                                  bottom: 5,
                                                                                ),
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Flexible(
                                                                                          child: AutoSizeText(
                                                                                            orderController.dateFilter[i].car.model,
                                                                                            minFontSize: 1,
                                                                                            maxLines: 1,
                                                                                            style: TextStyle(
                                                                                              color: Colors.white,
                                                                                              fontWeight: FontWeight.bold,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          width: 10,
                                                                                        ),
                                                                                        FittedBox(
                                                                                          child: Image.network(
                                                                                            carDetailsController.brands.firstWhere((e) => e.name.toUpperCase() == orderController.dateFilter[i].car.brand.toUpperCase()).imageUrl,
                                                                                            width: 40,
                                                                                            height: 40,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        children: [
                                                                                          AutoSizeText(
                                                                                            'Reg No.: ${orderController.dateFilter[i].car.number}',
                                                                                            minFontSize: 1,
                                                                                            maxLines: 1,
                                                                                            style: TextStyle(
                                                                                              color: Colors.grey.shade500,
                                                                                              fontSize: 10,
                                                                                            ),
                                                                                          ),
                                                                                          AutoSizeText(
                                                                                            '${s.company}, ${s.city}',
                                                                                            minFontSize: 1,
                                                                                            maxLines: 1,
                                                                                            style: TextStyle(
                                                                                              color: Colors.grey.shade500,
                                                                                              fontSize: 10,
                                                                                            ),
                                                                                          ),
                                                                                          AutoSizeText(
                                                                                            'Booking Slot: ${orderController.dateFilter[i].date}  ${orderController.dateFilter[i].time}',
                                                                                            minFontSize: 1,
                                                                                            maxLines: 1,
                                                                                            style: TextStyle(
                                                                                              color: Colors.grey.shade500,
                                                                                              fontSize: 10,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Column(
                                                                                      children: [
                                                                                        Divider(
                                                                                          color: Colors.grey.shade500,
                                                                                          height: 10,
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            AutoSizeText(
                                                                                              orderController.dateFilter[i].status == '2'
                                                                                                  ? 'Waiting for approval'
                                                                                                  : orderController.dateFilter[i].status == '3'
                                                                                                      ? 'Order approved'
                                                                                                      : orderController.dateFilter[i].status == '1'
                                                                                                          ? 'Order completed'
                                                                                                          : 'Order declined',
                                                                                              minFontSize: 1,
                                                                                              maxLines: 1,
                                                                                              style: TextStyle(
                                                                                                color: orderController.dateFilter[i].status == '2'
                                                                                                    ? Colors.yellow
                                                                                                    : orderController.dateFilter[i].status == '3'
                                                                                                        ? Colors.lightGreenAccent.shade400
                                                                                                        : orderController.dateFilter[i].status == '1'
                                                                                                            ? Colors.green.shade600
                                                                                                            : Colors.red,
                                                                                                fontSize: 10,
                                                                                              ),
                                                                                            ),
                                                                                            AutoSizeText(
                                                                                              'View Details',
                                                                                              minFontSize: 1,
                                                                                              maxLines: 1,
                                                                                              style: TextStyle(
                                                                                                color: Colors.blue,
                                                                                                fontSize: 10,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                  ),
                                                ],
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

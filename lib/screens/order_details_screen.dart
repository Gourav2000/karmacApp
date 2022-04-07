import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:karmac/models/car_details.dart';
import 'package:karmac/models/car_details_controller.dart';
import 'package:karmac/models/karmac_controller.dart';
import 'package:karmac/models/order_controller.dart';
import 'package:karmac/models/review_controller.dart';
import 'package:karmac/models/service_center.dart';
import 'package:karmac/models/user_car_controller.dart';
import 'package:karmac/screens/add_review_screen.dart';
import 'package:karmac/screens/order_info_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:ntp/ntp.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderDetailScreen extends StatefulWidget {
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderController orderController = Get.put(OrderController());
  KarmacController karmacController = Get.put(KarmacController());
  UserCarDetails userCarDetails = Get.put(UserCarDetails());
  CarDetailsController carDetailsController = Get.put(CarDetailsController());
  late ReviewController reviewController;
  String id = Get.arguments;
  late ServiceCenter s;
  late DateTime date;
  late DateTime response;
  RxBool popShown = false.obs;

  @override
  void initState() {
    super.initState();
    reviewController = Get.put(ReviewController(
        orderController.orders.firstWhere((e) => e.id == id).serviceCentreId));

    s = karmacController.serviceCenters.firstWhere((element) =>
        element.id ==
        orderController.orders.firstWhere((e) => e.id == id).serviceCentreId);
    date = DateTime.parse(
        orderController.orders.firstWhere((e) => e.id == id).created);
    //response = DateTime.parse(orderController.orders[i].response);
  }

  void showReviewPopUp() async {
    if (orderController.orders.firstWhere((e) => e.id == id).status == '1' &&
        reviewController.reviews
                .where((e) => e.orderId == id)
                .toList()
                .length ==
            0) {
      if (popShown.value) {
        return;
      } else {
        popShown.value = true;
        if (orderController.orders
            .firstWhere((e) => e.id == id)
            .showReviewPopUp) {
          Get.defaultDialog(
            radius: 5,
            backgroundColor: Colors.grey,
            title: 'Rate Your Service',
            content: Material(
              color: Colors.transparent,
              child: Container(
                width: Get.width * 0.7,
                height: 154,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        top: 8,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          'Share your',
                          minFontSize: 1,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          'Service Experience',
                          minFontSize: 1,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        top: 10,
                      ),
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          Get.to(
                            () => AddReviewScreen(),
                            arguments: {
                              'sId': s.id,
                              'orderId': id,
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                'Rate your service and write a review',
                                minFontSize: 1,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.lightGreenAccent.shade400,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        bottom: 20,
                      ),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: AutoSizeText(
                              'Remind me later',
                              minFontSize: 1,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          InkWell(
                            onTap: () async {
                              await FirebaseFirestore.instanceFor(
                                      app: Firebase.app('business'))
                                  .collection('Orders')
                                  .doc(id)
                                  .update({'showReviewPopUp': false});
                              Get.back();
                            },
                            child: AutoSizeText(
                              'Don\'t show again',
                              minFontSize: 1,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
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
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => showReviewPopUp());
    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 26, 26, 1),
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
      ),
      body: Obx(
        () => orderController.isLoading.value ||
                karmacController.isLoading.value ||
                userCarDetails.isLoading.value ||
                carDetailsController.isLoading.value ||
                reviewController.isLoading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.lightGreen,
                ),
              )
            : ListView(
                children: [
                  Container(
                    height: Get.width * 9 / 16,
                    width: Get.width,
                    color: Colors.white,
                    child: CachedNetworkImage(
                      imageUrl: carDetailsController.brands
                                  .firstWhere((e) =>
                                      e.name.toUpperCase() ==
                                      orderController.orders
                                          .firstWhere((e) => e.id == id)
                                          .car
                                          .brand
                                          .toUpperCase())
                                  .models
                                  .firstWhere((e) =>
                                      e.name.toUpperCase() ==
                                      orderController.orders
                                          .firstWhere((e) => e.id == id)
                                          .car
                                          .model
                                          .toUpperCase())
                                  .up ==
                              ''
                          ? 'https://drive.google.com/uc?export=view&id=1ZTngu9nhlaucu150aU2XJ_6NMQry8xzC'
                          : carDetailsController.brands
                              .firstWhere((e) =>
                                  e.name.toUpperCase() ==
                                  orderController.orders
                                      .firstWhere((e) => e.id == id)
                                      .car
                                      .brand
                                      .toUpperCase())
                              .models
                              .firstWhere((e) =>
                                  e.name.toUpperCase() ==
                                  orderController.orders
                                      .firstWhere((e) => e.id == id)
                                      .car
                                      .model
                                      .toUpperCase())
                              .up,
                      width: Get.width,
                      height: Get.width * 9 / 16,
                      placeholder: (context, val) {
                        return LottieBuilder.asset(
                          'assets/anim/bimg.json',
                          fit: BoxFit.contain,
                          width: Get.width,
                          height: Get.width * 9 / 16,
                        );
                      },
                    ),
                  ),
                  Material(
                    shadowColor: Colors.white,
                    elevation: 5,
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                              top: 10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FittedBox(
                                  child: Image.network(
                                    carDetailsController.brands
                                        .firstWhere((e) =>
                                            e.name.toUpperCase() ==
                                            s.brand.toUpperCase())
                                        .imageUrl,
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: AutoSizeText(
                                    '${s.company}, ${s.city}',
                                    minFontSize: 1,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                              top: 5,
                            ),
                            child: AutoSizeText(
                              s.address,
                              minFontSize: 1,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                              top: 15,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AutoSizeText(
                                  'Order ID: ${id}',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.grey.shade200,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                  onTap: () async {
                                    await Clipboard.setData(
                                      ClipboardData(
                                        text: id,
                                      ),
                                    );
                                    Fluttertoast.showToast(
                                      context,
                                      msg: 'Copied to clipboard!',
                                      toastDuration: 2,
                                    );
                                  },
                                  child: Icon(
                                    Icons.copy,
                                    color: Colors.grey.shade400,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                              top: 15,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  carDetailsController.brands
                                      .firstWhere((e) =>
                                          e.name ==
                                          orderController.orders
                                              .firstWhere((e) => e.id == id)
                                              .car
                                              .brand)
                                      .imageUrl,
                                  height: 40,
                                  width: 40,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: AutoSizeText(
                                    orderController.orders
                                        .firstWhere((e) => e.id == id)
                                        .car
                                        .model,
                                    minFontSize: 1,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                    ),
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
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 4,
                              bottom: 4,
                              left: 8,
                              right: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade900,
                                    ),
                                    padding: const EdgeInsets.only(
                                      top: 8,
                                      bottom: 8,
                                      left: 5,
                                      right: 5,
                                    ),
                                    child: AutoSizeText(
                                      orderController.orders
                                          .firstWhere((e) => e.id == id)
                                          .car
                                          .variant,
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
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade900,
                                    ),
                                    padding: const EdgeInsets.only(
                                      top: 8,
                                      bottom: 8,
                                      left: 5,
                                      right: 5,
                                    ),
                                    child: AutoSizeText(
                                      orderController.orders
                                          .firstWhere((e) => e.id == id)
                                          .car
                                          .color,
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
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade900,
                                    ),
                                    padding: const EdgeInsets.only(
                                      top: 8,
                                      bottom: 8,
                                      left: 5,
                                      right: 5,
                                    ),
                                    child: AutoSizeText(
                                      orderController.orders
                                          .firstWhere((e) => e.id == id)
                                          .car
                                          .number,
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
                                      borderRadius: BorderRadius.circular(10),
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
                                      orderController.orders
                                          .firstWhere((e) => e.id == id)
                                          .car
                                          .type,
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
                              left: 8,
                              right: 8,
                            ),
                            child: Divider(
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                              bottom: 15,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: AutoSizeText(
                                    orderController.orders
                                                .firstWhere((e) => e.id == id)
                                                .status ==
                                            '2'
                                        ? 'Waiting for approval'
                                        : orderController.orders
                                                    .firstWhere(
                                                        (e) => e.id == id)
                                                    .status ==
                                                '3'
                                            ? 'Order approved'
                                            : orderController.orders
                                                        .firstWhere(
                                                            (e) => e.id == id)
                                                        .status ==
                                                    '1'
                                                ? 'Order completed'
                                                : 'Order declined',
                                    minFontSize: 1,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: orderController.orders
                                                  .firstWhere((e) => e.id == id)
                                                  .status ==
                                              '2'
                                          ? Colors.yellow
                                          : orderController.orders
                                                      .firstWhere(
                                                          (e) => e.id == id)
                                                      .status ==
                                                  '3'
                                              ? Colors.lightGreenAccent.shade400
                                              : orderController.orders
                                                          .firstWhere(
                                                              (e) => e.id == id)
                                                          .status ==
                                                      '1'
                                                  ? Colors.green.shade600
                                                  : Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: AutoSizeText(
                                    orderController.orders
                                                .firstWhere((e) => e.id == id)
                                                .status ==
                                            '2'
                                        ? 'created at ${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}'
                                        : 'approved at ${orderController.orders.firstWhere((e) => e.id == id).response}',
                                    //'approved at ${response.day}/${response.month}/${response.year} ${response.hour}:${response.minute}',
                                    minFontSize: 1,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 14,
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
                  SizedBox(
                    height: 20,
                  ),
                  Material(
                    shadowColor: Colors.white,
                    elevation: 5,
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                              top: 15,
                            ),
                            child: AutoSizeText(
                              'Your Service Details',
                              minFontSize: 1,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.grey.shade200,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                              bottom: 8,
                              top: 25,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors
                                                  .lightGreenAccent.shade400,
                                              width: 2,
                                            ),
                                          ),
                                          child: AutoSizeText(
                                            'Check IN',
                                            minFontSize: 1,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: AutoSizeText(
                                          orderController.orders
                                                      .firstWhere(
                                                          (e) => e.id == id)
                                                      .checkInDate ==
                                                  ''
                                              ? 'Waiting'
                                              : '${orderController.orders.firstWhere((e) => e.id == id).checkInDate} ${orderController.orders.firstWhere((e) => e.id == id).checkInTime}',
                                          minFontSize: 1,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Flexible(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.red,
                                              width: 2,
                                            ),
                                          ),
                                          child: AutoSizeText(
                                            'Check OUT',
                                            minFontSize: 1,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: AutoSizeText(
                                          orderController.orders
                                                      .firstWhere(
                                                          (e) => e.id == id)
                                                      .checkOutDate ==
                                                  ''
                                              ? 'Waiting'
                                              : '${orderController.orders.firstWhere((e) => e.id == id).checkOutDate} ${orderController.orders.firstWhere((e) => e.id == id).checkOutTime}',
                                          minFontSize: 1,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                              bottom: 8,
                              top: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        child: AutoSizeText(
                                          'Payment Status: ',
                                          minFontSize: 1,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: orderController.orders
                                                    .firstWhere(
                                                        (e) => e.id == id)
                                                    .paymentDone
                                                ? Colors.lightGreen
                                                : Colors.yellow,
                                          ),
                                          child: AutoSizeText(
                                            orderController.orders
                                                    .firstWhere(
                                                        (e) => e.id == id)
                                                    .paymentDone
                                                ? 'Paid'
                                                : 'Order Active',
                                            minFontSize: 1,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Flexible(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        child: AutoSizeText(
                                          'Service Invoice: ',
                                          minFontSize: 1,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {},
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Flexible(
                                                flex: 1,
                                                child: FittedBox(
                                                  child: Icon(
                                                    Icons.download,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Flexible(
                                                flex: 3,
                                                child: AutoSizeText(
                                                  'Download',
                                                  minFontSize: 1,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
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
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                            ),
                            child: InkWell(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Expanded(
                                    child: AutoSizeText(
                                      'View Service Details and Invoice',
                                      minFontSize: 1,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.lightGreen,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                              bottom: 10,
                            ),
                            child: Divider(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Material(
                    shadowColor: Colors.white,
                    elevation: 5,
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                              top: 15,
                            ),
                            child: AutoSizeText(
                              'Order Info',
                              minFontSize: 1,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.grey.shade200,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                              bottom: 15,
                              top: 25,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: AutoSizeText(
                                          'Selected Date: ',
                                          minFontSize: 1,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.grey.shade900,
                                          ),
                                          child: AutoSizeText(
                                            orderController.orders
                                                .firstWhere((e) => e.id == id)
                                                .date,
                                            minFontSize: 1,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Flexible(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: AutoSizeText(
                                          'Selected Slot: ',
                                          minFontSize: 1,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.grey.shade900,
                                          ),
                                          child: Column(
                                            children: [
                                              AutoSizeText(
                                                orderController.orders
                                                    .firstWhere(
                                                        (e) => e.id == id)
                                                    .time
                                                    .split(' ')[0],
                                                minFontSize: 1,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: Colors.lightGreenAccent
                                                      .shade400,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              AutoSizeText(
                                                orderController.orders
                                                    .firstWhere(
                                                        (e) => e.id == id)
                                                    .time
                                                    .split(' ')[1],
                                                minFontSize: 1,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
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
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                            ),
                            child: InkWell(
                              onTap: () {
                                Get.to(
                                  () => OrderInfoScreen(),
                                  arguments: id,
                                );
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: AutoSizeText(
                                      'View Order Specifications',
                                      minFontSize: 1,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.lightGreen,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                              bottom: 10,
                            ),
                            child: Divider(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  orderController.orders.firstWhere((e) => e.id == id).status !=
                          '1'
                      ? Container()
                      : SizedBox(
                          height: 20,
                        ),
                  orderController.orders.firstWhere((e) => e.id == id).status !=
                          '1'
                      ? Container()
                      : Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: Colors.black,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                  top: 15,
                                ),
                                child: AutoSizeText(
                                  'How\'s your experience ?',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.grey.shade200,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              reviewController.reviews
                                          .where((e) => e.orderId == id)
                                          .toList()
                                          .length ==
                                      0
                                  ? Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            top: 35,
                                          ),
                                          child: Divider(
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              Get.to(
                                                () => AddReviewScreen(),
                                                arguments: {
                                                  'sId': s.id,
                                                  'orderId': id,
                                                },
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: AutoSizeText(
                                                    'Rate your service and write a review',
                                                    minFontSize: 1,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 25,
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.lightGreen,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            bottom: 10,
                                          ),
                                          child: Divider(
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                            ),
                                            child: AutoSizeText(
                                              'Your review',
                                              minFontSize: 1,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Colors.grey.shade200,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 15,
                                                backgroundImage: NetworkImage(
                                                  'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
                                                ),
                                                foregroundImage: NetworkImage(
                                                    reviewController
                                                                .reviews
                                                                .firstWhere((e) =>
                                                                    e.orderId ==
                                                                    id)
                                                                .image !=
                                                            ''
                                                        ? reviewController
                                                            .reviews
                                                            .firstWhere((e) =>
                                                                e.orderId == id)
                                                            .image
                                                        : 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'),
                                                backgroundColor:
                                                    Colors.grey.shade400,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              AutoSizeText(
                                                reviewController.reviews
                                                    .firstWhere(
                                                        (e) => e.orderId == id)
                                                    .name,
                                                minFontSize: 1,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Row(
                                            children: [
                                              Stack(
                                                children: [
                                                  RatingBarIndicator(
                                                    rating: 5,
                                                    itemBuilder:
                                                        (context, index) =>
                                                            Icon(
                                                      Icons
                                                          .star_border_outlined,
                                                      color: Colors.lightGreen,
                                                    ),
                                                    itemCount: 5,
                                                    itemSize: 15,
                                                    direction: Axis.horizontal,
                                                  ),
                                                  RatingBarIndicator(
                                                    rating: reviewController
                                                        .reviews
                                                        .firstWhere((e) =>
                                                            e.orderId == id)
                                                        .rating,
                                                    itemBuilder:
                                                        (context, index) =>
                                                            Icon(
                                                      Icons.star,
                                                      color: Colors
                                                          .lightGreenAccent
                                                          .shade400,
                                                    ),
                                                    itemCount: 5,
                                                    itemSize: 15,
                                                    direction: Axis.horizontal,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              AutoSizeText(
                                                '${reviewController.reviews.firstWhere((e) => e.orderId == id).date.toDate().day}/${reviewController.reviews.firstWhere((e) => e.orderId == id).date.toDate().month}/${reviewController.reviews.firstWhere((e) => e.orderId == id).date.toDate().year}',
                                                minFontSize: 1,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: Colors.grey.shade500,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          reviewController.reviews
                                                      .firstWhere((e) =>
                                                          e.orderId == id)
                                                      .service ==
                                                  ''
                                              ? Container()
                                              : Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    AutoSizeText(
                                                      '${reviewController.reviews.firstWhere((e) => e.orderId == id).service} service',
                                                      minFontSize: 1,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          reviewController.reviews
                                                      .firstWhere((e) =>
                                                          e.orderId == id)
                                                      .title ==
                                                  ''
                                              ? Container()
                                              : Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    AutoSizeText(
                                                      reviewController.reviews
                                                          .firstWhere((e) =>
                                                              e.orderId == id)
                                                          .title,
                                                      minFontSize: 1,
                                                      maxLines: null,
                                                      style: TextStyle(
                                                        color: Colors
                                                            .grey.shade400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          reviewController.reviews
                                                      .firstWhere((e) =>
                                                          e.orderId == id)
                                                      .desc ==
                                                  ''
                                              ? Container()
                                              : Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    AutoSizeText(
                                                      reviewController.reviews
                                                          .firstWhere((e) =>
                                                              e.orderId == id)
                                                          .desc,
                                                      minFontSize: 1,
                                                      maxLines: null,
                                                      style: TextStyle(
                                                        color: Colors
                                                            .grey.shade400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          SizedBox(
                                            height: 4,
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
    );
  }
}

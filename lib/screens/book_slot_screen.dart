import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:karmac/auth.config.dart';
import 'package:karmac/models/address.dart';
import 'package:karmac/models/service_details_controller.dart';
import 'package:karmac/models/slot.dart';
import 'package:karmac/models/user_address_controller.dart';
import 'package:karmac/screens/select_address.dart';
import '../models/book_controller.dart';
import 'package:lottie/lottie.dart';
import './manage_car_screen.dart';
import '../models/karmac_controller.dart';
import '../models/user_car_controller.dart';
import '../models/car_details_controller.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:email_auth/email_auth.dart';

class BookSlotScreen extends StatefulWidget {
  @override
  _BookSlotScreenState createState() => _BookSlotScreenState();
}

class _BookSlotScreenState extends State<BookSlotScreen> {
  KarmacController karmacController = Get.put(KarmacController());
  UserCarDetails userCarDetails = Get.put(UserCarDetails());
  CarDetailsController carDetailsController = Get.put(CarDetailsController());
  UserAddressController userAddressController =
      Get.put(UserAddressController());
  late BookController bookController;
  ServiceDetailsController serviceDetailsController =
      Get.put(ServiceDetailsController());
  var i = Get.arguments['index'];
  var index = 0.obs;
  var index1 = (-1).obs;
  RxBool isOpen = false.obs;
  RxBool isLoading = false.obs;
  var api = dotenv.env['GOOGLE_API_KEY'].toString();
  late EmailAuth emailAuth;
  RxString addressId = ''.obs;

  @override
  void initState() {
    super.initState();
    bookController = Get.put(BookController(sid: Get.arguments['id']));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.lightGreen,
        ),
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: Text(
          'BOOK A SLOT',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Container(
            width: width,
            height: height,
            child: karmacController.isLoading.value ||
                    carDetailsController.isLoading.value ||
                    userCarDetails.isLoading.value ||
                    bookController.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.lightGreen,
                    ),
                  )
                : ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          right: 8,
                          left: 8,
                          top: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                karmacController.serviceCenters[i].company,
                                minFontSize: 1,
                                maxLines: 2,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            Image.network(
                              carDetailsController.brands
                                  .firstWhere((e) =>
                                      e.name.toUpperCase() ==
                                      karmacController.serviceCenters[i].brand
                                          .toUpperCase())
                                  .imageUrl,
                              height: 40,
                              width: 40,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          right: 8,
                          left: 8,
                          top: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              karmacController.serviceCenters[i].address,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.lightGreen,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              padding: const EdgeInsets.only(
                                left: 4,
                                right: 4,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    double.parse(karmacController
                                            .serviceCenters[i].rating)
                                        .toPrecision(1)
                                        .toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.black,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${karmacController.serviceCenters[i].city}, ',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              karmacController.serviceCenters[i].state,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 8,
                          left: 8,
                          top: 20,
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
                              'Select Your Car',
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
                          bottom: 4,
                        ),
                        child: Divider(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Container(
                        width: width,
                        height: 300,
                        child: isLoading.value
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Colors.lightGreen,
                                ),
                              )
                            : userCarDetails.cars.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 150,
                                          child: OverflowBox(
                                            minHeight: 300,
                                            maxHeight: 300,
                                            minWidth: 300,
                                            maxWidth: 300,
                                            child: LottieBuilder.asset(
                                              'assets/anim/car.json',
                                            ),
                                          ),
                                        ),
                                        AutoSizeText(
                                          'You don\'t have any cars in your collection',
                                          minFontSize: 1,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.lightGreen,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 5,
                                                bottom: 5,
                                              ),
                                              child: Text(
                                                'Add Car',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                ),
                                              )),
                                          onPressed: () {
                                            isLoading.value = true;
                                            Get.to(() => ManageCarScreen())
                                                ?.then((value) {
                                              index.value = 0;
                                              isLoading.value = false;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                : Swiper(
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
                                                padding: const EdgeInsets.only(
                                                  top: 8,
                                                ),
                                                child: CachedNetworkImage(
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
                                                              .up ==
                                                          ''
                                                      ? 'https://drive.google.com/uc?export=view&id=1ZTngu9nhlaucu150aU2XJ_6NMQry8xzC'
                                                      : carDetailsController.brands
                                                          .firstWhere((e) =>
                                                              e.name.toUpperCase() ==
                                                              userCarDetails
                                                                  .cars[i].brand
                                                                  .toUpperCase())
                                                          .models
                                                          .firstWhere(
                                                              (e) => e.name.toUpperCase() == userCarDetails.cars[i].model.toUpperCase())
                                                          .up,
                                                  width: (Get.width * 0.5) - 4,
                                                  height: 140,
                                                  placeholder: (context, val) {
                                                    return Center(
                                                      child:
                                                          LottieBuilder.asset(
                                                        'assets/anim/bimg.json',
                                                        fit: BoxFit.contain,
                                                        width:
                                                            (Get.width * 0.5) -
                                                                4,
                                                        height: 140,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 8,
                                                    ),
                                                    child: Image.network(
                                                      carDetailsController
                                                          .brands
                                                          .firstWhere((e) =>
                                                              e.name
                                                                  .toUpperCase() ==
                                                              userCarDetails
                                                                  .cars[i].brand
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
                                                        const EdgeInsets.only(
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
                                              padding: const EdgeInsets.all(4),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors
                                                            .grey.shade900,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 4,
                                                        bottom: 4,
                                                        left: 4,
                                                        right: 4,
                                                      ),
                                                      child: AutoSizeText(
                                                        userCarDetails
                                                            .cars[i].variant,
                                                        minFontSize: 1,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          color: Colors
                                                              .grey.shade400,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.black,
                                                      border: Border.all(
                                                        width: 2,
                                                        color: Colors
                                                            .blue.shade900,
                                                      ),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(4),
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
                                              padding: const EdgeInsets.all(4),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors
                                                            .grey.shade900,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.only(
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
                                                          color: Colors
                                                              .grey.shade400,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
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
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors
                                                            .grey.shade900,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.only(
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
                                                          color: Colors
                                                              .grey.shade400,
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
                      /*Padding(
                  padding: const EdgeInsets.only(
                    right: 8,
                    left: 8,
                    top: 25,
                  ),
                  child: InkWell(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 30)),
                      ).then((value) {
                        if (value != null) {
                          selectedDate.value = value.toIso8601String();
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 15,
                        bottom: 15,
                        right: 20,
                        left: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            color: Colors.lightGreen,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            selectedDate.value == ''
                                ? 'Select Date'
                                : '${DateTime.parse(selectedDate.value).day}/${DateTime.parse(selectedDate.value).month}/${DateTime.parse(selectedDate.value).year}',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),*/
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 8,
                          left: 8,
                          top: 30,
                        ),
                        child: InkWell(
                          onTap: () {
                            isOpen.value = !isOpen.value;
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                              top: 15,
                              bottom: 15,
                              right: 20,
                              left: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.timer,
                                  color: Colors.lightGreen,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: AutoSizeText(
                                    bookController.selectedDate.value != '' &&
                                            bookController.slot.value != ''
                                        ? '${bookController.selectedDate.value}, ${bookController.slot.value}'
                                        : 'Select Time Slot',
                                    minFontSize: 1,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Icon(
                                  isOpen.value == false
                                      ? Icons.expand_more
                                      : Icons.expand_less,
                                  color: Colors.grey.shade400,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      isOpen.value == false
                          ? Container()
                          : Container(
                              padding: const EdgeInsets.only(
                                top: 16,
                                right: 8,
                                left: 8,
                                bottom: 8,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: Get.width - 16,
                                    height: 40,
                                    child: ListView.builder(
                                      itemCount: bookController.slots.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, i) {
                                        var cd = DateTime.parse(
                                            bookController.slots[i].date);
                                        var currentDate = DateTime.now();
                                        var date =
                                            currentDate.add(Duration(days: i));
                                        var d = DateFormat('dd MMMM yyyy')
                                            .format(cd);
                                        return Padding(
                                          padding: i == 0
                                              ? const EdgeInsets.only(
                                                  left: 0,
                                                  right: 8,
                                                )
                                              : i == 29
                                                  ? const EdgeInsets.only(
                                                      left: 8,
                                                      right: 0,
                                                    )
                                                  : const EdgeInsets.only(
                                                      left: 8,
                                                      right: 8,
                                                    ),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                index1.value = i;
                                                bookController
                                                        .selectedDate.value =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(cd);
                                                bookController.slot.value = '';
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                border: index1.value == i
                                                    ? Border.all(
                                                        width: 2,
                                                        color: Color.fromRGBO(
                                                            0, 0, 255, 1),
                                                      )
                                                    : Border.all(
                                                        width: 2,
                                                        color: Colors
                                                            .grey.shade700,
                                                      ),
                                              ),
                                              child: Text(
                                                d,
                                                style: TextStyle(
                                                  color: Colors.grey.shade400,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  index1.value != -1
                                      ? SizedBox(
                                          height: 15,
                                        )
                                      : Container(),
                                  index1.value != -1
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            AutoSizeText(
                                              'Morning',
                                              minFontSize: 1,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Colors.grey.shade200,
                                                fontSize: 18,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              height: 52,
                                              width: Get.width - 16,
                                              child: ListView.builder(
                                                itemCount: bookController
                                                    .slots[index1.value]
                                                    .morning
                                                    .length
                                                /*bookController
                                                        .slots
                                                        .firstWhere((element) =>
                                                            element.date ==
                                                            bookController
                                                                .selectedDate
                                                                .value)
                                                        .morning
                                                        .length*/
                                                ,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, i) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 4,
                                                      right: 4,
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            if (bookController
                                                                        .slots[index1
                                                                            .value]
                                                                        .morning[i]
                                                                    [
                                                                    'Maxcarcount'] !=
                                                                bookController
                                                                        .slots[index1
                                                                            .value]
                                                                        .morning[i]
                                                                    [
                                                                    'NoOfCarsBooked']) {
                                                              setState(() {
                                                                if (bookController
                                                                        .slot
                                                                        .value ==
                                                                    'Morning ${bookController.slots[index1.value].morning[i]['Timings']}') {
                                                                  bookController
                                                                      .slot
                                                                      .value = '';
                                                                } else {
                                                                  bookController
                                                                          .slot
                                                                          .value =
                                                                      'Morning ${bookController.slots[index1.value].morning[i]['Timings']}';
                                                                }
                                                              });
                                                            }
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              left: 8,
                                                              right: 8,
                                                              top: 4,
                                                              bottom: 4,
                                                            ),
                                                            alignment: Alignment
                                                                .center,
                                                            width:
                                                                Get.width * 0.2,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: bookController
                                                                              .slots[index1.value].morning[i]
                                                                          [
                                                                          'Maxcarcount'] ==
                                                                      bookController
                                                                              .slots[index1.value].morning[i]
                                                                          [
                                                                          'NoOfCarsBooked']
                                                                  ? Colors.red
                                                                  : i % 2 != 0
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .yellow,
                                                              boxShadow: bookController
                                                                          .slot
                                                                          .value ==
                                                                      'Morning ${bookController.slots[index1.value].morning[i]['Timings']}'
                                                                  ? [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .white,
                                                                        blurRadius:
                                                                            5,
                                                                      )
                                                                    ]
                                                                  : null,
                                                              border: bookController
                                                                          .slot
                                                                          .value ==
                                                                      'Morning ${bookController.slots[index1.value].morning[i]['Timings']}'
                                                                  ? Border.all(
                                                                      width: 2,
                                                                      color: Colors
                                                                          .white,
                                                                    )
                                                                  : Border.all(
                                                                      width: 2,
                                                                      color: Colors
                                                                          .transparent,
                                                                    ),
                                                            ),
                                                            child: AutoSizeText(
                                                              bookController.slots[index1.value].morning[
                                                                              i]
                                                                          [
                                                                          'Maxcarcount'] ==
                                                                      bookController
                                                                              .slots[index1.value].morning[i]
                                                                          [
                                                                          'NoOfCarsBooked']
                                                                  ? 'Booked'
                                                                  : (bookController.slots[index1.value].morning[i]
                                                                              [
                                                                              'Maxcarcount'] -
                                                                          bookController
                                                                              .slots[index1.value]
                                                                              .morning[i]['NoOfCarsBooked'])
                                                                      .toString(),
                                                              minFontSize: 1,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        AutoSizeText(
                                                          bookController
                                                                  .slots[index1
                                                                      .value]
                                                                  .morning[i]
                                                              ['Timings'],
                                                          minFontSize: 1,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey.shade200,
                                                            fontSize: 14,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            AutoSizeText(
                                              'Afternoon',
                                              minFontSize: 1,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Colors.grey.shade200,
                                                fontSize: 18,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              height: 52,
                                              width: Get.width - 16,
                                              child: ListView.builder(
                                                itemCount: bookController
                                                    .slots[index1.value]
                                                    .afternoon
                                                    .length
                                                /*bookController
                                                        .slots
                                                        .firstWhere((element) =>
                                                            element.date ==
                                                            bookController
                                                                .selectedDate
                                                                .value)
                                                        .morning
                                                        .length*/
                                                ,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, i) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 4,
                                                      right: 4,
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            if (bookController
                                                                        .slots[index1
                                                                            .value]
                                                                        .afternoon[i]
                                                                    [
                                                                    'Maxcarcount'] !=
                                                                bookController
                                                                        .slots[index1
                                                                            .value]
                                                                        .afternoon[i]
                                                                    [
                                                                    'NoOfCarsBooked']) {
                                                              setState(() {
                                                                if (bookController
                                                                        .slot
                                                                        .value ==
                                                                    'Afternoon ${bookController.slots[index1.value].afternoon[i]['Timings']}') {
                                                                  bookController
                                                                      .slot
                                                                      .value = '';
                                                                } else {
                                                                  bookController
                                                                          .slot
                                                                          .value =
                                                                      'Afternoon ${bookController.slots[index1.value].afternoon[i]['Timings']}';
                                                                }
                                                              });
                                                            }
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              left: 8,
                                                              right: 8,
                                                              top: 4,
                                                              bottom: 4,
                                                            ),
                                                            alignment: Alignment
                                                                .center,
                                                            width:
                                                                Get.width * 0.2,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: bookController
                                                                              .slots[index1.value].afternoon[i]
                                                                          [
                                                                          'Maxcarcount'] ==
                                                                      bookController
                                                                              .slots[index1.value].afternoon[i]
                                                                          [
                                                                          'NoOfCarsBooked']
                                                                  ? Colors.red
                                                                  : i % 2 != 0
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .yellow,
                                                              boxShadow: bookController
                                                                          .slot
                                                                          .value ==
                                                                      'Afternoon ${bookController.slots[index1.value].afternoon[i]['Timings']}'
                                                                  ? [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .white,
                                                                        blurRadius:
                                                                            5,
                                                                      )
                                                                    ]
                                                                  : null,
                                                              border: bookController
                                                                          .slot
                                                                          .value ==
                                                                      'Afternoon ${bookController.slots[index1.value].afternoon[i]['Timings']}'
                                                                  ? Border.all(
                                                                      width: 2,
                                                                      color: Colors
                                                                          .white,
                                                                    )
                                                                  : Border.all(
                                                                      width: 2,
                                                                      color: Colors
                                                                          .transparent,
                                                                    ),
                                                            ),
                                                            child: AutoSizeText(
                                                              bookController.slots[index1.value].afternoon[
                                                                              i]
                                                                          [
                                                                          'Maxcarcount'] ==
                                                                      bookController
                                                                              .slots[index1.value].afternoon[i]
                                                                          [
                                                                          'NoOfCarsBooked']
                                                                  ? 'Booked'
                                                                  : (bookController.slots[index1.value].afternoon[i]
                                                                              [
                                                                              'Maxcarcount'] -
                                                                          bookController
                                                                              .slots[index1.value]
                                                                              .afternoon[i]['NoOfCarsBooked'])
                                                                      .toString(),
                                                              minFontSize: 1,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        AutoSizeText(
                                                          bookController
                                                                  .slots[index1
                                                                      .value]
                                                                  .afternoon[i]
                                                              ['Timings'],
                                                          minFontSize: 1,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey.shade200,
                                                            fontSize: 14,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            AutoSizeText(
                                              'Evening',
                                              minFontSize: 1,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Colors.grey.shade200,
                                                fontSize: 18,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              height: 52,
                                              width: Get.width - 16,
                                              child: ListView.builder(
                                                itemCount: bookController
                                                    .slots[index1.value]
                                                    .evening
                                                    .length
                                                /*bookController
                                                        .slots
                                                        .firstWhere((element) =>
                                                            element.date ==
                                                            bookController
                                                                .selectedDate
                                                                .value)
                                                        .morning
                                                        .length*/
                                                ,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, i) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 4,
                                                      right: 4,
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            if (bookController
                                                                        .slots[index1
                                                                            .value]
                                                                        .evening[i]
                                                                    [
                                                                    'Maxcarcount'] !=
                                                                bookController
                                                                        .slots[index1
                                                                            .value]
                                                                        .evening[i]
                                                                    [
                                                                    'NoOfCarsBooked']) {
                                                              setState(() {
                                                                if (bookController
                                                                        .slot
                                                                        .value ==
                                                                    'Evening ${bookController.slots[index1.value].evening[i]['Timings']}') {
                                                                  bookController
                                                                      .slot
                                                                      .value = '';
                                                                } else {
                                                                  bookController
                                                                          .slot
                                                                          .value =
                                                                      'Evening ${bookController.slots[index1.value].evening[i]['Timings']}';
                                                                }
                                                              });
                                                            }
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              left: 8,
                                                              right: 8,
                                                              top: 4,
                                                              bottom: 4,
                                                            ),
                                                            alignment: Alignment
                                                                .center,
                                                            width:
                                                                Get.width * 0.2,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: bookController
                                                                              .slots[index1.value].evening[i]
                                                                          [
                                                                          'Maxcarcount'] ==
                                                                      bookController
                                                                              .slots[index1.value].evening[i]
                                                                          [
                                                                          'NoOfCarsBooked']
                                                                  ? Colors.red
                                                                  : i % 2 != 0
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .yellow,
                                                              boxShadow: bookController
                                                                          .slot
                                                                          .value ==
                                                                      'Evening ${bookController.slots[index1.value].evening[i]['Timings']}'
                                                                  ? [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .white,
                                                                        blurRadius:
                                                                            5,
                                                                      )
                                                                    ]
                                                                  : null,
                                                              border: bookController
                                                                          .slot
                                                                          .value ==
                                                                      'Evening ${bookController.slots[index1.value].evening[i]['Timings']}'
                                                                  ? Border.all(
                                                                      width: 2,
                                                                      color: Colors
                                                                          .white,
                                                                    )
                                                                  : Border.all(
                                                                      width: 2,
                                                                      color: Colors
                                                                          .transparent,
                                                                    ),
                                                            ),
                                                            child: AutoSizeText(
                                                              bookController.slots[index1.value].evening[
                                                                              i]
                                                                          [
                                                                          'Maxcarcount'] ==
                                                                      bookController
                                                                              .slots[index1.value].evening[i]
                                                                          [
                                                                          'NoOfCarsBooked']
                                                                  ? 'Booked'
                                                                  : (bookController.slots[index1.value].evening[i]
                                                                              [
                                                                              'Maxcarcount'] -
                                                                          bookController
                                                                              .slots[index1.value]
                                                                              .evening[i]['NoOfCarsBooked'])
                                                                      .toString(),
                                                              minFontSize: 1,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        AutoSizeText(
                                                          bookController
                                                                  .slots[index1
                                                                      .value]
                                                                  .evening[i]
                                                              ['Timings'],
                                                          minFontSize: 1,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey.shade200,
                                                            fontSize: 14,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 8,
                          left: 8,
                          top: 16,
                        ),
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.only(
                              top: 5,
                              bottom: 5,
                              right: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ExpandablePanel(
                              header: Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  left: 22,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.tools,
                                      color: Colors.lightGreen,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 18,
                                    ),
                                    Expanded(
                                      child: AutoSizeText(
                                        'Select Preferred Services',
                                        minFontSize: 1,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              collapsed: Container(),
                              expanded: Container(
                                height: 300,
                                child: serviceDetailsController.isLoading.value
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.lightGreen,
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: serviceDetailsController
                                            .services.length,
                                        itemBuilder: (context, i) {
                                          return CheckboxListTile(
                                            value: bookController.selected
                                                .contains(
                                                    serviceDetailsController
                                                        .services[i]),
                                            onChanged: (val) {
                                              setState(() {
                                                if (val == true) {
                                                  bookController.selected.add(
                                                      serviceDetailsController
                                                          .services[i]);
                                                } else {
                                                  bookController.selected.remove(
                                                      serviceDetailsController
                                                          .services[i]);
                                                }
                                              });
                                            },
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            checkColor: Colors.black,
                                            tristate: false,
                                            activeColor: Colors.lightGreen,
                                            title: AutoSizeText(
                                              serviceDetailsController
                                                  .services[i],
                                              minFontSize: 1,
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: Colors.grey.shade400,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                              theme: ExpandableThemeData(
                                hasIcon: true,
                                tapHeaderToExpand: true,
                                iconColor: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 8,
                          left: 8,
                          top: 16,
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(
                            top: 5,
                            bottom: 5,
                            right: 20,
                            left: 20,
                          ),
                          constraints: BoxConstraints(
                            maxHeight: 200,
                            minHeight: 100,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SingleChildScrollView(
                            child: TextField(
                              controller: bookController.speci,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    'Enter any specification for your service',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 15,
                                ),
                              ),
                              maxLines: null,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 15,
                          left: 8,
                          right: 8,
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              fillColor: MaterialStateProperty.all(
                                  Colors.lightGreenAccent.shade400),
                              checkColor: Colors.black,
                              value: bookController.isPickup.value,
                              onChanged: (val) {
                                bookController.isPickup.value = val as bool;
                              },
                            ),
                            Expanded(
                              child: AutoSizeText(
                                'avail for pickup/drop',
                                maxLines: 3,
                                minFontSize: 1,
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                      bookController.isPickup.value
                          ? Padding(
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 8,
                              ),
                              child: userAddressController.addresses.length == 0
                                  ? Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            bottom: 8,
                                          ),
                                          child: AutoSizeText(
                                            'Select an address',
                                            minFontSize: 1,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            bottom: 8,
                                            top: 8,
                                          ),
                                          child: AutoSizeText(
                                            'You don\'t have any address added',
                                            minFontSize: 1,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.lightGreen,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: AutoSizeText(
                                            'Add an address',
                                            minFontSize: 1,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          onPressed: () {
                                            Get.to(() => SelectAddress());
                                          },
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            bottom: 8,
                                          ),
                                          child: AutoSizeText(
                                            'Select an address',
                                            minFontSize: 1,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: Get.width,
                                          height: 105,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: userAddressController
                                                .addresses.length,
                                            itemBuilder: (context, i) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      addressId.value =
                                                          userAddressController
                                                              .addresses[i].id;
                                                    });
                                                  },
                                                  child: Container(
                                                    width: Get.width * 0.7,
                                                    height: 92,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        color: addressId
                                                                    .value ==
                                                                userAddressController
                                                                    .addresses[
                                                                        i]
                                                                    .id
                                                            ? Colors.blue
                                                            : Colors
                                                                .grey.shade700,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        AutoSizeText(
                                                          userAddressController
                                                              .addresses[i]
                                                              .name,
                                                          minFontSize: 1,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        AutoSizeText(
                                                          '${userAddressController.addresses[i].flat}, ${userAddressController.addresses[i].address}',
                                                          maxLines: 3,
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey.shade400,
                                                            fontSize: 14,
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
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 5,
                          left: 8,
                          right: 8,
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              fillColor: MaterialStateProperty.all(
                                  Colors.lightGreenAccent.shade400),
                              checkColor: Colors.black,
                              value: bookController.isFree.value,
                              onChanged: (val) {
                                bookController.isFree.value = val as bool;
                              },
                            ),
                            Expanded(
                              child: AutoSizeText(
                                'validate for free service',
                                maxLines: 3,
                                minFontSize: 1,
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: Text(
                            "By clicking this you agree that your car is under free-service period. This decision is subjected to the service center's approval and T&C.",style: TextStyle(color: Colors.grey.shade400,
                          fontSize: 10,),
                        textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 8,
                          left: 8,
                          top: 16,
                          bottom: 16,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                              ),
                              child: bookController.isLoading.value
                                  ? Container(
                                      height: 20,
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : AutoSizeText(
                                      'BOOK',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    )),
                          onPressed: () async {
                            if (userCarDetails.cars.isEmpty) {
                              Fluttertoast.showToast(
                                context,
                                msg: 'Please add a car first!',
                                toastDuration: 2,
                              );
                              return;
                            } else if (bookController.selectedDate.value ==
                                    '' ||
                                bookController.slot.value == '') {
                              Fluttertoast.showToast(
                                context,
                                msg: 'Please select a Time slot first!',
                                toastDuration: 2,
                              );
                              return;
                            } else if (bookController.selected.isEmpty) {
                              Fluttertoast.showToast(
                                context,
                                msg: 'Please select a service first!',
                                toastDuration: 2,
                              );
                              return;
                            } else if (bookController.isPickup.value == true &&
                                addressId.value == '') {
                              Fluttertoast.showToast(
                                context,
                                msg: 'Please select an address first!',
                                toastDuration: 2,
                              );
                              return;
                            }
                            Get.showOverlay(
                              asyncFunction: () async {
                                await bookController.createOrder(
                                    userCarDetails.cars[index.value],
                                    karmacController.serviceCenters[i].id,
                                    karmacController.serviceCenters[i].company,
                                    userAddressController.addresses.firstWhere(
                                        (e) => e.id == addressId.value),
                                    context);
                              },
                              loadingWidget: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.lightGreen,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

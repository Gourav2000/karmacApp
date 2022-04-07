import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:lottie/lottie.dart';
import '../models/user_car_controller.dart';
import '../models/car_details_controller.dart';
import '../models/remove_car_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';

class RemoveCarScreen extends StatefulWidget {
  @override
  _RemoveCarScreenState createState() => _RemoveCarScreenState();
}

class _RemoveCarScreenState extends State<RemoveCarScreen> {
  UserCarDetails userCarDetails = Get.put(UserCarDetails());
  CarDetailsController carDetailsController = Get.put(CarDetailsController());
  RemoveCarController removeCarController = Get.put(RemoveCarController());
  RxInt index = 0.obs;
  RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight -
        kTextTabBarHeight;
    return Obx(
      () => userCarDetails.isLoading.value ||
              carDetailsController.isLoading.value
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.lightGreen,
              ),
            )
          : Container(
              height: height,
              width: Get.width,
              alignment: Alignment.center,
              child: userCarDetails.cars.isEmpty
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
                          Text(
                            'You don\'t have any cars in your collection',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      width: Get.width,
                      height: height * 0.7,
                      child: isLoading.value
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Colors.lightGreen,
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
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      i == index.value
                                          ? BoxShadow(
                                              color:
                                                  Color.fromRGBO(0, 0, 255, 1),
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
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 15,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: carDetailsController.brands
                                                        .firstWhere((e) =>
                                                            e.name.toUpperCase() ==
                                                            userCarDetails.cars[i].brand
                                                                .toUpperCase())
                                                        .models
                                                        .firstWhere((e) =>
                                                            e.name.toUpperCase() ==
                                                            userCarDetails
                                                                .cars[i].model
                                                                .toUpperCase())
                                                        .up ==
                                                    ''
                                                ? 'https://drive.google.com/uc?export=view&id=1ZTngu9nhlaucu150aU2XJ_6NMQry8xzC'
                                                : carDetailsController.brands
                                                    .firstWhere((e) =>
                                                        e.name.toUpperCase() ==
                                                        userCarDetails.cars[i].brand
                                                            .toUpperCase())
                                                    .models
                                                    .firstWhere((e) =>
                                                        e.name.toUpperCase() ==
                                                        userCarDetails.cars[i].model.toUpperCase())
                                                    .up,
                                            fit: BoxFit.fitWidth,
                                            placeholder: (context, val) {
                                              return LottieBuilder.asset(
                                                'assets/anim/bimg.json',
                                                fit: BoxFit.contain,
                                                width: (Get.width * 0.7) - 4,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FittedBox(
                                              child: Image.network(
                                                carDetailsController.brands
                                                    .firstWhere((e) =>
                                                        e.name ==
                                                        userCarDetails
                                                            .cars[i].brand)
                                                    .imageUrl,
                                                height: 40,
                                                width: 40,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            AutoSizeText(
                                              '${userCarDetails.cars[i].model}',
                                              minFontSize: 1,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Colors.grey.shade400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          children: [
                                            Expanded(
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
                                                  left: 8,
                                                  right: 8,
                                                ),
                                                child: AutoSizeText(
                                                  userCarDetails
                                                      .cars[i].variant,
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
                                            Container(
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
                                              padding: const EdgeInsets.all(8),
                                              child: AutoSizeText(
                                                userCarDetails.cars[i].type,
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
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          children: [
                                            Expanded(
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
                                                  left: 8,
                                                  right: 8,
                                                ),
                                                child: AutoSizeText(
                                                  userCarDetails.cars[i].number,
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
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          children: [
                                            Expanded(
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
                                                  left: 8,
                                                  right: 8,
                                                ),
                                                child: AutoSizeText(
                                                  userCarDetails.cars[i].color,
                                                  maxLines: 1,
                                                  minFontSize: 1,
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
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.lightGreen,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: isLoading.value
                                                    ? Container(
                                                        height: 14,
                                                        width: 14,
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : AutoSizeText(
                                                        'REMOVE',
                                                        minFontSize: 1,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                onPressed: () async {
                                                  bool val = false;
                                                  await Get.defaultDialog(
                                                      title: 'Alert!!',
                                                      middleText:
                                                          'Are you sure you want to remove this car from your collection',
                                                      textConfirm: 'YES',
                                                      textCancel: 'NO',
                                                      titleStyle: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                      middleTextStyle:
                                                          TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                      confirmTextColor:
                                                          Colors.white,
                                                      cancelTextColor:
                                                          Colors.lightGreen,
                                                      buttonColor:
                                                          Colors.lightGreen,
                                                      onConfirm: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        val = true;
                                                      });
                                                  if (val == true) {
                                                    isLoading.value = true;
                                                    await removeCarController
                                                        .removeCar(
                                                            userCarDetails
                                                                .cars[
                                                                    index.value]
                                                                .id)
                                                        .then((value) {
                                                      index.value = 0;
                                                      isLoading.value = false;
                                                    });
                                                  }
                                                },
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
                              viewportFraction: 0.7,
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
            ),
    );
  }
}

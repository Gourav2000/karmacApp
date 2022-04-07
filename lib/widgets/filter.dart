import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:karmac/models/car_details_controller.dart';
import 'package:karmac/models/karmac_controller.dart';

class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  KarmacController karmacController = Get.put(KarmacController());
  CarDetailsController addCarController = Get.put(CarDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: Get.height * 0.3,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () {
                Get.defaultDialog(
                  title: 'Brands',
                  content: Container(
                    height: Get.height * 0.7,
                    width: Get.width * 0.8,
                    child: Material(
                      child: ListView.builder(
                        itemCount: addCarController.brands.length,
                        itemBuilder: (context, i) {
                          return Obx(
                            () => CheckboxListTile(
                              value: karmacController.brand
                                  .contains(addCarController.brands[i].name),
                              onChanged: (val) {
                                if (val == true) {
                                  setState(() {
                                    karmacController.brand
                                        .add(addCarController.brands[i].name);
                                  });
                                } else {
                                  setState(() {
                                    karmacController.brand.remove(
                                        addCarController.brands[i].name);
                                  });
                                }
                              },
                              checkColor: Colors.black,
                              tristate: false,
                              activeColor: Colors.lightGreen,
                              title: Row(
                                children: [
                                  Image.network(
                                    addCarController.brands[i].imageUrl,
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: AutoSizeText(
                                      addCarController.brands[i].name,
                                      minFontSize: 1,
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              title: AutoSizeText(
                'Brands',
                minFontSize: 1,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 18,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade600,
                size: 14,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 5,
              ),
              child: Wrap(
                children: karmacController.brand
                    .map((e) => Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                  addCarController.brands
                                      .firstWhere(
                                          (element) => element.name == e)
                                      .imageUrl,
                                  height: 20,
                                  width: 20,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                AutoSizeText(
                                  addCarController.brands
                                      .firstWhere(
                                          (element) => element.name == e)
                                      .name,
                                  minFontSize: 1,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      karmacController.brand.remove(e);
                                    });
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                    size: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 14,
                right: 14,
              ),
              child: Divider(
                color: Colors.grey.shade400,
                height: 0,
              ),
            ),
            ListTile(
              onTap: () {
                Get.defaultDialog(
                  title: 'Location',
                  content: Container(
                    height: Get.height * 0.5,
                    width: Get.width * 0.8,
                    child: Material(
                      child: ListView.builder(
                        itemCount: karmacController.locations.length,
                        itemBuilder: (context, i) {
                          return Obx(
                            () => CheckboxListTile(
                              value: karmacController.location
                                  .contains(karmacController.locations[i]),
                              onChanged: (val) {
                                if (val == true) {
                                  setState(() {
                                    karmacController.location
                                        .add(karmacController.locations[i]);
                                  });
                                } else {
                                  setState(() {
                                    karmacController.location
                                        .remove(karmacController.locations[i]);
                                  });
                                }
                              },
                              checkColor: Colors.black,
                              tristate: false,
                              activeColor: Colors.lightGreen,
                              title: AutoSizeText(
                                karmacController.locations[i],
                                minFontSize: 1,
                                maxLines: 2,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              title: AutoSizeText(
                'Location',
                minFontSize: 1,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 18,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade600,
                size: 14,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 5,
              ),
              child: Wrap(
                children: karmacController.location
                    .map((e) => Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AutoSizeText(
                                  e,
                                  minFontSize: 1,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      karmacController.location.remove(e);
                                    });
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                    size: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 14,
                right: 14,
              ),
              child: Divider(
                color: Colors.grey.shade400,
                height: 0,
              ),
            ),
            ListTile(
              onTap: () {
                Get.defaultDialog(
                  title: 'Customer Ratings',
                  content: Container(
                    height: Get.height * 0.3,
                    width: Get.width * 0.8,
                    child: Material(
                      child: ListView.builder(
                        itemCount: karmacController.ratings.length,
                        itemBuilder: (context, i) {
                          return Obx(
                            () => RadioListTile(
                              value: karmacController.ratings[i],
                              groupValue: karmacController.rating.value,
                              onChanged: (val) {
                                setState(() {
                                  karmacController.rating.value =
                                      val.toString();
                                });
                              },
                              controlAffinity: ListTileControlAffinity.trailing,
                              title: Row(
                                children: [
                                  RatingBarIndicator(
                                    itemCount:
                                        int.parse(karmacController.ratings[i]),
                                    itemBuilder: (context, i) {
                                      return Icon(
                                        Icons.star,
                                        color: Colors.lightGreenAccent.shade400,
                                      );
                                    },
                                    itemSize: 14,
                                    unratedColor: Colors.lightGreen,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  AutoSizeText(
                                    '${karmacController.ratings[i]}+',
                                    minFontSize: 1,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              title: AutoSizeText(
                'Customer Ratings',
                minFontSize: 1,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 18,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade600,
                size: 14,
              ),
            ),
            karmacController.rating.value == ''
                ? Container()
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 14,
                          right: 14,
                          bottom: 5,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RatingBarIndicator(
                                itemCount:
                                    int.parse(karmacController.rating.value),
                                itemBuilder: (context, i) {
                                  return Icon(
                                    Icons.star,
                                    color: Colors.lightGreenAccent.shade400,
                                  );
                                },
                                itemSize: 12,
                                unratedColor: Colors.lightGreen,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              AutoSizeText(
                                '${karmacController.rating.value}+',
                                minFontSize: 1,
                                maxLines: 2,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    karmacController.rating.value = '';
                                  });
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                  size: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 20,
                bottom: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      await karmacController.clearFilter();
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        top: 4,
                        bottom: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: AutoSizeText(
                        'Clear Filter',
                        minFontSize: 1,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await karmacController.saveFilter();
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 14,
                        right: 14,
                        top: 4,
                        bottom: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: AutoSizeText(
                        'Apply',
                        minFontSize: 1,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.lightGreen,
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

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:karmac/models/car_brand.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import '../models/car_details_controller.dart';
import '../models/add_car_controller.dart';

class AddCarScreen extends StatefulWidget {
  @override
  _AddCarScreenState createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  CarDetailsController addCarController = Get.put(CarDetailsController());
  AddCarController addCar = Get.put(AddCarController());
  RxBool isLoading = false.obs;
  Rxn<String?> brand = Rxn<String>(null);
  Rxn<String?> model = Rxn<String>(null);
  Rxn<String?> variant = Rxn<String>(null);
  Rxn<String?> type = Rxn<String>(null);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: addCar.key,
      child: Obx(
        () => addCarController.isLoading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.lightGreen,
                ),
              )
            : ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      right: 10,
                      left: 10,
                      bottom: 10,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        top: 4,
                        bottom: 4,
                      ),
                      child: GestureDetector(
                        onTap: () {},
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: Container(),
                          items: addCarController.brands
                              .map(
                                (brand) => DropdownMenuItem(
                                  value: brand.name,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.network(
                                        brand.imageUrl,
                                        height: 40,
                                        width: 40,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        brand.name,
                                        style: TextStyle(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          hint: AutoSizeText(
                            'Select Car Brand',
                            minFontSize: 1,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          itemHeight: null,
                          onChanged: (val) {
                            if (val != null) {
                              brand.value = val;
                              model.value = null;
                              variant.value = null;
                            } else {
                              brand.value = null;
                              model.value = null;
                              variant.value = null;
                            }
                          },
                          value: brand.value,
                          /*validator: (val) {
                            if (val == null) {
                              return 'Please select a car brand';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            addCar.carDetails['brand'] = val.toString();
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,*/
                          menuMaxHeight: 200,
                          dropdownColor: Colors.grey.shade900,
                          /*decoration: InputDecoration(
                            border: InputBorder.none,
                          ),*/
                          iconEnabledColor: Colors.grey.shade400,
                          iconDisabledColor: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                      left: 10,
                      bottom: 10,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        top: 4,
                        bottom: 4,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (brand.value == null) {
                            Fluttertoast.showToast(
                              context,
                              msg: 'Please select a brand first!',
                              toastDuration: 2,
                            );
                          }
                        },
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: Container(),
                          items: brand.value != null
                              ? addCarController.brands
                                  .firstWhere(
                                      (element) => element.name == brand.value)
                                  .models
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e.name,
                                      child: Text(
                                        e.name,
                                        style: TextStyle(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList()
                              : [],
                          hint: Text(
                            'Select Car Model',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          itemHeight: null,
                          value: model.value,
                          onChanged: (val) {
                            if (val != null) {
                              model.value = val;
                              variant.value = null;
                            } else {
                              model.value = null;
                              variant.value = null;
                            }
                          },
                          /*autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (val) {
                            if (val == null) {
                              return 'Please select a car model!';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            addCar.carDetails['model'] = val.toString();
                          },*/
                          menuMaxHeight: 200,
                          dropdownColor: Colors.grey.shade900,
                          /*decoration: InputDecoration(
                            border: InputBorder.none,
                          ),*/
                          iconEnabledColor: Colors.grey.shade400,
                          iconDisabledColor: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                  model.value != null
                      ? Container(
                          width: Get.width,
                          height: Get.width * 9 / 16,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CachedNetworkImage(
                              imageUrl: addCarController.brands
                                          .firstWhere((element) =>
                                              element.name == brand.value)
                                          .models
                                          .firstWhere(
                                              (e) => e.name == model.value)
                                          .up ==
                                      ''
                                  ? 'https://drive.google.com/uc?export=view&id=1ZTngu9nhlaucu150aU2XJ_6NMQry8xzC'
                                  : addCarController.brands
                                      .firstWhere((element) =>
                                          element.name == brand.value)
                                      .models
                                      .firstWhere((e) => e.name == model.value)
                                      .up,
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
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                      left: 10,
                      bottom: 10,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        top: 4,
                        bottom: 4,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (model.value == '') {
                            Fluttertoast.showToast(
                              context,
                              msg: 'Please select a model first!',
                              toastDuration: 2,
                            );
                          }
                        },
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: Container(),
                          hint: AutoSizeText(
                            'Select Car Variant',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          items: model.value != null
                              ? addCarController.brands
                                  .firstWhere(
                                      (element) => element.name == brand.value)
                                  .models
                                  .firstWhere((e) => e.name == model.value)
                                  .variants!
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e.toString(),
                                      child: Text(
                                        e.toString(),
                                        style: TextStyle(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList()
                              : [],
                          itemHeight: null,
                          value: variant.value,
                          onChanged: (val) {
                            if (val != null) {
                              variant.value = val;
                            } else {
                              variant.value = null;
                            }
                          },
                          /*validator: (val) {
                            if (val == null) {
                              return 'Please select a car variant!';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            addCar.carDetails['variant'] = val.toString();
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,*/
                          menuMaxHeight: 200,
                          dropdownColor: Colors.grey.shade900,
                          /*decoration: InputDecoration(
                            border: InputBorder.none,
                          ),*/
                          iconEnabledColor: Colors.grey.shade400,
                          iconDisabledColor: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                      left: 10,
                      bottom: 10,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        top: 4,
                        bottom: 4,
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: Container(),
                        items: [
                          DropdownMenuItem(
                            value: 'Petrol',
                            child: Text(
                              'Petrol',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Diesel',
                            child: Text(
                              'Diesel',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'CNG',
                            child: Text(
                              'CNG',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'LPG',
                            child: Text(
                              'LPG',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Electric',
                            child: Text(
                              'Electric',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ],
                        value: type.value,
                        hint: Text(
                          'Select Car Type',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        itemHeight: null,
                        onChanged: (val) {
                          if (val != null) {
                            type.value = val;
                          } else {
                            type.value = null;
                          }
                        },
                        /*validator: (val) {
                          if (val == null) {
                            return 'Please select car type!';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          addCar.carDetails['type'] = val.toString();
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,*/
                        menuMaxHeight: 200,
                        dropdownColor: Colors.grey.shade900,
                        /*decoration: InputDecoration(
                          border: InputBorder.none,
                        ),*/
                        iconEnabledColor: Colors.grey.shade400,
                        iconDisabledColor: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                      left: 10,
                      bottom: 10,
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 5,
                        bottom: 5,
                        right: 10,
                        left: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.deny(' '),
                        ],
                        style: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                        validator: (val) {
                          RegExp reg = RegExp(
                            r'[A-Z][A-Z]\d\d[A-Z][A-Z]\d\d\d\d',
                            caseSensitive: true,
                            multiLine: false,
                          );
                          if (val!.isEmpty) {
                            return 'Please enter your car registration no.!';
                          }
                          if (val.toString().length < 10) {
                            return 'Please enter a valid registration no.!(Eg. MH03CB4568)';
                          }
                          if (!reg.hasMatch(val.toString())) {
                            return 'Please enter a valid registration no.!(Eg. MH03CB4568)';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          addCar.carDetails['registrationNumber'] =
                              val.toString();
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText:
                              'Enter your Car Registration no. eg. MH03CB4568',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                      left: 10,
                      bottom: 10,
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 5,
                        bottom: 5,
                        right: 10,
                        left: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please enter your car color!';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          addCar.carDetails['color'] = val.toString();
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter your Car Color',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(150, 36),
                          primary: Colors.lightGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: addCarController.isLoading.value
                            ? Container(
                                height: 20,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'ADD',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                        onPressed: () {
                          isLoading.value = true;
                          if (brand.value == null) {
                            Fluttertoast.showToast(
                              context,
                              msg: 'Please select a brand first!',
                              toastDuration: 2,
                            );
                            return;
                          } else if (model.value == null) {
                            Fluttertoast.showToast(
                              context,
                              msg: 'Please select a model first!',
                              toastDuration: 2,
                            );
                            return;
                          } else if (variant.value == null) {
                            Fluttertoast.showToast(
                              context,
                              msg: 'Please select a variant first!',
                              toastDuration: 2,
                            );
                            return;
                          } else if (type.value == null) {
                            Fluttertoast.showToast(
                              context,
                              msg: 'Please select a type first!',
                              toastDuration: 2,
                            );
                            return;
                          }
                          Get.showOverlay(
                            asyncFunction: () async {
                              await addCar
                                  .saveForm(
                                      brand.value.toString(),
                                      model.value.toString(),
                                      variant.value.toString(),
                                      type.value.toString())
                                  .catchError((error) {
                                print(error);
                                throw (error);
                              }).then((value) {
                                brand.value = null;
                                model.value = null;
                                variant.value = null;
                                Fluttertoast.showToast(
                                  context,
                                  msg: 'Your car was added successfully!',
                                  toastDuration: 2,
                                );
                              });
                            },
                            loadingWidget: Center(
                              child: CircularProgressIndicator(
                                color: Colors.lightGreen,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

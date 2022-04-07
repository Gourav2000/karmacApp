import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karmac/models/address.dart';
import 'package:karmac/models/user_address_controller.dart';
import './select_address.dart';
import 'package:group_list_view/group_list_view.dart';

class MyAddressScreen extends StatefulWidget {
  @override
  _MyAddressScreenState createState() => _MyAddressScreenState();
}

class _MyAddressScreenState extends State<MyAddressScreen> {
  UserAddressController userAddressController =
      Get.put(UserAddressController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 26, 26, 1),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.lightGreen,
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        brightness: Brightness.dark,
        title: Text(
          'My Addresses',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => SelectAddress());
        },
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.lightGreen,
      ),
      body: Obx(
        () => Container(
          width: Get.width,
          height: height,
          child: userAddressController.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.lightGreen,
                  ),
                )
              : userAddressController.addresses.length == 0
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: AutoSizeText(
                          'You don\'t have any address added yet',
                          minFontSize: 1,
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    )
                  : GroupListView(
                      sectionsCount: 2,
                      countOfItemInSection: (int section) {
                        if (section == 0) {
                          return userAddressController.addresses
                              .where((e) => e.permanent == true)
                              .toList()
                              .length;
                        } else {
                          return userAddressController.addresses
                              .where((e) => e.permanent == false)
                              .toList()
                              .length;
                        }
                      },
                      groupHeaderBuilder: (context, section) {
                        if (section == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                              top: 8,
                            ),
                            child: AutoSizeText(
                              'Permanent Address',
                              minFontSize: 1,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 18,
                              ),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                              top: 8,
                            ),
                            child: AutoSizeText(
                              'Other Addresses',
                              minFontSize: 1,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 18,
                              ),
                            ),
                          );
                        }
                      },
                      itemBuilder: (context, index) {
                        if (index.section == 0) {
                          return Container(
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
                                      userAddressController.addresses
                                          .where((e) => e.permanent == true)
                                          .toList()[index.index]
                                          .name,
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
                                      '${userAddressController.addresses.where((e) => e.permanent == true).toList()[index.index].flat}, ${userAddressController.addresses.where((e) => e.permanent == true).toList()[index.index].address}',
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
                                          userAddressController.removeAddress(
                                              userAddressController.addresses
                                                  .where((e) =>
                                                      e.permanent == true)
                                                  .toList()[index.index]
                                                  .id);
                                        },
                                        child: AutoSizeText(
                                          'Remove',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            width: Get.width,
                            padding: index.index ==
                                    userAddressController.addresses
                                            .where((e) => e.permanent == false)
                                            .toList()
                                            .length -
                                        1
                                ? const EdgeInsets.only(
                                    top: 8,
                                    bottom: 75,
                                    left: 4,
                                    right: 4,
                                  )
                                : const EdgeInsets.only(
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
                                      userAddressController.addresses
                                          .where((e) => e.permanent == false)
                                          .toList()[index.index]
                                          .name,
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
                                      '${userAddressController.addresses.where((e) => e.permanent == false).toList()[index.index].flat}, ${userAddressController.addresses.where((e) => e.permanent == false).toList()[index.index].address}',
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: InkWell(
                                            onTap: () {
                                              userAddressController.makePermanent(
                                                  userAddressController
                                                      .addresses
                                                      .where((e) =>
                                                          e.permanent == false)
                                                      .toList()[index.index]
                                                      .id,
                                                  userAddressController
                                                              .addresses
                                                              .where((e) =>
                                                                  e.permanent ==
                                                                  true)
                                                              .toList()
                                                              .length ==
                                                          0
                                                      ? null
                                                      : userAddressController
                                                          .addresses
                                                          .firstWhere((e) =>
                                                              e.permanent ==
                                                              true)
                                                          .id);
                                            },
                                            child: AutoSizeText(
                                              'Make permanent',
                                              style: TextStyle(
                                                color: Colors.lightGreen,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Flexible(
                                          child: InkWell(
                                            onTap: () {
                                              userAddressController
                                                  .removeAddress(
                                                      userAddressController
                                                          .addresses
                                                          .where((e) =>
                                                              e.permanent ==
                                                              false)
                                                          .toList()[index.index]
                                                          .id);
                                            },
                                            child: AutoSizeText(
                                              'Remove',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
        ),
      ),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:karmac/models/order_controller.dart';

class OrderInfoScreen extends StatefulWidget {
  @override
  _OrderInfoScreenState createState() => _OrderInfoScreenState();
}

class _OrderInfoScreenState extends State<OrderInfoScreen> {
  OrderController orderController = Get.put(OrderController());
  var id = Get.arguments;

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        height:
            Get.height - MediaQuery.of(context).padding.top - kToolbarHeight,
        width: Get.width,
        child: ListView(
          children: [
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
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey.shade800,
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
                    width: 8,
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
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey.shade800,
                            ),
                            child: Column(
                              children: [
                                AutoSizeText(
                                  orderController.orders
                                      .firstWhere((e) => e.id == id)
                                      .time
                                      .split(' ')[0],
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.lightGreenAccent.shade400,
                                    fontSize: 14,
                                  ),
                                ),
                                AutoSizeText(
                                  orderController.orders
                                      .firstWhere((e) => e.id == id)
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
            Container(
              padding: const EdgeInsets.only(
                right: 12,
                left: 12,
                top: 4,
                bottom: 8,
              ),
              child: Container(
                padding: const EdgeInsets.only(
                  right: 10,
                  left: 10,
                  top: 2,
                  bottom: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ExpandablePanel(
                  header: Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.tools,
                          color: Colors.grey.shade400,
                          size: 20,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 30,
                            ),
                            child: AutoSizeText(
                              'Your Prefered Service',
                              minFontSize: 1,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.grey.shade200,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  collapsed: Container(),
                  expanded: Container(
                    //+75height: 300,
                    child: Column(
                      children:
                        List.generate(
                          orderController.orders
                              .firstWhere((e) => e.id == id)
                              .services
                              .length,
                           (i) {
                            return ListTile(
                              title: AutoSizeText(
                                orderController.orders
                                    .firstWhere((e) => e.id == id)
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
                  ),
                  theme: ExpandableThemeData(
                    hasIcon: true,
                    tapHeaderToExpand: true,
                    iconColor: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
            orderController.orders.firstWhere((e) => e.id == id).isPickup
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                          right: 12,
                          top: 4,
                          bottom: 4,
                        ),
                        child: Container(
                          width: Get.width - 24,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            left: 12,
                            right: 12,
                            top: 8,
                            bottom: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Colors.purple,
                            ),
                          ),
                          child: AutoSizeText(
                            'Selected Delivery Address',
                            minFontSize: 1,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Container(
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
                                  orderController.orders
                                      .firstWhere((e) => e.id == id)
                                      .address
                                      .name==''?'Untitled':orderController.orders
                                      .firstWhere((e) => e.id == id)
                                      .address
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
                                  '${orderController.orders.firstWhere((e) => e.id == id).address.flat}, ${orderController.orders.firstWhere((e) => e.id == id).address.address}',
                                  minFontSize: 1,
                                  maxLines: null,
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
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
                                  'Instructions provided by you',
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
                                  '${orderController.orders
                                      .firstWhere((e) => e.id == id)
                                      .userSpecificProblem}',
                                  minFontSize: 1,
                                  maxLines: null,
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

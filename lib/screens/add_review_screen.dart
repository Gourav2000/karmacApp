import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karmac/models/add_review_controller.dart';
import 'package:karmac/models/review_controller.dart';
import 'package:karmac/models/user_controller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AddReviewScreen extends StatefulWidget {
  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  late AddReviewController reviewController;
  UserController userController = Get.put(UserController());
  var arg = Get.arguments;

  @override
  void initState() {
    super.initState();
    reviewController = Get.put(AddReviewController(arg['sId']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(
          color: Colors.lightGreen,
        ),
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Container(
            height: Get.height -
                MediaQuery.of(context).padding.top -
                kToolbarHeight,
            width: Get.width,
            child: reviewController.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.lightGreen,
                    ),
                  )
                : ListView(
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
                          top: 25,
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: AutoSizeText(
                            'How satisfied are you with the service provider?',
                            minFontSize: 1,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.center,
                          width: Get.width - 16,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Stack(
                              children: [
                                RatingBar.builder(
                                  glow: false,
                                  allowHalfRating: true,
                                  initialRating: 0,
                                  direction: Axis.horizontal,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star_outline_sharp,
                                    color: Colors.lightGreenAccent.shade400,
                                    size: 25,
                                  ),
                                  ignoreGestures: true,
                                  onRatingUpdate: (_) {},
                                  unratedColor:
                                      Colors.lightGreenAccent.shade400,
                                ),
                                RatingBar.builder(
                                  glow: false,
                                  allowHalfRating: true,
                                  initialRating: 0,
                                  direction: Axis.horizontal,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.lightGreenAccent.shade400,
                                    size: 25,
                                  ),
                                  onRatingUpdate: (val) {
                                    reviewController.rating.value = val;
                                  },
                                  unratedColor: Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 10,
                          bottom: 8,
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: AutoSizeText(
                            'Quality of the service',
                            minFontSize: 1,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      width: 1,
                                      color: reviewController.service.value ==
                                              'Excellent'
                                          ? Color.fromRGBO(0, 0, 255, 1)
                                          : Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                child: AutoSizeText(
                                  'Excellent',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  reviewController.service.value = 'Excellent';
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        width: 1,
                                        color: reviewController.service.value ==
                                                'Good'
                                            ? Color.fromRGBO(0, 0, 255, 1)
                                            : Colors.grey.shade700),
                                  ),
                                ),
                                child: AutoSizeText(
                                  'Good',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  reviewController.service.value = 'Good';
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        width: 1,
                                        color: reviewController.service.value ==
                                                'Poor'
                                            ? Color.fromRGBO(0, 0, 255, 1)
                                            : Colors.grey.shade700),
                                  ),
                                ),
                                child: AutoSizeText(
                                  'Poor',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  reviewController.service.value = 'Poor';
                                },
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
                        child: AutoSizeText(
                          'Add a title to your review',
                          minFontSize: 1,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 8,
                        ),
                        child: AutoSizeText(
                          'Share an overview of your experience',
                          minFontSize: 1,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
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
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: TextField(
                              controller: reviewController.title,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    'What\'s most important to be shared ?',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 15,
                                ),
                                hintMaxLines: 2,
                              ),
                              maxLines: null,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 15,
                        ),
                        child: AutoSizeText(
                          'Write a detailed review',
                          minFontSize: 1,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 8,
                        ),
                        child: AutoSizeText(
                          'Share your service experience.Here you could mention about the quality, efficiency of the service',
                          minFontSize: 1,
                          maxLines: null,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 8,
                          left: 8,
                          top: 16,
                          bottom: 40,
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(
                            top: 5,
                            bottom: 5,
                            right: 20,
                            left: 20,
                          ),
                          constraints: BoxConstraints(
                            maxHeight: 500,
                            minHeight: 200,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: TextField(
                              controller: reviewController.desc,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    'What did you like the most ? What service did you avail ?',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 15,
                                ),
                                hintMaxLines: 3,
                              ),
                              maxLines: null,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Expanded(
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
                                    child: reviewController.isLoading1.value
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
                                            'SUBMIT',
                                            minFontSize: 1,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                            ),
                                          )),
                                onPressed: () {
                                  reviewController.addReview(
                                      userController.userDetails!.name,
                                      userController.userDetails!.imgUrl,
                                      arg['orderId']);
                                },
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
  }
}

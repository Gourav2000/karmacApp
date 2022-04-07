import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/review_controller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ReviewScreen extends StatefulWidget {
  final String sId;

  ReviewScreen(this.sId);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  FirebaseApp secondary = Firebase.app("business");
  late ReviewController reviewController;
  @override
  void initState() {
    super.initState();
    reviewController = Get.put(ReviewController(widget.sId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: Text(
          'Customer Reviews',
          style: TextStyle(
            color: Colors.grey.shade400,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.lightGreen,
        ),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: reviewController.reviews.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(
                          'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
                        ),
                        foregroundImage:
                            NetworkImage(reviewController.reviews[i].image),
                        backgroundColor: Colors.grey.shade400,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        reviewController.reviews[i].name,
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
                            itemBuilder: (context, index) => Icon(
                              Icons.star_border_outlined,
                              color: Colors.lightGreen,
                            ),
                            itemCount: 5,
                            itemSize: 15,
                            direction: Axis.horizontal,
                          ),
                          RatingBarIndicator(
                            rating: reviewController.reviews[i].rating,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.lightGreenAccent.shade400,
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
                      Text(
                        '${reviewController.reviews[i].date.toDate().day}/${reviewController.reviews[i].date.toDate().month}/${reviewController.reviews[i].date.toDate().year}',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    '${reviewController.reviews[i].service} service',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    reviewController.reviews[i].desc,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Was this helpful ?',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instanceFor(app: secondary)
                            .collection('ServiceCentres')
                            .doc(widget.sId)
                            .collection('Reviews')
                            .doc(reviewController.reviews[i].id)
                            .collection('Likes')
                            .where('uid',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return IconButton(
                              icon: snapshot.data!.docs.isEmpty
                                  ? Icon(
                                      Icons.thumb_up_alt_outlined,
                                      color: Colors.grey.shade400,
                                    )
                                  : snapshot.data!.docs.first['isLike'] == true
                                      ? Icon(
                                          Icons.thumb_up,
                                          color: Colors.grey.shade400,
                                        )
                                      : Icon(
                                          Icons.thumb_up_alt_outlined,
                                          color: Colors.grey.shade400,
                                        ),
                              onPressed: () {
                                if (snapshot.data!.docs.isEmpty) {
                                  FirebaseFirestore.instanceFor(app: secondary)
                                      .collection('ServiceCentres')
                                      .doc(widget.sId)
                                      .collection('Reviews')
                                      .doc(reviewController.reviews[i].id)
                                      .collection('Likes')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .set({
                                    'uid':
                                        FirebaseAuth.instance.currentUser!.uid,
                                    'isLike': true,
                                    'isDislike': false,
                                  });
                                  FirebaseFirestore.instanceFor(app: secondary)
                                      .collection('ServiceCentres')
                                      .doc(widget.sId)
                                      .collection('Reviews')
                                      .doc(reviewController.reviews[i].id)
                                      .update({
                                    'likes':
                                        reviewController.reviews[i].likes + 1
                                  });
                                } else {
                                  if (snapshot.data!.docs.first['isLike'] ==
                                      false) {
                                    FirebaseFirestore.instanceFor(
                                            app: secondary)
                                        .collection('ServiceCentres')
                                        .doc(widget.sId)
                                        .collection('Reviews')
                                        .doc(reviewController.reviews[i].id)
                                        .collection('Likes')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .update({
                                      'isLike': true,
                                      'isDislike': false,
                                    });
                                    if (snapshot.data!.docs.first['isLike'] ==
                                            false &&
                                        snapshot.data!.docs
                                                .first['isDislike'] ==
                                            false) {
                                      FirebaseFirestore.instanceFor(
                                              app: secondary)
                                          .collection('ServiceCentres')
                                          .doc(widget.sId)
                                          .collection('Reviews')
                                          .doc(reviewController.reviews[i].id)
                                          .update({
                                        'likes':
                                            reviewController.reviews[i].likes +
                                                1,
                                      });
                                    } else {
                                      FirebaseFirestore.instanceFor(
                                              app: secondary)
                                          .collection('ServiceCentres')
                                          .doc(widget.sId)
                                          .collection('Reviews')
                                          .doc(reviewController.reviews[i].id)
                                          .update({
                                        'likes':
                                            reviewController.reviews[i].likes +
                                                1,
                                        'dislikes': reviewController
                                                .reviews[i].dislikes -
                                            1,
                                      });
                                    }
                                  } else {
                                    FirebaseFirestore.instanceFor(
                                            app: secondary)
                                        .collection('ServiceCentres')
                                        .doc(widget.sId)
                                        .collection('Reviews')
                                        .doc(reviewController.reviews[i].id)
                                        .collection('Likes')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .update({
                                      'isLike': false,
                                      'isDislike': false,
                                    });
                                    FirebaseFirestore.instanceFor(
                                            app: secondary)
                                        .collection('ServiceCentres')
                                        .doc(widget.sId)
                                        .collection('Reviews')
                                        .doc(reviewController.reviews[i].id)
                                        .update({
                                      'likes':
                                          reviewController.reviews[i].likes - 1
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
                      StreamBuilder(
                        stream: FirebaseFirestore.instanceFor(app: secondary)
                            .collection('ServiceCentres')
                            .doc(widget.sId)
                            .collection('Reviews')
                            .doc(reviewController.reviews[i].id)
                            .collection('Likes')
                            .where('uid',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return IconButton(
                              icon: snapshot.data!.docs.isEmpty
                                  ? Icon(
                                      Icons.thumb_down_off_alt_outlined,
                                      color: Colors.grey.shade400,
                                    )
                                  : snapshot.data!.docs.first['isDislike'] ==
                                          true
                                      ? Icon(
                                          Icons.thumb_down,
                                          color: Colors.grey.shade400,
                                        )
                                      : Icon(
                                          Icons.thumb_down_off_alt_outlined,
                                          color: Colors.grey.shade400,
                                        ),
                              onPressed: () {
                                if (snapshot.data!.docs.isEmpty) {
                                  FirebaseFirestore.instanceFor(app: secondary)
                                      .collection('ServiceCentres')
                                      .doc(widget.sId)
                                      .collection('Reviews')
                                      .doc(reviewController.reviews[i].id)
                                      .collection('Likes')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .set({
                                    'uid':
                                        FirebaseAuth.instance.currentUser!.uid,
                                    'isLike': false,
                                    'isDislike': true,
                                  });
                                  FirebaseFirestore.instanceFor(app: secondary)
                                      .collection('ServiceCentres')
                                      .doc(widget.sId)
                                      .collection('Reviews')
                                      .doc(reviewController.reviews[i].id)
                                      .update({
                                    'dislikes':
                                        reviewController.reviews[i].dislikes + 1
                                  });
                                } else {
                                  if (snapshot.data!.docs.first['isDislike'] ==
                                      false) {
                                    FirebaseFirestore.instanceFor(
                                            app: secondary)
                                        .collection('ServiceCentres')
                                        .doc(widget.sId)
                                        .collection('Reviews')
                                        .doc(reviewController.reviews[i].id)
                                        .collection('Likes')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .update({
                                      'isLike': false,
                                      'isDislike': true,
                                    });
                                    if (snapshot.data!.docs.first['isLike'] ==
                                            false &&
                                        snapshot.data!.docs
                                                .first['isDislike'] ==
                                            false) {
                                      FirebaseFirestore.instanceFor(
                                              app: secondary)
                                          .collection('ServiceCentres')
                                          .doc(widget.sId)
                                          .collection('Reviews')
                                          .doc(reviewController.reviews[i].id)
                                          .update({
                                        'dislikes': reviewController
                                                .reviews[i].dislikes +
                                            1,
                                      });
                                    } else {
                                      FirebaseFirestore.instanceFor(
                                              app: secondary)
                                          .collection('ServiceCentres')
                                          .doc(widget.sId)
                                          .collection('Reviews')
                                          .doc(reviewController.reviews[i].id)
                                          .update({
                                        'dislikes': reviewController
                                                .reviews[i].dislikes +
                                            1,
                                        'likes':
                                            reviewController.reviews[i].likes -
                                                1,
                                      });
                                    }
                                  } else {
                                    FirebaseFirestore.instanceFor(
                                            app: secondary)
                                        .collection('ServiceCentres')
                                        .doc(widget.sId)
                                        .collection('Reviews')
                                        .doc(reviewController.reviews[i].id)
                                        .collection('Likes')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .update({
                                      'isLike': false,
                                      'isDislike': false,
                                    });
                                    FirebaseFirestore.instanceFor(
                                            app: secondary)
                                        .collection('ServiceCentres')
                                        .doc(widget.sId)
                                        .collection('Reviews')
                                        .doc(reviewController.reviews[i].id)
                                        .update({
                                      'dislikes':
                                          reviewController.reviews[i].dislikes -
                                              1
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
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

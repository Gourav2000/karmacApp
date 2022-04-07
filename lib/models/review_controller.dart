import 'package:get/get.dart';
import 'package:flutter/material.dart';
import './review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ntp/ntp.dart';

class ReviewController extends GetxController {
  FirebaseApp secondary = Firebase.app("business");
  final String sId;
  RxBool isLoading = false.obs;

  ReviewController(this.sId);

  RxList<Review> reviews = RxList<Review>([]);

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getData();
  }

  Future<bool> getData() async {
    reviews.bindStream(await getReviews());
    isLoading.value = false;
    return true;
  }

  Future<Stream<List<Review>>> getReviews() async {
    return FirebaseFirestore.instanceFor(app: secondary)
        .collection('ServiceCentres')
        .doc(sId)
        .collection('Reviews')
        .orderBy('likes', descending: true)
        .snapshots()
        .map((query) => query.docs.map((e) {
              return Review(
                id: e.id,
                rating: e['rating'],
                service: e['service'],
                desc: e['desc'],
                name: e['name'],
                image: e['imageUrl'],
                uid: e['uid'],
                likes: e['likes'],
                dislikes: e['dislikes'],
                date: e['date'],
                title: e['title'],
                orderId: e['orderId'],
              );
            }).toList());
  }
}

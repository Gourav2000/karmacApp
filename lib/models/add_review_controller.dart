import 'package:get/get.dart';
import 'package:flutter/material.dart';
import './review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ntp/ntp.dart';

class AddReviewController extends GetxController {
  FirebaseApp secondary = Firebase.app("business");
  final String sId;
  RxBool isLoading = false.obs;
  RxBool isLoading1 = false.obs;
  TextEditingController desc = TextEditingController();
  TextEditingController title = TextEditingController();
  RxDouble rating = 0.0.obs;
  RxString service = ''.obs;

  AddReviewController(this.sId);

  @override
  void onClose() {
    super.onClose();
    service.value = '';
    rating.value = 0.0;
    title.dispose();
    desc.dispose();
  }

  Future<void> addReview(String name, String imgUrl, String orderId) async {
    isLoading1.value = true;
    try {
      await FirebaseFirestore.instanceFor(app: secondary)
          .collection('ServiceCentres')
          .doc(sId)
          .collection('Reviews')
          .add({
        'rating': rating.value,
        'service': service.value,
        'desc': desc.text,
        'title': title.text,
        'name': name,
        'orderId': orderId,
        'imageUrl': imgUrl,
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'likes': 0,
        'dislikes': 0,
        'date': await NTP.now(),
      });
      double sum = 0;
      double review = 0;
      await FirebaseFirestore.instanceFor(app: secondary)
          .collection('ServiceCentres')
          .doc(sId)
          .collection('Reviews')
          .get()
          .then((value) {
        if (value.docs.length > 0) {
          value.docs.forEach((e) {
            sum = sum + e['rating'];
          });
          review = sum / value.docs.length;
          FirebaseFirestore.instanceFor(app: secondary)
              .collection('ServiceCentres')
              .doc(sId)
              .update({'rating': review.toString()});
        }
      });
      Get.back();
      isLoading1.value = false;
    } on FirebaseException catch (e) {
      print(e);
      throw (e);
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}

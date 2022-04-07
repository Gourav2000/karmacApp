import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:karmac/screens/home_page.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  final form = GlobalKey<FormState>();
  RxMap<String, String?> profileDetails = {
    'imageUrl': '',
    'phoneNo': FirebaseAuth.instance.currentUser!.phoneNumber == null
        ? null
        : FirebaseAuth.instance.currentUser!.phoneNumber!.substring(3),
    'name': null,
    'email': FirebaseAuth.instance.currentUser!.email == null
        ? null
        : FirebaseAuth.instance.currentUser!.email.toString(),
  }.obs;

  Future<void> saveForm(BuildContext context) async {
    final isValid = form.currentState!.validate();
    if (!isValid) {
      return;
    }
    isLoading.value = true;
    form.currentState!.save();
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'name': profileDetails['name'],
        'email': profileDetails['email'],
        'phn': profileDetails['phoneNo'],
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'imageUrl': profileDetails['imageUrl'],
      });
      Get.offAll(() => HomePage());
    } catch (error) {
      var message = 'Could not authenticate you. Please try again later!!';

      print(error);
    } finally {
      isLoading.value = false;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddCarController extends GetxController {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  RxBool isLoading = false.obs;
  var carDetails = {
    'brand': '',
    'model': '',
    'variant': '',
    'type': '',
    'registrationNumber': '',
    'color': '',
  };

  Future<void> saveForm(
      String brand, String model, String variant, String type) async {
    isLoading.value = true;
    final isValid = key.currentState!.validate();
    if (!isValid) {
      isLoading.value = false;
      return;
    }
    isLoading.value = true;
    key.currentState!.save();
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((doc) async {
        if (doc.data()!.containsKey('cars')) {
          var carList = doc.data()!['cars'] as List<dynamic>;
          carList.add({
            'id': Uuid().v4(),
            'carBrand': brand,
            'carModel': model,
            'variant': variant,
            'carColor': carDetails['color'],
            'carType': type,
            'regNumber': carDetails['registrationNumber'],
          });
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            'cars': carList,
          });
        } else {
          var carList = [];
          carList.add({
            'id': DateTime.now().toString(),
            'carBrand': brand,
            'carModel': model,
            'variant': variant,
            'carColor': carDetails['color'],
            'carType': type,
            'regNumber': carDetails['registrationNumber'],
          });
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            'cars': carList,
          });
        }
      });
      isLoading.value = false;
    } on FirebaseException catch (e) {
      isLoading.value = false;
      print(e);
      throw (e);
    } catch (error) {
      isLoading.value = false;
      print(error);
      throw (error);
    } finally {
      key.currentState?.reset();
    }
  }
}

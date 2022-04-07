import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class SelectAddressController extends GetxController {
  RxString address = ''.obs;
  RxString state1 = ''.obs;
  RxString city1 = ''.obs;
  RxString pincode1 = ''.obs;
  RxString name1 = ''.obs;
  RxString flat1 = ''.obs;
  RxDouble long = 0.0.obs;
  RxDouble lat = 0.0.obs;
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController flat = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController pincode = TextEditingController();
  RxBool isLoading = false.obs;

  Future<void> getLoc(double lat, double long) async {
    print(lat);
    isLoading.value = true;
    var url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$long&format=json');
    try {
      final response = await http.get(url,
          headers: {'Content-Type': 'application/json', 'Charset': 'utf-8'});

      final Map<String, dynamic> extractedData =
          json.decode(response.body) as Map<String, dynamic>;
      address.value = extractedData['display_name'];
      state1.value = extractedData['address']['state'];
      state.text = extractedData['address']['state'];
      pincode1.value = extractedData['address']['postcode'];
      pincode.text = extractedData['address']['postcode'];
      city1.value = extractedData['address']['city'];
      city.text = extractedData['address']['city'];
      isLoading.value = false;
    } catch (error) {
      Get.snackbar('error', error.toString());
      throw (error);
    }
  }

  Future<void> saveForm() async {
    isLoading.value = true;
    final isValid = key.currentState!.validate();
    if (!isValid) {
      isLoading.value = false;
      return;
    }
    key.currentState!.save();
    try {
      isLoading.value = true;
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((doc) async {
        if (doc.data()!.containsKey('address')) {
          var addList = doc.data()!['address'] as List<dynamic>;
          addList.add({
            'id': Uuid().v4(),
            'address': address.value,
            'state': state1.value,
            'city': city1.value,
            'name': name1.value,
            'pincode': pincode1.value,
            'flat': flat1.value,
            'lat': lat.value,
            'long': long.value,
            'Permanent': addList.length == 0
                ? true
                : addList
                            .where((e) => e['Permanent'] == true)
                            .toList()
                            .length ==
                        0
                    ? true
                    : false,
          });
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            'address': addList,
          });
        } else {
          var addList = [];
          addList.add({
            'id': Uuid().v4(),
            'address': address.value,
            'state': state1.value,
            'city': city1.value,
            'name': name1.value,
            'pincode': pincode1.value,
            'flat': flat1.value,
            'lat': lat.value,
            'long': long.value,
            'Permanent': true,
          });
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            'address': addList,
          });
        }
      });
      isLoading.value = false;
      Get.back();
      Get.back();
    } on FirebaseException catch (e) {
      isLoading.value = false;
      print(e);
      throw (e);
    } catch (error) {
      isLoading.value = false;
      print(error);
      throw (error);
    } finally {}
  }
}

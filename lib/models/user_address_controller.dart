import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class UserAddressController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<Address> addresses = RxList<Address>([]);
  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getData();
  }

  Future<bool> getData() async {
    addresses.bindStream(await getServiceCentersData());
    isLoading.value = false;
    return true;
  }

  Future<Stream<List<Address>>> getServiceCentersData() async {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((query) => (query.data()!['address'] as List<dynamic>)
            .map((e) => Address(
                  id: e['id'],
                  address: e['address'],
                  state: e['state'],
                  city: e['city'],
                  pincode: e['pincode'],
                  lat: e['lat'],
                  long: e['long'],
                  name: e['name'],
                  flat: e['flat'],
                  permanent: e['Permanent'],
                ))
            .toList());
  }

  Future<void> removeAddress(String id) async {
    isLoading.value = true;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) async {
      var addList = doc.data()!['address'] as List<dynamic>;
      addList.removeWhere((e) => e['id'] == id);
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'address': addList,
      });
    }).then((value) => isLoading.value = false);
  }

  Future<void> makePermanent(String id, String? change) async {
    isLoading.value = true;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) async {
      var addList = doc.data()!['address'] as List<dynamic>;
      if (change == null) {
        var index = addList.indexWhere((e) => e['id'] == id);
        var temp = addList[index];
        addList[index] = {
          'address': temp['address'],
          'city': temp['city'],
          'flat': temp['flat'],
          'id': temp['id'],
          'lat': temp['lat'],
          'long': temp['long'],
          'name': temp['name'],
          'pincode': temp['pincode'],
          'state': temp['state'],
          'Permanent': true,
        };
      } else {
        var index = addList.indexWhere((e) => e['id'] == id);
        var temp = addList[index];
        var changeIndex =
            addList.indexWhere((e) => e['id'] == change.toString());
        var temp1 = addList[changeIndex];
        addList[index] = {
          'address': temp['address'],
          'city': temp['city'],
          'flat': temp['flat'],
          'id': temp['id'],
          'lat': temp['lat'],
          'long': temp['long'],
          'name': temp['name'],
          'pincode': temp['pincode'],
          'state': temp['state'],
          'Permanent': true,
        };
        addList[changeIndex] = {
          'address': temp1['address'],
          'city': temp1['city'],
          'flat': temp1['flat'],
          'id': temp1['id'],
          'lat': temp1['lat'],
          'long': temp1['long'],
          'name': temp1['name'],
          'pincode': temp1['pincode'],
          'state': temp1['state'],
          'Permanent': false,
        };
      }
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'address': addList,
      });
    }).then((value) => isLoading.value = false);
  }
}

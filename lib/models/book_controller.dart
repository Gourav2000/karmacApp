import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:karmac/models/address.dart';
import 'package:karmac/models/car_details.dart';
import 'package:karmac/models/slot.dart';
import 'package:ntp/ntp.dart';

class BookController extends GetxController {
  final String sid;
  BookController({required this.sid});
  RxBool isLoading = false.obs;
  RxBool isLoading1 = false.obs;
  TextEditingController speci = TextEditingController();
  RxString selectedDate = ''.obs;
  RxString slot = ''.obs;
  RxString address = ''.obs;
  RxBool isPickup = false.obs;
  RxBool isFree = false.obs;
  RxList<String> selected = RxList<String>([]);
  RxList<Slot> slots = RxList<Slot>([]);

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getData();
  }

  Future<void> createOrder(CarDetails car, String sId, String sName,
      Address address, BuildContext ctx) async {
    isLoading1.value = true;
    try {
      await FirebaseFirestore.instanceFor(app: Firebase.app('business'))
          .collection('Orders')
          .add({
        'CheckinDate': '',
        'CheckinTime': '',
        'CheckoutDate': '',
        'CheckoutTime': '',
        'response': '',
        'carDetails': {
          'brand': car.brand,
          'model': car.model,
          'variant': car.variant,
          'type': car.type,
          'number': car.number,
          'color': car.color,
          'id': car.id,
        },
        'Date': selectedDate.value,
        'IsFreeService': isFree.value,
        'IsPickUpDrop': isPickup.value,
        'showReviewPopUp': true,
        'Time': slot.value,
        'UserID': FirebaseAuth.instance.currentUser!.uid,
        'PreDefinedBookingProblem': selected,
        'UserSpecificProblem':speci.text,
        'created': (await NTP.now()).toString(),
        'paymentDone': false,
        'serviceCenterId': sId,
        'address': isPickup.value
            ? {
                'title': address.name,
                'state': address.state,
                'city': address.city,
                'pincode': address.pincode,
                'address': address.address,
                'flat': address.flat,
                'lat': address.lat,
                'long': address.long,
                'Permanent': address.permanent,
              }
            : {},
        'status': '2',
        'serviceCentreName': sName,
      });
      isLoading1.value = false;
      Fluttertoast.showToast(
        ctx,
        msg: 'Order placed successfully!!',
        toastDuration: 2,
      );
      Get.back();
    } on FirebaseException catch (e) {
      isLoading1.value = false;
      rethrow;
    } catch (error) {
      isLoading1.value = false;
      rethrow;
    }
  }

  Future<bool> getData() async {
    slots.bindStream(await getSlots());
    isLoading.value = false;
    return true;
  }

  Future<Stream<List<Slot>>> getSlots() async {
    return FirebaseFirestore.instanceFor(app: Firebase.app("business"))
        .collection('ServiceCentres')
        .doc(sid)
        .collection('SlotData')
        .snapshots()
        .map((query) => query.docs
            .map((e) => Slot(
                  date: e['Date'],
                  acceptedAnyOrders: e['acceptedAnyOrders'],
                  morning: e['Morning'],
                  afternoon: e['Afternoon'],
                  evening: e['Evening'],
                ))
            .toList());
  }
}

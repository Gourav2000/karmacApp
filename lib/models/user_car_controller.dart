import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import './car_details.dart';

class UserCarDetails extends GetxController {
  RxBool isLoading = false.obs;
  RxList<CarDetails> cars = RxList<CarDetails>([]);

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getData().then((value) => isLoading.value = false);
  }

  Future<bool> getData() async {
    cars.bindStream(await getCars());
    //isLoading.value = false;
    return true;
  }

  Future<Stream<List<CarDetails>>> getCars() async {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((query) => (query.data()!['cars'] as List<dynamic>)
            .map((e) => CarDetails(
                  id: e['id'],
                  brand: e['carBrand'],
                  model: e['carModel'],
                  variant: e['variant'],
                  type: e['carType'],
                  number: e['regNumber'],
                  color: e['carColor'],
                ))
            .toList());
  }
}

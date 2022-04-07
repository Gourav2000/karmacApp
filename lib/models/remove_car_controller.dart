import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RemoveCarController extends GetxController {
  RxBool isLoading = false.obs;

  Future<void> removeCar(String id) async {
    isLoading.value = true;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) async {
      var carList = doc.data()!['cars'] as List<dynamic>;
      carList.removeWhere((e) => e['id'] == id);
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'cars': carList,
      });
    }).then((value) => isLoading.value = false);
  }
}

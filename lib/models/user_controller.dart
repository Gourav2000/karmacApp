import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import './user_details.dart';

class UserController extends GetxController {
  RxBool isLoading = false.obs;
  UserDetails? userDetails;
  @override
  void onInit() {
    super.onInit();
    getDetails();
  }

  Future<void> getDetails() async {
    isLoading.value = true;
    await FirebaseFirestore.instance
        .collection('Users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.docs.length == 0) {
        userDetails = null;
        isLoading.value = false;
      } else {
        userDetails = UserDetails(
          uid: value.docs.first.id,
          name: value.docs.first['name'],
          email: value.docs.first['email'],
          phoneNumber: value.docs.first['phn'],
          imgUrl: value.docs.first['imageUrl'],
        );
        isLoading.value = false;
      }
    });
  }
}

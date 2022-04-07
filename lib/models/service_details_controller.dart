import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceDetailsController extends GetxController {
  RxList<String> services = RxList<String>([]);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getService().then((value) => isLoading.value = false);
  }

  Future<void> getService() async {
    var datas = await FirebaseFirestore.instance
        .collection('ProductData')
        .doc('PreDefinedServices')
        .get();
    var data = datas.data()!;
    (data['service'] as List<dynamic>).forEach((element) {
      services.add(element);
    });
  }
}

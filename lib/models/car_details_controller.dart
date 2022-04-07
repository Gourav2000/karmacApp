import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './car_brand.dart';
import './car_model.dart';

class CarDetailsController extends GetxController {
  RxList<CarBrand> brands = RxList<CarBrand>([]);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getData().then((value) => isLoading.value = false);
  }

  Future<void> getData() async {
    var datas = await FirebaseFirestore.instance
        .collection('ProductData')
        .doc('CarModels')
        .get();
    var brandLogos = await FirebaseFirestore.instance
        .collection('ProductData')
        .doc('CarBrandLogos')
        .get();
    var modelPics = await FirebaseFirestore.instance.collection('Models').get();
    var brandLogo = brandLogos.data()!;
    var data = datas.data()!;
    data.keys.forEach((element) {
      List<CarModel> models = [];
      (data[element] as Map<String, Object>).keys.forEach((e) {
        models.add(CarModel(
          name: e,
          up: modelPics.docs
                      .where((m) => m.data()['model'] == e)
                      .toList()
                      .length ==
                  0
              ? ''
              : modelPics.docs
                  .firstWhere((m) => m.data()['model'] == e)
                  .data()['up'],
          side: modelPics.docs
                      .where((m) => m.data()['model'] == e)
                      .toList()
                      .length ==
                  0
              ? ''
              : modelPics.docs
                  .firstWhere((m) => m.data()['model'] == e)
                  .data()['side'],
          variants: data[element][e],
        ));
      });
      brands.add(CarBrand(
        name: element,
        imageUrl: brandLogo['BrandLogos'][element],
        models: models,
      ));
    });
  }
}

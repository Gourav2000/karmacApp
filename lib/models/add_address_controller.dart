import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_place/google_place.dart';

class AddAddressController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<AutocompletePrediction> suggestions =
      RxList<AutocompletePrediction>([]);

  Future<void> getSuggestions(String val) async {
    isLoading.value = true;
    var googlePlace = GooglePlace(dotenv.env['GOOGLE_API_KEY'].toString());
    var result = await googlePlace.autocomplete.get(val);
    suggestions.value = result?.predictions as List<AutocompletePrediction>;
    isLoading.value = false;
  }
}

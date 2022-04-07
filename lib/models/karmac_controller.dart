import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './service_center.dart';
import 'package:get_storage/get_storage.dart';

class KarmacController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<ServiceCenter> serviceCenters = RxList<ServiceCenter>([]);
  RxList<ServiceCenter> s = RxList<ServiceCenter>([]);
  RxList<ServiceCenter> highRated = RxList<ServiceCenter>([]);
  RxList<ServiceCenter> filtered = RxList<ServiceCenter>([]);
  RxList<String> brand = RxList<String>([]);
  RxList<String> location = RxList<String>([]);
  final data = GetStorage();
  RxString rating = ''.obs;
  var locations = [
    'Mumbai',
    'Kolkata',
    'Delhi',
    'Hyderabad',
    'Bengaluru',
    'Ahmedabad',
    'Chennai',
  ];
  var ratings = [
    '4',
    '3',
    '2',
    '1',
  ];

  @override
  void onInit() {
    super.onInit();
    serviceCenters.listen((sc) async {
      List d = (data.getKeys() as Iterable).toList();
      if (d.contains('brand')) {
        brand.value = ((await data.read('brand')) as List<dynamic>)
            .map((e) => e.toString())
            .toList();
      }
      if (d.contains('location')) {
        location.value = ((await data.read('location')) as List<dynamic>)
            .map((e) => e.toString())
            .toList();
      }
      if (d.contains('rating')) {
        rating.value = (await data.read('rating')) as String;
      }
      if (brand.value.length != 0 ||
          location.value.length != 0 ||
          rating.value != '') {
        await applyFilter();
      }
      isLoading.value = false;
    });
    isLoading.value = true;
    getData();
  }

  Future<bool> getData() async {
    serviceCenters.bindStream(await getServiceCentersData());
    highRated.bindStream(await getHighRatedData());

    isLoading.value = false;
    return true;
  }

  Future<Stream<List<ServiceCenter>>> getServiceCentersData() async {
    print('ggg');
    return FirebaseFirestore.instanceFor(app: Firebase.app("business"))
        .collection('ServiceCentres')
        .snapshots()
        .map((query)
          {
            print(query.docs.map((e) {
              print(e['city']);
              print(e['isOpen']);
            }));
            return query.docs
            .map((e) => ServiceCenter(
                  id: e.id,
                  brand: e['brand']??'',
                  company: e['company']??'',
                  address: e['b_adress']??'',
                  city: e['city']??'',
                  state: e['state'],
                  startTime: e['startTime']??'',
                  endTime: e['endTime']??'',
                  rating: e['rating']??'0',
                  phoneNumber: e['phn']??'',
                  isOpen: e['isOpen']??true,
                ))
            .toList();

        });
  }

  Future<Stream<List<ServiceCenter>>> getHighRatedData() async {

    return FirebaseFirestore.instanceFor(app: Firebase.app("business"))
        .collection('ServiceCentres')
        .orderBy('rating', descending: true)
        .limit(5)
        .snapshots()
        .map((query) {
          // query.docs.map((e) {
          //   print(e['city']);
          //   print(e['isOpen']);
          // });
          return query.docs
            .map((e) => ServiceCenter(
                  id: e.id,
                  brand: e['brand'],
                  company: e['company'],
                  address: e['b_adress'],
                  city: e['city'],
                  state: e['state'],
                  startTime: e['startTime'],
                  endTime: e['endTime'],
                  rating: e['rating'],
                  phoneNumber: e['phn'],
                  isOpen: e['isOpen'],
                ))
            .toList();
        });
  }

  void searchService(String query) {
    if (query.isEmpty) {
      s.value = [];
    } else {
      s.value = serviceCenters.where((element) {
        if (element.company.toLowerCase().startsWith(query.toLowerCase()) ||
            element.state.toLowerCase().startsWith(query.toLowerCase()) ||
            element.city.toLowerCase().startsWith(query.toLowerCase())) {
          return true;
        }
        return false;
      }).toList();
    }
  }

  Future<void> clearFilter() async {
    brand.value = [];
    location.value = [];
    rating.value = '';
    await data.write('brand', <String>[]);
    await data.write('location', <String>[]);
    await data.write('rating', '');
    filtered.value = [];
  }

  Future<void> saveFilter() async {
    await data.write('brand', brand.value);
    await data.write('location', location.value);
    await data.write('rating', rating.value);
    await applyFilter();
  }

  Future<void> applyFilter() async {
    filtered.value = serviceCenters
        .where((sc) =>
            ((brand.length == 0 ? true : (brand.value.contains(sc.brand)))) &&
            (location.length == 0
                ? true
                : (location
                    .map((e) => e.toUpperCase())
                    .toList()
                    .contains(sc.city.toUpperCase()))) &&
            (rating.value == ''
                ? true
                : double.parse(sc.rating) > double.parse(rating.value)
                    ? true
                    : false))
        .toList();
  }
}

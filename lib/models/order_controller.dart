import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:karmac/models/address.dart';
import 'package:karmac/models/car_details.dart';
import './order.dart';

class OrderController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoading1 = false.obs;
  RxList<Order> orders = RxList<Order>([]);
  RxList<Order> dateFilter = RxList<Order>([]);
  RxList<String> sIds = RxList<String>([]);

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    getData();
  }

  Future<bool> getData() async {
    orders.bindStream(await getOrders());
    await getServiceCentreIds();
    isLoading.value = false;
    return true;
  }

  Future<Stream<List<Order>>> getOrders() async {
    return FirebaseFirestore.instanceFor(app: Firebase.app("business"))
        .collection('Orders')
        .where('UserID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('status', descending: true)
        .orderBy('Date', descending: true)
        .snapshots()
        .map((query) => query.docs
            .map((e) => Order(
                  id: e.id,
                  car: CarDetails(
                    brand: e['carDetails']['brand']??'',
                    model: e['carDetails']['model']??'',
                    variant: e['carDetails']['variant']??'',
                    type: e['carDetails']['type']??'',
                    number: e['carDetails']['number']??'',
                    color: e['carDetails']['color']??'',
                    id: e['carDetails']['id']??'',
                  ),
                  created: e['created']??'',
                  date: e['Date']??'',
                  isFree: e['IsFreeService']??'',
                  isPickup: e['IsPickUpDrop']??'',
                  paymentDone: e['paymentDone']??'',
                  serviceCentreId: e['serviceCenterId']??'',
                  services: e['PreDefinedBookingProblem']??'',
                  userSpecificProblem: e['UserSpecificProblem']??'',
                  status: e['status']??'',
                  time: e['Time']??'',
                  serviceCentreName: e['serviceCentreName']??'',
                  checkInDate: e['CheckinDate']??'',
                  checkInTime: e['CheckinTime']??'',
                  checkOutDate: e['CheckoutDate']??'',
                  checkOutTime: e['CheckoutTime']??'',
                  response: e['response']??''.toString(),
                  showReviewPopUp: e['showReviewPopUp']??'',
                  address: Address(
                    address: e['address']['address']??'',
                    city: e['address']['city']??'',
                    flat: e['address']['flat']??'',
                    id: e['address']['id']??'',
                    lat: e['address']['lat']??'',
                    long: e['address']['long']??'',
                    name: e['address']['name']??'',
                    pincode: e['address']['pincode']??'',
                    state: e['address']['state']??'',
                    permanent: e['address']['Permanent'],
                  ),
                ))
            .toList());
  }

  Future<void> filterOrders(String start, String end) async {
    isLoading1.value = true;
    await FirebaseFirestore.instanceFor(app: Firebase.app("business"))
        .collection('Orders')
        .where('UserID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('Date', isGreaterThanOrEqualTo: start)
        .where('Date', isLessThanOrEqualTo: end)
        .orderBy('Date', descending: true)
        .get()
        .then((value) {
      dateFilter.value = value.docs
          .map((e) => Order(
                id: e.id,
                car: CarDetails(
                  brand: e['carDetails']['brand']??'',
                  model: e['carDetails']['model']??'',
                  variant: e['carDetails']['variant']??'',
                  type: e['carDetails']['type']??'',
                  number: e['carDetails']['number']??'',
                  color: e['carDetails']['color']??'',
                  id: e['carDetails']['id']??'',
                ),
                created: e['created']??'',
                date: e['Date']??'',
                isFree: e['IsFreeService']??'',
                isPickup: e['IsPickUpDrop']??'',
                paymentDone: e['paymentDone']??'',
                serviceCentreId: e['serviceCenterId']??'',
                services: e['PreDefinedBookingProblem']??'',
                status: e['status'],
                time: e['Time']??'',
                serviceCentreName: e['serviceCentreName']??'',
                checkInDate: e['CheckinDate']??'',
                checkInTime: e['CheckinTime']??'',
                checkOutDate: e['CheckoutDate']??'',
                userSpecificProblem: e['UserSpecificProblem']??'',
                checkOutTime: e['CheckoutTime']??'',
                response: e['response']??''.toString(),
                showReviewPopUp: e['showReviewPopUp']??'',
                address: Address(
                  address: e['address']['address']??'',
                  city: e['address']['city']??'',
                  flat: e['address']['flat']??'',
                  id: e['address']['id']??'',
                  lat: e['address']['lat']??'',
                  long: e['address']['long']??'',
                  name: e['address']['name']??'',
                  pincode: e['address']['pincode']??'',
                  state: e['address']['state']??'',
                  permanent: e['address']['Permanent'],
                ),
              ))
          .toList();
    });
    isLoading1.value = false;
  }

  Future<void> getServiceCentreIds() async {
    await FirebaseFirestore.instanceFor(app: Firebase.app("business"))
        .collection('Orders')
        .where('UserID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('status', isEqualTo: '1')
        .get()
        .then((value) {
      sIds.value = value.docs
          .map((element) => element['serviceCenterId'] as String)
          .toSet()
          .toList();
    });
  }
}

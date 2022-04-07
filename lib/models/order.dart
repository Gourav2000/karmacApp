import 'package:karmac/models/address.dart';
import 'package:karmac/models/car_details.dart';

class Order {
  final String id;
  final String serviceCentreId;
  final String serviceCentreName;
  final List services;
  final CarDetails car;
  final String status;
  final String date;
  final String time;
  final bool isPickup;
  final bool isFree;
  final String created;
  final bool paymentDone;
  final String checkInDate;
  final String userSpecificProblem;
  final String checkInTime;
  final String checkOutDate;
  final String checkOutTime;
  final String response;
  final bool showReviewPopUp;
  final Address address;

  Order({
    required this.id,
    required this.car,
    required this.serviceCentreId,
    required this.serviceCentreName,
    required this.created,
    required this.date,
    required this.isFree,
    required this.services,
    required this.isPickup,
    required this.paymentDone,
    required this.status,
    required this.time,
    required this.checkInDate,
    required this.checkInTime,
    required this.checkOutDate,
    required this.checkOutTime,
    required this.response,
    required this.showReviewPopUp,
    required this.address,
    required this.userSpecificProblem,
  });
}

class ServiceCenter {
  final String id;
  final String brand;
  final String company;
  final String address;
  final String city;
  final String state;
  final String startTime;
  final String endTime;
  final String rating;
  final String phoneNumber;
  final bool isOpen;

  ServiceCenter({
    required this.id,
    required this.brand,
    required this.address,
    required this.city,
    required this.company,
    required this.endTime,
    required this.startTime,
    required this.state,
    required this.rating,
    required this.phoneNumber,
    required this.isOpen,
  });
}

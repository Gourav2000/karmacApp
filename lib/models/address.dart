class Address {
  final String id;
  final double lat;
  final double long;
  final String address;
  final String name;
  final String flat;
  final String state;
  final String city;
  final String pincode;
  final bool permanent;

  Address({
    required this.address,
    required this.city,
    required this.flat,
    required this.id,
    required this.lat,
    required this.long,
    required this.name,
    required this.pincode,
    required this.state,
    required this.permanent,
  });
}

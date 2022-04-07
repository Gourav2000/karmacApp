class Slot {
  final List morning;
  final List afternoon;
  final List evening;
  final String date;
  final bool acceptedAnyOrders;

  Slot({
    required this.acceptedAnyOrders,
    required this.afternoon,
    required this.date,
    required this.evening,
    required this.morning,
  });
}

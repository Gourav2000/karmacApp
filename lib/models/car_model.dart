class CarModel {
  final String name;
  final String up;
  final String side;
  List? variants;

  CarModel({
    required this.name,
    this.variants,
    required this.side,
    required this.up,
  });
}

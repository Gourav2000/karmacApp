import './car_model.dart';

class CarBrand {
  final String name;
  final String imageUrl;
  final List<CarModel> models;

  CarBrand({
    required this.name,
    required this.imageUrl,
    required this.models,
  });
}

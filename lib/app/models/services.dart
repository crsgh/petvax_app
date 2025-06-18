import 'dart:math';

class ServicesModel {
  int id;
  String name;
  String category;
  String description;
  double price;
  String specie;
  String size;
  int clinicId;
  String image;
  bool isHomeService;

  ServicesModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.specie,
    required this.size,
    required this.clinicId,
    required this.image,
    this.isHomeService = false,
  });

  factory ServicesModel.fromJson(Map<String, dynamic> json) {
    return ServicesModel(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      price: double.tryParse(json['price']) ?? 0.0,
      specie: json['species'].toString(),
      size: json['size'] as String,
      clinicId: json['clinic_id'] as int,
      image:
          json['image'] ?? "https://picsum.photos/200/30${Random().nextInt(9)}",
      isHomeService: (json['home_service'] ?? 0) == 0 ? false : true,
    );
  }

  toJson() {
    return {
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'specie': specie,
      'size': size,
      'clinic_id': clinicId,
      'image': image,
      'is_home_service': isHomeService,
    };
  }
}

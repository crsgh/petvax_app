class Pet {
  final int id;
  final String name;
  final String species;
  final String? breed;
  final int? age;
  final String? color;
  final double? weight;
  final String? size;
  final String? gender;
  final String? image;

  Pet({
    required this.id,
    required this.name,
    required this.species,
    this.breed,
    this.age,
    this.color,
    this.weight,
    this.image,
    this.size,
    this.gender,
  });

  factory Pet.fromJson(json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      species: json['species'] ?? "canine",
      image: json['image'],
      breed: json['breed'],
      age: json['age'],
      color: json['color'],
      weight: double.tryParse(json['weight'] ?? "0.0") ?? 0.0,
      size: json['size'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'breed': breed,
      'age': age,
      'color': color,
      'weight': weight,
      'size': size,
      'gender': gender,
      'image': image,
    };
  }
}

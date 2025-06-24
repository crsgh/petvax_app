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
  final DateTime? birthDate;

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
    this.birthDate,
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
      birthDate: DateTime.tryParse(json['birth_date'] ?? '') ?? DateTime.now(),
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
      'birth_date': birthDate?.toIso8601String(),
    };
  }
}

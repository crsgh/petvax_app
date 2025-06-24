class Breed {
  int id;
  String name;
  int specieId;
  Breed({required this.id, required this.name, required this.specieId});
  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      id: json['id'] as int,
      name: json['name'] as String,
      specieId: json['species_id'] ?? 1,
    );
  }
}

class Breed {
  int id;
  String name;
  Breed({required this.id, required this.name});
  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(id: json['id'] as int, name: json['name'] as String);
  }
}

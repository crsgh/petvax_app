class Specie {
  int id;
  String name;
  Specie({required this.id, required this.name});

  factory Specie.fromJson(Map<String, dynamic> json) {
    return Specie(id: json['id'] as int, name: json['name'] as String);
  }
}

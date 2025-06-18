// Pet model
class Pet {
  final String name;
  final String breed;
  final String age;
  final String weight;
  final String size;
  final String gender;
  final String imageUrl;

  Pet({
    required this.name,
    required this.breed,
    required this.age,
    required this.weight,
    required this.size,
    required this.gender,
    required this.imageUrl,
  });
}

// Medical record model
class MedicalRecord {
  final int id;
  final String date;
  final String type;
  final String description;
  final String vet;
  final String status;

  MedicalRecord({
    required this.id,
    required this.date,
    required this.type,
    required this.description,
    required this.vet,
    required this.status,
  });
}

import 'package:petvax/app/models/clinic_model.dart';
import 'package:petvax/app/models/pet_model.dart';
import 'package:petvax/app/models/user_model.dart';

class MedicalRecord {
  int id;
  String date;
  String type;
  UserModel? veterinarian;
  Pet pet;
  String notes;
  String status;
  Clinic clinic;
  String treatmentDate;
  String diagnosis;
  String treatment;
  Map<String, dynamic>? inventoryItem;
  String? followup;

  MedicalRecord({
    required this.id,
    required this.date,
    required this.type,
    required this.clinic,
    this.veterinarian,
    required this.notes,
    required this.pet,
    required this.status,
    required this.treatmentDate,
    required this.diagnosis,
    required this.treatment,
    this.inventoryItem,
    this.followup,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    print(json);
    return MedicalRecord(
      id: json['id'] as int,
      date: json['treatment_date'] ?? "",
      type: json['type'] ?? "Treatment",
      clinic: Clinic.fromJson(json['clinic']),
      veterinarian:
          json['veterinarian'] != null
              ? UserModel.fromJson(json['veterinarian'])
              : null,
      pet: Pet.fromJson(json['pet']),
      notes: json['notes'] ?? "",
      status: json['status'] ?? "",
      treatmentDate: json['treatment_date'] ?? "",
      diagnosis: json['diagnosis'] ?? "",
      treatment: json['treatment'] ?? "",
      inventoryItem: json['inventory_item'],
      followup: json['followup'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'type': type,
      'clinic': clinic,
      'pet': pet,

      'veterinarian': veterinarian,
      'notes': notes,
      'status': status,
    };
  }
}

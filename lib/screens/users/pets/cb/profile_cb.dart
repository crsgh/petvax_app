import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/models/medical_record_model.dart';
import '../../../../app/models/medication_model.dart';
import '../../../../app/models/pet_model.dart';

enum PetProfileView { loading, loaded, error }

class PetProfileController extends GetxController {
  var view = PetProfileView.loading.obs;

  @override
  void onInit() async {
    tabController = TabController(length: 4, vsync: Get.find());
    view(PetProfileView.loaded);
    super.onInit();
  }

  late TabController tabController;

  final petData =
      Pet(
        name: 'Luna',
        breed: 'Golden Retriever',
        age: 3,
        weight: 28,
        color: 'Golden',
        species: 'canine',
        id: 0,
      ).obs;

  // final owner =
  //     Owner(
  //       name: 'Sarah Johnson',
  //       phone: '+1 (555) 123-4567',
  //       email: 'sarah.johnson@email.com',
  //       address: '123 Pet Street, City, State 12345',
  //     ).obs;

  // final veterinarian =
  //     Veterinarian(
  //       name: 'Dr. Emily Chen',
  //       clinic: 'Happy Paws Veterinary Clinic',
  //       phone: '+1 (555) 987-6543',
  //       address: '456 Vet Avenue, City, State 12345',
  //     ).obs;

  final medicalHistory = <MedicalRecord>[].obs;

  final medications =
      <Medication>[
        Medication(
          id: 1,
          name: 'Heartgard Plus',
          dosage: '1 tablet monthly',
          prescribedDate: '2024-04-01',
          notes: 'Heartworm prevention',
        ),
        Medication(
          id: 2,
          name: 'Bravecto',
          dosage: '1 chew every 12 weeks',
          prescribedDate: '2024-02-15',
          notes: 'Flea and tick prevention',
        ),
      ].obs;

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void handlePhotoUpload() {
    // Handle photo upload logic
    Get.snackbar('Photo', 'Photo upload functionality');
  }

  void handleEdit() {
    // Handle edit logic
    Get.snackbar('Edit', 'Edit functionality');
  }

  void addMedicalRecord() {
    // Handle add medical record
    Get.snackbar('Medical Record', 'Add medical record functionality');
  }

  void deleteMedicalRecord(int id) {
    medicalHistory.removeWhere((record) => record.id == id);
  }

  void addMedication() {
    // Handle add medication
    Get.snackbar('Medication', 'Add medication functionality');
  }

  void deleteMedication(int id) {
    medications.removeWhere((medication) => medication.id == id);
  }

  void scheduleAppointment() {
    // Handle schedule appointment
    Get.snackbar('Appointment', 'Schedule appointment functionality');
  }
}

class PetProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PetProfileController>(() => PetProfileController());
  }
}

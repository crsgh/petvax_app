import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petvax/app/constants/strings.dart';
import 'package:petvax/app/models/medical_record_model.dart';
import 'package:petvax/app/models/pet_model.dart';

class ViewPetController extends GetxController {
  var activeTab = 'overview'.obs;
  GetConnect connect = GetConnect();

  Rx<Pet> pet =
      Pet(
        id: 10,
        name: "Luna",
        breed: "Golden Retriever",
        age: 3,
        weight: 28,
        size: "Large",
        gender: "Female",
        image:
            "https://images.unsplash.com/photo-1552053831-71594a27632d?w=400&h=400&fit=crop&crop=face",
        species: 'canine',
      ).obs;

  final RxList<MedicalRecord> medicalHistory = <MedicalRecord>[].obs;

  void changeTab(String tab) {
    activeTab.value = tab;
  }

  String formatDate(String dateString) {
    final date = DateTime.tryParse(dateString) ?? DateTime.now(); //todo
    return "${_getMonthName(date.month)} ${date.day}, ${date.year}";
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Color getStatusColor(String status) {
    return status == 'upcoming' ? Colors.blue.shade600 : Colors.green.shade600;
  }

  Color getStatusBgColor(String status) {
    return status == 'upcoming' ? Colors.blue.shade50 : Colors.green.shade50;
  }

  String getTypeIcon(String type) {
    switch (type) {
      case 'Vaccination':
        return '💉';
      case 'Checkup':
        return '🔍';
      case 'Treatment':
        return '💊';
      case 'Appointment':
        return '📅';
      default:
        return '🏥';
    }
  }

  @override
  void onInit() async {
    super.onInit();
    connect.baseUrl = AppStrings.baseUrl;

    pet.value = Get.arguments;
    print(pet.value.toJson());
    await loadMedicalHistory();
  }

  Future<void> loadMedicalHistory() async {
    try {
      final response = await connect.get('medical-history/${pet.value.id}');

      print(response.body);
      if (response.statusCode == 200) {
        var data = response.body['data'];
        medicalHistory.value =
            data
                .map<MedicalRecord>((json) => MedicalRecord.fromJson(json))
                .toList();
      }
    } catch (e) {
      print('Error loading medical history: $e');
    }
  }
}

class ViewPetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ViewPetController());
  }
}

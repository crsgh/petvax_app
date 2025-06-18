// Controller
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petvax/app/models/pet_model.dart';
import 'package:petvax/app/models/user_model.dart';
import 'package:petvax/app/services/storage_service.dart';
import 'package:petvax/screens/all/utility/settings_controller.dart';

enum ProfileView { loading, loaded, error }

class PetOwnerController extends GetxController {
  final RxString activeTab = 'pets'.obs;
  var view = ProfileView.loading.obs;
  Settings settings = Get.find<Settings>();

  UserModel? user;

  void changeTab(String tab) {
    activeTab.value = tab;
  }

  void editProfile() {
    Get.snackbar(
      'Edit Profile',
      'Profile editing functionality',
      backgroundColor: Colors.blue.shade50,
      colorText: Colors.blue.shade700,
      snackPosition: SnackPosition.TOP,
    );
  }

  void viewBookings() {
    Get.snackbar(
      'My Bookings',
      'Viewing bookings functionality',
      backgroundColor: Colors.purple.shade50,
      colorText: Colors.purple.shade700,
      snackPosition: SnackPosition.TOP,
    );
  }

  void addPet() {
    // Get.snackbar(
    //   'Add Pet',
    //   'Add new pet functionality',
    //   backgroundColor: Colors.green.shade50,
    //   colorText: Colors.green.shade700,
    //   snackPosition: SnackPosition.TOP,
    // );
    Get.toNamed('/add-pet');
  }

  void editPet(Pet pet) {
    Get.snackbar(
      'Edit Pet',
      'Editing ${pet.name}',
      backgroundColor: Colors.orange.shade50,
      colorText: Colors.orange.shade700,
      snackPosition: SnackPosition.TOP,
    );
  }

  @override
  void onInit() async {
    user = await Storage.getUser();
    view(ProfileView.loaded);
    super.onInit();
  }
}

class PetOwnerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PetOwnerController());
  }
}

class OwnerData {
  final String name;
  final String location;
  final String phone;
  final String email;
  final String joinDate;
  final int totalBookings;
  final double rating;
  final int reviewCount;
  final String avatar;

  OwnerData({
    required this.name,
    required this.location,
    required this.phone,
    required this.email,
    required this.joinDate,
    required this.totalBookings,
    required this.rating,
    required this.reviewCount,
    required this.avatar,
  });
}

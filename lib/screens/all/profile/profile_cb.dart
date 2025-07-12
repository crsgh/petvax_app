// Controller
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petvax/app/constants/strings.dart';
import 'package:petvax/app/models/pet_model.dart';
import 'package:petvax/app/models/user_model.dart';
import 'package:petvax/app/services/storage_service.dart';
import 'package:petvax/screens/all/utility/settings_controller.dart';

enum ProfileView { loading, loaded, error }

class PetOwnerController extends GetxController {
  final RxString activeTab = 'pets'.obs;
  final GlobalKey<FormState> formKey = GlobalKey();
  var view = ProfileView.loading.obs;
  Settings settings = Get.find<Settings>();

  UserModel? user;

  void changeTab(String tab) {
    activeTab.value = tab;
  }

  void editProfile() {
    final nameController = TextEditingController(text: user!.name);
    final phoneController = TextEditingController(text: user!.phone);
    final addressController = TextEditingController(text: user!.address);

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Profile',
                      style: GoogleFonts.poppins(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                TextFormField(
                  validator: (e) => e == "" ? "Name is required!" : null,
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  validator: (e) => !RegExp(r'^09\d{9}$').hasMatch(e.toString()) ? "Invalid phone format!" : null ,
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      // Update user data
                      user!.name = nameController.text;
                      user!.phone = phoneController.text;
                      user!.address = addressController.text;

                      // Save to storage
                      Storage.saveUser(user: user!);
                      // Save to DB
                      var res = await GetConnect().post("${AppStrings.baseUrl}update-user", {
                        'name' : nameController.text,
                        'contact_number' : phoneController.text,
                        'address' : addressController.text
                      });

                      print("result of update: ${res.body}");

                      // Update UI
                      update();

                      Get.back();
                      Get.snackbar(
                        'Success',
                        'Profile updated successfully',
                        backgroundColor: Colors.green.shade50,
                        colorText: Colors.green.shade700,
                        snackPosition: SnackPosition.TOP,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Save Changes',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petvax/app/constants/colors.dart';
import 'package:petvax/app/constants/strings.dart';
import 'package:petvax/app/models/pet_model.dart';
import 'package:petvax/app/widgets/custom_text.dart';
import 'package:petvax/screens/users/pets/cb/pets_cb.dart';

import '../../../app/components/custom_menu.dart';

class Pets extends GetView<PetsController> {
  const Pets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Obx(
          () => switch (controller.view.value) {
            PetsView.loading => _loading(),
            PetsView.loaded => _loaded(),
            PetsView.error => _error(),
          },
        ),
      ),
      floatingActionButton: CustomMenu(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  _loaded() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: AppColors.primaryGradient),
              borderRadius: BorderRadius.circular(16.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 25.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Pets',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            SizedBox(height: 4.h),
                            CustomText(
                              text: 'All pets are being shown.',
                              fontSize: 13,
                              color: Colors.blue.shade100,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.pets_rounded,
                            color: Colors.white,
                            size: 22.sp,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/add-pet');
                          },
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 22.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          RefreshIndicator(
            onRefresh: () async {
              await controller.settings.fetchPets();
            },
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.settings.pets.length,
              itemBuilder: (_, index) {
                Pet pet = controller.settings.pets[index];
                return Container(
                  width: Get.width,
                  margin: EdgeInsets.only(bottom: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.r),
                      bottomRight: Radius.circular(10.r),
                      topLeft: Radius.circular(4.r),
                      bottomLeft: Radius.circular(4.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 0),
                        color: Colors.grey[300]!,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Pet Info Section
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              height: 70.h,
                              width: 90.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4.r),
                                  bottomLeft: Radius.circular(4.r),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    pet.image != null
                                        ? "${AppStrings.imageUrl}${pet.image}"
                                        : 'https://picsum.photos/200/303',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 10.h,
                                horizontal: 15.w,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(text: pet.name, fontSize: 16),
                                  CustomText(
                                    text: pet.species,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Action Menu
                      PopupMenuButton<String>(
                        color: Colors.white,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        onSelected: (String value) async {
                          switch (value) {
                            case 'book':
                              // Handle book now action
                              Get.toNamed('/view-pet', arguments: pet);
                              break;
                            case 'edit':
                              // Handle edit action
                              Get.toNamed('/add-pet', arguments: pet);
                              break;
                            case 'delete':
                              var res = await controller.connect.get(
                                'pet/delete/${pet.id}',
                              );

                              await controller.settings.fetchPets();
                              if (res.statusCode == 200) {
                                controller.showSuccessSnackBar(
                                  'Pet deleted successfully',
                                );
                              } else {
                                controller.showErrorSnackbar('Pet not deleted');
                              }

                              print('Delete pressed for ${pet.name}');
                              break;
                          }
                        },
                        itemBuilder:
                            (BuildContext context) => [
                              PopupMenuItem<String>(
                                value: 'book',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.visibility_rounded,
                                      color: Colors.blue,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      'View',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'edit',

                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      'Edit',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'delete',

                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      'Delete',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          child: Icon(
                            Icons.more_horiz,
                            color: Colors.grey[600],
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _loading() {
    return const Center(child: Text('Clinics Loaded'));
  }

  _error() {
    return Center(
      child: const Center(child: CustomText(text: 'Error loading clinics')),
    );
  }
}

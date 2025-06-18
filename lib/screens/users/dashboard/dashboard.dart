import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petvax/app/components/appointments_section.dart';
import 'package:petvax/app/components/clinics_section.dart';
import 'package:petvax/app/constants/colors.dart';
import 'package:petvax/app/constants/strings.dart';

import '../../../app/components/custom_menu.dart';
import '../../../app/widgets/custom_text.dart';
import 'dashboard_cb.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Obx(
          () => switch (controller.view.value) {
            DashboardView.loaded => _loaded(),
            DashboardView.loading => Center(child: CircularProgressIndicator()),
            DashboardView.error => Center(child: CustomText(text: "App Error")),
          },
        ),
      ),
      floatingActionButton: CustomMenu(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  _loaded() {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.settings.fetchAll();
      },
      child: Column(
        children: [
          // Header Section
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "PetVax Dashboard",
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            Get.toNamed('/notifications');
                          },
                        ),
                        controller.settings.notifications.isNotEmpty
                            ? Positioned(
                              right: 10,
                              bottom: 10,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 2.w,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                            : Container(),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10.h),

                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: CupertinoTextField(
                    prefix: Padding(
                      padding: EdgeInsets.only(left: 15.w),
                      child: Icon(Icons.search, color: Colors.grey),
                    ),

                    controller: controller.searchQuery,
                    onChanged: (val) {
                      controller.updateSearchQuery(val);
                    },
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 10.w,
                    ),
                    placeholder: "Search Clinics...",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  // Clinics Section
                  Obx(
                    () => ClinicsSection(
                      clinics: controller.settings.clinics.value,
                      limit: 5,
                      padding: 0,
                      position: controller.position!,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Pets Section
                  _buildPetsSection(controller),
                  SizedBox(height: 24.h),

                  // Appointments Section
                  Obx(
                    () => AppointmentsSection(
                      appointments: controller.settings.appointments.value,
                      limit: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetsSection(DashboardController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "My Pets",
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed('/pets');
                },
                child: CustomText(
                  text: "View All",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Horizontal Scrollable Pets
          SizedBox(
            height: 75.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  controller.settings.pets.length >= 4
                      ? 4
                      : controller.settings.pets.length + 1,
              itemBuilder: (context, index) {
                if (index == controller.settings.pets.length) {
                  // Add Pet Card
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed('/add-pet');
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 12.w),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFD1D5DB),
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Icon(
                              Icons.add,
                              size: 20,
                              color: Colors.grey[400],
                            ),
                          ),
                          SizedBox(width: 10.w),
                          CustomText(
                            text: "Add Pet",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF6B7280),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final pet = controller.settings.pets[index];
                return GestureDetector(
                  onTap: () {
                    Get.toNamed('/view-pet', arguments: pet);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 12.w),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            gradient:
                                pet.image == null
                                    ? const LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        AppColors.primaryLight,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                    : null,
                            image:
                                pet.image != null
                                    ? DecorationImage(
                                      image: NetworkImage(
                                        '${AppStrings.imageUrl}${pet.image}',
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                    : null,
                          ),
                          child:
                              pet.image == null
                                  ? Center(
                                    child: CustomText(
                                      text: pet.name[0].toUpperCase(),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )
                                  : null,
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: pet.name,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                            CustomText(
                              text: pet.species,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF6B7280),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

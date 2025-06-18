import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petvax/app/constants/colors.dart';
import 'package:petvax/app/widgets/custom_bottomsheet.dart';
import 'package:petvax/app/widgets/custom_text.dart';
import 'package:petvax/screens/users/clinics/clinic_cb.dart';

import '../../../app/components/clinics_section.dart';
import '../../../app/components/custom_menu.dart';
import '../../../app/widgets/gradient_button.dart';

class Clinics extends GetView<ClinicsController> {
  const Clinics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => switch (controller.view.value) {
            ClinicsView.loading => _loading(),
            ClinicsView.loaded => _loaded(),
            ClinicsView.error => _error(),
          },
        ),
      ),
      floatingActionButton: CustomMenu(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  _loaded() {
    return SingleChildScrollView(
      child: RefreshIndicator(
        onRefresh: () async {
          controller.searchQuery.text = "";
          await controller.settings.fetchClinics();
        },
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.primaryGradient,
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
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 25.sp,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          CustomText(
                            text: "Clinics",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              CustomBottomsheet(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: 'Filter Clinics',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    SizedBox(height: 15.h),

                                    // Sort options
                                    CustomDropdown(
                                      items: ['Nearest First', 'A-Z', 'Z-A'],
                                      initialItem: controller.currentSort.value,
                                      onChanged: (val) {
                                        controller.sortClinics(val);
                                      },
                                      hintText: 'Sort by',
                                      decoration: CustomDropdownDecoration(
                                        closedFillColor: Colors.grey[200],
                                        headerStyle: GoogleFonts.poppins(),
                                        hintStyle: GoogleFonts.poppins(),
                                        listItemStyle: GoogleFonts.poppins(),
                                      ),
                                    ),

                                    SizedBox(height: 15.h),

                                    // Operation status filter
                                    Obx(
                                      () => CheckboxListTile(
                                        value: controller.showOpenOnly.value,
                                        onChanged: (val) {
                                          controller.showOpenOnly.value =
                                              val ?? false;
                                          controller.filterOpenClinics();
                                        },
                                        title: CustomText(
                                          text: 'Show Open Clinics Only',
                                        ),
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      ),
                                    ),
                                    SizedBox(height: 15.h),

                                    // Apply filters button
                                    GradientButton(
                                      text: "Apply Filters",
                                      onPressed: () {
                                        Get.back();
                                      },
                                      gradientColors: const [
                                        Color(0xFF2563EB),
                                        Color(0xFF9333EA),
                                      ],
                                      height: 48.h,
                                    ),
                                  ],
                                ),
                              ).floating();
                            },
                            child: Container(
                              padding: EdgeInsets.all(6.5.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: Colors.white,
                              ),
                              child: Icon(Icons.filter_list, size: 20.sp),
                            ),
                          ),
                          SizedBox(width: 5.w),
                          GestureDetector(
                            onTap: () {
                              CustomBottomsheet(
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: 'Select Clinic',
                                          fontWeight: FontWeight.w500,
                                        ),
                                        SizedBox(height: 3.h),
                                        CustomDropdown(
                                          items: [
                                            'sample clinic 1',
                                            'sample clinic 2',
                                          ],
                                          initialItem: 'sample clinic 1',
                                          onChanged: (val) {},
                                          decoration: CustomDropdownDecoration(
                                            closedFillColor: Colors.grey[200],
                                            headerStyle: GoogleFonts.poppins(),
                                            hintStyle: GoogleFonts.poppins(),
                                            listItemStyle:
                                                GoogleFonts.poppins(),
                                            //:
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),

                                    GradientButton(
                                      text: "Go to Services",
                                      onPressed: () {},
                                      gradientColors: [
                                        Colors.teal,
                                        Colors.tealAccent,
                                      ],
                                      height: 48.h,
                                    ),
                                  ],
                                ),
                              ).floating();
                            },
                            child: Container(
                              padding: EdgeInsets.all(6.5.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: Colors.teal,
                              ),
                              child: Icon(
                                Icons.add,
                                size: 20.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
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
                      suffix: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.isTagSearchEnabled.value =
                                  !controller.isTagSearchEnabled.value;
                              Get.snackbar(
                                'Tags Search',
                                controller.isTagSearchEnabled.value
                                    ? 'Tag search enabled'
                                    : 'Tag search disabled',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.white,
                                duration: const Duration(seconds: 2),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    controller.isTagSearchEnabled.value
                                        ? Colors.grey[300]
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.tag,
                                color: Colors.teal,
                                size: 20.sp,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                        ],
                      ),

                      controller: controller.searchQuery,
                      onChanged: (val) {
                        controller.searchClinics(val);
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
            Obx(
              () => ClinicsSection(
                clinics: controller.shownClinics.value,
                axis: Axis.vertical,
                height: Get.height - 160.h,
                imageHeight: 300.h,
                showHeader: false,
                position: controller.settings.position!,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loading() {
    return const Center(child: CircularProgressIndicator());
  }

  _error() {
    return Center(
      child: const Center(child: CustomText(text: 'Error loading clinics')),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petvax/app/components/appointments_section.dart';
import 'package:petvax/app/constants/colors.dart';
import 'package:petvax/app/widgets/custom_text.dart';

import '../../../app/components/custom_menu.dart';
import 'appointments_cb.dart';

class Appointments extends GetView<AppointmentsController> {
  const Appointments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => switch (controller.view.value) {
            AppointmentsView.loading => _loading(),
            AppointmentsView.loaded => _loaded(),
            AppointmentsView.error => _error(),
          },
        ),
      ),
      floatingActionButton: CustomMenu(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  _loaded() {
    return SingleChildScrollView(
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
                          text: "Appointments",
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
                            showModalBottomSheet(
                              context: Get.context!,
                              builder:
                                  (context) => Container(
                                    padding: EdgeInsets.all(16.w),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: "Filter Appointments",
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        SizedBox(height: 16.h),
                                        Obx(
                                          () => Wrap(
                                            spacing: 8.w,
                                            runSpacing: 8.h,
                                            children: [
                                              FilterChip(
                                                label: CustomText(
                                                  text: "Completed",
                                                ),
                                                selected:
                                                    controller
                                                        .selectedFilter
                                                        .value ==
                                                    "completed",
                                                onSelected: (selected) {
                                                  controller
                                                      .selectedFilter
                                                      .value = selected
                                                          ? "completed"
                                                          : "";
                                                  controller
                                                      .filterAppointments();
                                                },
                                              ),
                                              FilterChip(
                                                label: CustomText(
                                                  text: "Confirmed",
                                                ),
                                                selected:
                                                    controller
                                                        .selectedFilter
                                                        .value ==
                                                    "confirmed",
                                                onSelected: (selected) {
                                                  controller
                                                      .selectedFilter
                                                      .value = selected
                                                          ? "confirmed"
                                                          : "";
                                                  controller
                                                      .filterAppointments();
                                                },
                                              ),
                                              FilterChip(
                                                label: CustomText(
                                                  text: "Pending",
                                                ),
                                                selected:
                                                    controller
                                                        .selectedFilter
                                                        .value ==
                                                    "pending",
                                                onSelected: (selected) {
                                                  controller
                                                          .selectedFilter
                                                          .value =
                                                      selected ? "pending" : "";
                                                  controller
                                                      .filterAppointments();
                                                },
                                              ),
                                              FilterChip(
                                                label: CustomText(
                                                  text: "Declined",
                                                ),
                                                selected:
                                                    controller
                                                        .selectedFilter
                                                        .value ==
                                                    "declined",
                                                onSelected: (selected) {
                                                  controller
                                                      .selectedFilter
                                                      .value = selected
                                                          ? "declined"
                                                          : "";
                                                  controller
                                                      .filterAppointments();
                                                },
                                              ),
                                              FilterChip(
                                                label: CustomText(
                                                  text: "Cancelled",
                                                ),
                                                selected:
                                                    controller
                                                        .selectedFilter
                                                        .value ==
                                                    "cancelled",
                                                onSelected: (selected) {
                                                  controller
                                                      .selectedFilter
                                                      .value = selected
                                                          ? "cancelled"
                                                          : "";
                                                  controller
                                                      .filterAppointments();
                                                },
                                              ),
                                              SizedBox(height: 16.h),
                                              SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    controller
                                                        .filterAppointments();
                                                    Navigator.pop(context);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFF2563EB),
                                                    foregroundColor:
                                                        Colors.white,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 12.h,
                                                        ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8.r,
                                                          ),
                                                    ),
                                                  ),
                                                  child: const CustomText(
                                                    text: "Apply Filters",
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            );
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
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(6.5.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: Colors.teal,
                            ),
                            child: Icon(
                              Icons.calendar_month_rounded,
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
                // Container(
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(8.r),
                //   ),
                //   child: TextField(
                //     controller: controller.searchQuery,
                //     onChanged: (val) {
                //       //todo search
                //     },
                //     decoration: InputDecoration(
                //       hintStyle: GoogleFonts.poppins(
                //         fontWeight: FontWeight.w300,
                //       ),
                //       hintText: "Search appointments...",
                //       prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                //       border: InputBorder.none,
                //       contentPadding: EdgeInsets.all(12.w),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Obx(
            () => AppointmentsSection(
              appointments: controller.showAppointment.value,
              axis: Axis.vertical,
              height: Get.height - 160.h,
              showHeader: false,
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

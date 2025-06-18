import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petvax/app/constants/colors.dart';
import 'package:petvax/app/constants/strings.dart';
import 'package:petvax/app/models/medical_record_model.dart';
import 'package:petvax/screens/users/pets/cb/view_pet_cb.dart';

class ViewPet extends GetView<ViewPetController> {
  const ViewPet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: 1.sh,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildPetStatsCards(),
              _buildNavigationTabs(),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.primaryGradient,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 48.h, 24.w, 32.h),
        child: Column(
          children: [
            // Header title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pet Profile',
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24.w,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.favorite, color: Colors.white, size: 24.w),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24.h),
            // Pet photo and info
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4.w),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          controller.pet.value.image == null
                              ? 'assets/images/splash.png' // Assuming this is your splash image path
                              : AppStrings.imageUrl +
                                  controller.pet.value.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade300,
                              child: Icon(
                                Icons.pets,
                                size: 40.w,
                                color: Colors.grey.shade600,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Positioned(
                    //   bottom: -2.h,
                    //   right: -2.w,
                    //   child: Container(
                    //     width: 24.w,
                    //     height: 24.w,
                    //     decoration: BoxDecoration(
                    //       color: Colors.green.shade500,
                    //       shape: BoxShape.circle,
                    //       border: Border.all(color: Colors.white, width: 2.w),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.pet.value.name,
                        style: GoogleFonts.poppins(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        controller.pet.value.breed ?? "Unknown",
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          color: Colors.indigo.shade100,
                        ),
                      ),
                      Text(
                        '${controller.pet.value.age} • ${controller.pet.value.gender}',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Colors.indigo.shade100,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetStatsCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Transform.translate(
        offset: Offset(0, -24.h),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.monitor_weight_outlined,
                          color: Colors.blue.shade600,
                          size: 20.w,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Weight',
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      Text(
                        controller.pet.value.weight != null
                            ? controller.pet.value.weight.toString()
                            : "Unknown",
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.straighten,
                          color: Colors.green.shade600,
                          size: 20.w,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Size',
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      Text(
                        controller.pet.value.size ?? "Unknown",
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              Expanded(
                child: Obx(
                  () => GestureDetector(
                    onTap: () => controller.changeTab('overview'),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        color:
                            controller.activeTab.value == 'overview'
                                ? Colors.white
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(6.r),
                        boxShadow:
                            controller.activeTab.value == 'overview'
                                ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ]
                                : null,
                      ),
                      child: Text(
                        'Overview',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color:
                              controller.activeTab.value == 'overview'
                                  ? Colors.indigo.shade600
                                  : Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Obx(
                  () => GestureDetector(
                    onTap: () => controller.changeTab('medical'),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        color:
                            controller.activeTab.value == 'medical'
                                ? Colors.white
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(6.r),
                        boxShadow:
                            controller.activeTab.value == 'medical'
                                ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ]
                                : null,
                      ),
                      child: Text(
                        'Medical History',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color:
                              controller.activeTab.value == 'medical'
                                  ? Colors.indigo.shade600
                                  : Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Obx(() {
        if (controller.activeTab.value == 'overview') {
          return _buildOverviewContent();
        } else {
          return _buildMedicalContent();
        }
      }),
    );
  }

  Widget _buildOverviewContent() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Info',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 12.h),
            _buildInfoRow('Breed:', controller.pet.value.breed ?? "Unknown"),
            _buildInfoRow(
              'Age:',
              controller.pet.value.age != null
                  ? controller.pet.value.age.toString()
                  : "Unknown",
            ),
            _buildInfoRow('Gender:', controller.pet.value.gender ?? "Unknown"),
            _buildInfoRow(
              'Weight:',
              controller.pet.value.weight != null
                  ? controller.pet.value.weight.toString()
                  : "Unknown",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalContent() {
    return Column(
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.medical_services_outlined,
                  color: Colors.indigo.shade600,
                  size: 20.w,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Medical Records',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            // ElevatedButton(
            //   onPressed: () {},
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.indigo.shade600,
            //     foregroundColor: Colors.white,
            //     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8.r),
            //     ),
            //   ),
            //   child: Text(
            //     'View All',
            //     style: GoogleFonts.poppins(
            //       fontSize: 12.sp,
            //       fontWeight: FontWeight.w500,
            //     ),
            //   ),
            // ),
          ],
        ),
        SizedBox(height: 16.h),
        // Medical records list
        if (controller.medicalHistory.isEmpty)
          Center(
            child: Column(
              children: [
                SizedBox(height: 32.h),
                Icon(
                  Icons.medical_information_outlined,
                  size: 48.w,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 16.h),
                Text(
                  'No medical records found',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          )
        else
          ...controller.medicalHistory
              .take(5)
              .map((record) => _buildMedicalRecord(record)),
      ],
    );
  }

  Widget _buildMedicalRecord(MedicalRecord record) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Section with gradient
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade50, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.local_hospital_rounded,
                          color: Colors.indigo.shade700,
                          size: 20.w,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              record.clinic.name,
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.indigo.shade800,
                              ),
                            ),
                            Text(
                              record.veterinarian != null
                                  ? "Dr. ${record.veterinarian!.name}"
                                  : "N/A",
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                color: Colors.indigo.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    controller.formatDate(record.treatmentDate),
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.indigo.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content Section
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoSection("Diagnosis", record.diagnosis),
                SizedBox(height: 16.h),
                _buildInfoSection("Treatment", record.treatment),

                if (record.inventoryItem != null) ...[
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.medical_services_outlined,
                          size: 18.w,
                          color: Colors.green.shade700,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "Items used: ${record.inventoryItem!['name']}",
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (record.followup != null) ...[
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.event_repeat,
                          size: 18.w,
                          color: Colors.orange.shade700,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "Follow-up: ${controller.formatDate(record.followup!)}",
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (record.notes.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.note_alt_outlined,
                              size: 18.w,
                              color: Colors.grey.shade700,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Additional Notes",
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          record.notes,
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

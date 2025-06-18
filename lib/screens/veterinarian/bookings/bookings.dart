import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petvax/app/constants/colors.dart';
import 'package:petvax/app/constants/strings.dart';
import 'package:petvax/app/models/appointment_model.dart';
import 'package:petvax/screens/all/utility/settings_controller.dart';
import 'package:petvax/screens/veterinarian/bookings/bookings_cb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class VetBookingsScreen extends GetView<AppointmentsController> {
  const VetBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: AppColors.primaryGradient,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'My Appointments',
                              style: GoogleFonts.poppins(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                (await SharedPreferences.getInstance()).clear();
                                Get.offAndToNamed('/auth');
                              },
                              child: Container(
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Obx(
                        () => Text(
                          '${controller.settings.appointments.where((e) => e.status != 'completed').length} Active Bookings',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Sort Controls
            Container(
              width: Get.width,
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                  ),
                ),
                child: Stack(
                  children: [
                    Obx(
                      () => GestureDetector(
                        onTap: controller.toggleSortMenu,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.filter_list,
                                size: 16.sp,
                                color: const Color(0xFF374151),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Sort by ${controller.getCurrentSortLabel()}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF374151),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Transform.rotate(
                                angle:
                                    controller.showSortMenu.value ? 3.14159 : 0,
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16.sp,
                                  color: const Color(0xFF374151),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Sort Menu
                    Obx(
                      () =>
                          controller.showSortMenu.value
                              ? Positioned(
                                top: 40.h,
                                left: 0,
                                child: Material(
                                  elevation: 8,
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Container(
                                    width: 200.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: const Color(0xFFE5E7EB),
                                      ),
                                    ),
                                    child: Column(
                                      children:
                                          controller.sortOptions.map((option) {
                                            bool isSelected =
                                                controller.sortBy.value ==
                                                option.value;
                                            return GestureDetector(
                                              onTap:
                                                  () => controller.handleSort(
                                                    option.value,
                                                  ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 16.w,
                                                  vertical: 12.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      isSelected
                                                          ? const Color(
                                                            0xFFEFF6FF,
                                                          )
                                                          : Colors.transparent,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      option.label,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            isSelected
                                                                ? FontWeight
                                                                    .w500
                                                                : FontWeight
                                                                    .w400,
                                                        color:
                                                            isSelected
                                                                ? const Color(
                                                                  0xFF1D4ED8,
                                                                )
                                                                : const Color(
                                                                  0xFF374151,
                                                                ),
                                                      ),
                                                    ),
                                                    if (isSelected) ...[
                                                      const Spacer(),
                                                      Text(
                                                        '(${controller.sortOrder.value == 'asc' ? '↑' : '↓'})',
                                                        style:
                                                            GoogleFonts.poppins(
                                                              fontSize: 12.sp,
                                                              color:
                                                                  const Color(
                                                                    0xFF1D4ED8,
                                                                  ),
                                                            ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                  ),
                                ),
                              )
                              : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),

            // Appointments List
            Expanded(
              child: Obx(
                () =>
                    controller.sortedAppointments.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 48.sp,
                                color: const Color(0xFF9CA3AF),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'No appointments found',
                                style: GoogleFonts.poppins(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'You have no upcoming appointments',
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          padding: EdgeInsets.all(16.w),
                          itemCount: controller.sortedAppointments.length,
                          itemBuilder: (context, index) {
                            final appointment =
                                controller.sortedAppointments[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: AppointmentCard(appointment: appointment),
                            );
                          },
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Appointment Card Widget
class AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Date and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEAFE),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      size: 18.sp,
                      color: const Color(0xFF2563EB),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(appointment.date),
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF111827),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12.sp,
                            color: const Color(0xFF6B7280),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            _formatTime(appointment.date),
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(appointment.status)['bg'],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  appointment.status.toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: _getStatusColor(appointment.status)['text'],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Clinic and Service Info
          Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 14.w,
                    height: 14.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEAFE),
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    child: Center(
                      child: Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    appointment.clinicName,
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Container(
                    width: 14.w,
                    height: 14.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    child: Center(
                      child: Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFF059669),
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    appointment.serviceName,
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: const Color(0xFF374151),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Container(
                    width: 14.w,
                    height: 14.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    child: Center(
                      child: Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFF059669),
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "See customer location.",
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: const Color(0xFF374151),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  GestureDetector(
                    onTap: () async {
                      showDialog(
                        context: Get.context!,
                        barrierDismissible: false,
                        builder:
                            (context) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                      );
                      var res = await GetConnect().get(
                        "${AppStrings.baseUrl}homeservice/find/${appointment.id}",
                      );
                      var position = Get.find<Settings>().position!;
                      Get.back();
                      if (res.statusCode != 200) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Not Home Service',
                                style: GoogleFonts.poppins(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              content: Text(
                                'This booking is not a home service appointment.',
                                style: GoogleFonts.poppins(fontSize: 14.sp),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'OK',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        return;
                      }
                      final Uri googleMapsUrl = Uri.parse(
                        'https://www.google.com/maps/dir/?api=1&origin=${position.latitude},${position.longitude}&destination=${res.body['data']['latitude']},${res.body['data']['longitude']}&travelmode=driving',
                      );

                      await launchUrl(
                        googleMapsUrl,
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: Icon(
                      Icons.directions,
                      color: AppColors.primary,
                      size: 23.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // Pet and Amount Info
          Container(
            padding: EdgeInsets.only(top: 12.h),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.pets,
                      size: 14.sp,
                      color: const Color(0xFF6B7280),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      appointment.petName,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Icon(
                    //   Icons.attach_money,
                    //   size: 14.sp,
                    //   color: const Color(0xFF6B7280),
                    // ),
                    // SizedBox(width: 4.w),
                    Text(
                      appointment.amount,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Rating (if completed)
          if (appointment.status == 'completed' && appointment.rating > 0) ...[
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.only(top: 8.h),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
              ),
              child: Row(
                children: [
                  Text(
                    'Rating:',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        Icons.star,
                        size: 12.sp,
                        color:
                            index < appointment.rating
                                ? const Color(0xFFFBBF24)
                                : const Color(0xFFD1D5DB),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(String dateString) {
    final date = DateTime.parse(dateString);
    final hour =
        date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Map<String, Color> _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return {'bg': const Color(0xFFDBEAFE), 'text': const Color(0xFF1E40AF)};
      case 'completed':
        return {'bg': const Color(0xFFDCFCE7), 'text': const Color(0xFF065F46)};
      case 'pending':
        return {'bg': const Color(0xFFFEF3C7), 'text': const Color(0xFF92400E)};
      case 'cancelled':
        return {'bg': const Color(0xFFFEE2E2), 'text': const Color(0xFF991B1B)};
      default:
        return {'bg': const Color(0xFFF3F4F6), 'text': const Color(0xFF374151)};
    }
  }
}

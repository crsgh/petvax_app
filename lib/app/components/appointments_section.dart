import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petvax/app/constants/colors.dart';
import 'package:petvax/app/models/appointment_model.dart';
import 'package:petvax/app/widgets/gradient_button.dart';
import 'package:petvax/screens/all/utility/settings_controller.dart';
import '../constants/strings.dart';
import '../widgets/custom_text.dart';

class AppointmentsSection extends StatelessWidget {
  final List<Appointment> appointments;
  final Axis? axis;
  final double? height;
  final int? limit;
  final bool showHeader;
  const AppointmentsSection({
    super.key,
    required this.appointments,
    this.axis,
    this.showHeader = true,
    this.height,
    this.limit,
  });

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF10B981);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'completed':
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Color getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFFDCFCE7);
      case 'pending':
        return const Color(0xFFFEF3C7);
      case 'completed':
        return const Color(0xFFDBEAFE);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          showHeader
              ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Recent Appointments",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/appointments');
                    },
                    child: CustomText(
                      text: "View All",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              )
              : Container(),
          SizedBox(height: 16.h),

          // Appointments List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount:
                limit != null
                    ? (limit! > appointments.length
                        ? appointments.length
                        : limit!)
                    : appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final colors =
                  appointment.status.toLowerCase() == 'confirmed'
                      ? [AppColors.primary, AppColors.primary.withOpacity(0.7)]
                      : appointment.status.toLowerCase() == 'pending'
                      ? [AppColors.pending, AppColors.pending.withOpacity(0.7)]
                      : appointment.status.toLowerCase() == 'completed'
                      ? [AppColors.success, AppColors.success.withOpacity(0.7)]
                      : [
                        AppColors.cancelled,
                        AppColors.cancelled.withOpacity(0.7),
                      ];

              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  children: [
                    // Colored Header
                    Container(
                      height: 8.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: colors,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(8.r),
                        ),
                      ),
                    ),

                    // Content
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date, Status, and Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: Colors.grey[500],
                                  ),
                                  SizedBox(width: 8.w),
                                  CustomText(
                                    text: appointment.date,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF1F2937),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: getStatusBackgroundColor(
                                            appointment.status,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        child: CustomText(
                                          text: appointment.status,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: getStatusColor(
                                            appointment.status,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  appointment.status.toLowerCase().contains(
                                        'pending',
                                      )
                                      ? Row(
                                        children: [
                                          SizedBox(width: 5.w),
                                          GestureDetector(
                                            onTap: () async {
                                              var res = await GetConnect().get(
                                                '${AppStrings.baseUrl}booking/update/${appointment.id}/cancelled',
                                              );
                                              print(res.body);
                                              if (res.body['status'] ==
                                                  "success") {
                                                Get.snackbar(
                                                  "Success",
                                                  "Appointment cancelled successfully",
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                  backgroundColor: Colors.green
                                                      .withOpacity(0.1),
                                                  colorText: Colors.green,
                                                );
                                              } else {
                                                Get.snackbar(
                                                  "Error",
                                                  "Failed to cancel appointment",
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                  backgroundColor: Colors.red
                                                      .withOpacity(0.1),
                                                  colorText: Colors.red,
                                                );
                                              }
                                            },
                                            child: Icon(
                                              Icons.cancel,
                                              color: Colors.red,
                                              size: 22.sp,
                                            ),
                                          ),
                                        ],
                                      )
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),

                          // Clinic
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "Clinic",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF6B7280),
                              ),
                              SizedBox(height: 2.h),
                              CustomText(
                                text: appointment.clinicName,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1F2937),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),

                          // Service and Pet
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: "Service",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF6B7280),
                                    ),
                                    SizedBox(height: 2.h),
                                    CustomText(
                                      text: appointment.serviceName,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF1F2937),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: "Pet",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF6B7280),
                                    ),
                                    SizedBox(height: 2.h),
                                    CustomText(
                                      text: appointment.petName,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF1F2937),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),

                          // Amount and View Details
                          Container(
                            padding: EdgeInsets.only(top: 12.h),
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Color(0xFFF3F4F6)),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CustomText(
                                      text: appointment.amount,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF10B981),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.bottomSheet(
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                    top: Radius.circular(20.r),
                                                  ),
                                            ),
                                            padding: EdgeInsets.all(24.w),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    CustomText(
                                                      text:
                                                          'Appointment Details',
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: const Color(
                                                        0xFF1F2937,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed:
                                                          () => Get.back(),
                                                      icon: const Icon(
                                                        Icons.close,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 16.h),

                                                // Appointment Info
                                                Container(
                                                  padding: EdgeInsets.all(16.w),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFFF9FAFB,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12.r,
                                                        ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      _detailRow(
                                                        'Appointment ID',
                                                        '#${appointment.id}',
                                                      ),
                                                      _detailRow(
                                                        'Date & Time',
                                                        appointment.date,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          CustomText(
                                                            text: 'Status',
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: const Color(
                                                              0xFF6B7280,
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      8.w,
                                                                  vertical: 4.h,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  appointment.status
                                                                              .toLowerCase() ==
                                                                          'completed'
                                                                      ? const Color(
                                                                        0xFF10B981,
                                                                      ).withOpacity(
                                                                        0.1,
                                                                      )
                                                                      : appointment
                                                                              .status
                                                                              .toLowerCase() ==
                                                                          'approved'
                                                                      ? const Color(
                                                                        0xFF3B82F6,
                                                                      ).withOpacity(
                                                                        0.1,
                                                                      )
                                                                      : appointment
                                                                              .status
                                                                              .toLowerCase() ==
                                                                          'declined'
                                                                      ? const Color(
                                                                        0xFFDC2626,
                                                                      ).withOpacity(
                                                                        0.1,
                                                                      )
                                                                      : const Color(
                                                                        0xFF6B7280,
                                                                      ).withOpacity(
                                                                        0.1,
                                                                      ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    12.r,
                                                                  ),
                                                            ),
                                                            child: CustomText(
                                                              text:
                                                                  appointment
                                                                      .status,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  appointment.status
                                                                              .toLowerCase() ==
                                                                          'completed'
                                                                      ? const Color(
                                                                        0xFF10B981,
                                                                      )
                                                                      : appointment
                                                                              .status
                                                                              .toLowerCase() ==
                                                                          'approved'
                                                                      ? const Color(
                                                                        0xFF3B82F6,
                                                                      )
                                                                      : appointment
                                                                              .status
                                                                              .toLowerCase() ==
                                                                          'declined'
                                                                      ? const Color(
                                                                        0xFFDC2626,
                                                                      )
                                                                      : const Color(
                                                                        0xFF6B7280,
                                                                      ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10.h),
                                                      _detailRow(
                                                        'Payment Method',
                                                        'Cash',
                                                      ),

                                                      _detailRow(
                                                        'Total Amount',
                                                        appointment.amount,
                                                      ),
                                                      _detailRow(
                                                        'Notes',
                                                        'any',
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                SizedBox(height: 16.h),

                                                // Service & Clinic Info
                                                Container(
                                                  padding: EdgeInsets.all(16.w),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFFF9FAFB,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12.r,
                                                        ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      _detailRow(
                                                        'Service',
                                                        appointment.serviceName,
                                                      ),
                                                      _detailRow(
                                                        'Clinic',
                                                        appointment.clinicName,
                                                      ),
                                                      _detailRow(
                                                        'Pet',
                                                        appointment.petName,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                        );
                                      },
                                      child: CustomText(
                                        text: "View Details",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF2563EB),
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    appointment.status.toLowerCase().contains(
                                              "completed",
                                            ) &&
                                            appointment.rating == 0
                                        ? _rate(appointment)
                                        : Container(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: label,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6B7280),
          ),
          CustomText(
            text: value,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1F2937),
          ),
        ],
      ),
    );
  }

  _rate(Appointment appointment) {
    return GestureDetector(
      onTap: () {
        RxInt rating = appointment.rating.obs;
        var commentController = TextEditingController();
        Get.bottomSheet(
          Wrap(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                ),
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: 'Rate Your Experience',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F2937),
                        ),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(
                            Icons.close,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    // Service and Clinic Info
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.medical_services_outlined,
                                color: Color(0xFF6B7280),
                                size: 20,
                              ),
                              SizedBox(width: 15.w),
                              CustomText(
                                text: appointment.serviceName,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF1F2937),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              const Icon(
                                Icons.local_hospital_outlined,
                                color: Color(0xFF6B7280),
                                size: 20,
                              ),
                              SizedBox(width: 15.w),
                              CustomText(
                                text: appointment.clinicName,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF1F2937),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10.h),
                    Center(
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            5,
                            (index) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: IconButton(
                                icon: Icon(
                                  Icons.star_rounded,
                                  color:
                                      index < rating.value
                                          ? const Color(0xFFFBBF24)
                                          : const Color(0xFFE5E7EB),
                                  size: 30.sp,
                                ),
                                onPressed: () {
                                  rating.value = index + 1;
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    TextField(
                      controller: commentController,
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFF1F2937),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Share your experience...',
                        hintStyle: TextStyle(
                          color: const Color(0xFF9CA3AF),
                          fontSize: 15.sp,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF9FAFB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: const BorderSide(
                            color: Color(0xFF2563EB),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),
                    GradientButton(
                      text: "Submit Review",
                      onPressed: () async {
                        var response = await GetConnect()
                            .post('${AppStrings.baseUrl}rate/add', {
                              'clinic_id': appointment.clinicId,
                              'user_id': Get.find<Settings>().user!.id,
                              'rate': rating.value,
                              'comment': commentController.text,
                              'booking_id': appointment.id,
                              'is_anonymous': false,
                            });

                        print("response: ${response.body}");

                        if (response.status.hasError) {
                          Get.snackbar(
                            'Error',
                            'Failed to submit review',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red.withOpacity(0.1),
                            colorText: Colors.red,
                          );
                          return;
                        }
                        Get.back();
                        Get.snackbar(
                          'Thank You!',
                          'Your rating has been submitted successfully',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(
                            0xFF10B981,
                          ).withOpacity(0.1),
                          colorText: const Color(0xFF10B981),
                          duration: const Duration(seconds: 3),
                        );
                        Get.find<Settings>().fetchAppointments();
                      },
                      gradientColors: [
                        const Color(0xFFFBBF24),
                        const Color(0xFFF59042),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3C7),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: const Color(0xFFFBBF24)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star_rounded,
              color: const Color(0xFFFBBF24),
              size: 16.sp,
            ),
            SizedBox(width: 4.w),
            CustomText(
              text: "Rate",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFD97706),
            ),
          ],
        ),
      ),
    );
  }

  // Add these methods to handle the actions
  // ignore: unused_element
  void _editAppointment(appointment) {
    // Navigate to edit appointment screen or show edit dialog
    // Example:
    Get.toNamed('/edit-appointment', arguments: appointment);

    // Or show a bottom sheet/dialog
    // showEditAppointmentDialog(appointment);
  }

  // ignore: unused_element
  void _deleteAppointment(appointment, int index) {
    // Show confirmation dialog before deleting
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Appointment'),
        content: const Text(
          'Are you sure you want to delete this appointment?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              // Remove from list and update UI
              appointments.removeAt(index);
              Get.back();
              // You might also want to call an API to delete from backend
              _deleteAppointmentFromBackend(appointment.id);
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFDC2626),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  void _viewAppointmentDetails(appointment) {
    // Handle view details
    Get.toNamed('/appointment-details', arguments: appointment);
  }

  void _deleteAppointmentFromBackend(String appointmentId) {
    // API call to delete appointment from backend
    // Example:
    // appointmentService.deleteAppointment(appointmentId);
  }
}

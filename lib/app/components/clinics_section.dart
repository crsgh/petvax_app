import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:petvax/app/constants/colors.dart';
import 'package:petvax/app/constants/strings.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/clinic_model.dart';
import '../widgets/custom_text.dart';

class ClinicsSection extends StatelessWidget {
  final List<Clinic> clinics;
  final Axis? axis;
  final double? height;
  final double? imageHeight;
  final bool showHeader;
  final Position position;
  final double? padding;
  final int? limit;

  const ClinicsSection({
    super.key,
    required this.clinics,
    this.axis,
    this.height,
    this.imageHeight,
    this.showHeader = true,
    this.padding,
    required this.position,
    this.limit,
  });

  @override
  Widget build(BuildContext context) {
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
      padding: EdgeInsets.all(padding ?? 16.w),
      child: Column(
        children: [
          showHeader
              ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "Nearby Clinics",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            '/clinics',
                            arguments: {'search_param': ''},
                          );
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
                  SizedBox(height: 10.h),
                ],
              )
              : Container(),
          SizedBox(
            height: height ?? 235.h,
            child: ListView.builder(
              scrollDirection: axis ?? Axis.horizontal,
              itemCount:
                  limit != null
                      ? (limit! > clinics.length ? clinics.length : limit!)
                      : clinics.length,
              itemBuilder: (context, index) {
                final clinic = clinics[index];
                return Column(
                  children: [
                    Container(
                      width: height == null ? 280.w : double.infinity,
                      margin: EdgeInsets.only(
                        right: height != null ? 0 : 16.w,
                        bottom: height == null ? 0 : 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(8.r),
                            ),
                            child: Image.network(
                              AppStrings.imageUrl + clinic.image,

                              height:
                                  imageHeight ??
                                  (height == null ? 100.h : 125.h),
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 100.h,
                                  width: Get.width,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),

                          // Content
                          Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: clinic.name,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1F2937),
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 12,
                                          color: Colors.grey[600],
                                        ),
                                        SizedBox(width: 4.w),
                                        SizedBox(
                                          width: Get.width - 170.w,
                                          child: CustomText(
                                            text: clinic.location,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF6B7280),
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        final Uri googleMapsUrl = Uri.parse(
                                          'https://www.google.com/maps/dir/?api=1&origin=${position.latitude},${position.longitude}&destination=${clinic.latitude},${clinic.longitude}&travelmode=driving',
                                        );

                                        await launchUrl(
                                          googleMapsUrl,
                                          mode: LaunchMode.externalApplication,
                                        );
                                      },
                                      child: Icon(
                                        Icons.directions,
                                        size: 25.sp,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 12,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: CustomText(
                                        text:
                                            "${DateFormat('h:mm a').format(DateFormat('HH:mm').parse(clinic.openingTime))} - ${DateFormat('h:mm a').format(DateFormat('HH:mm').parse(clinic.closingTime))}",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text:
                                          "${(Geolocator.distanceBetween(position.latitude, position.longitude, clinic.latitude, clinic.longitude) / 1000).toStringAsFixed(2)} km away",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primary,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(
                                          '/services',
                                          arguments: clinic,
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(
                                            4.r,
                                          ),
                                        ),
                                        child: CustomText(
                                          text: "View",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

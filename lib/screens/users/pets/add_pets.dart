import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petvax/app/constants/colors.dart';
import 'package:petvax/app/widgets/gradient_button.dart';

import '../../../app/widgets/custom_input.dart';
import '../../../app/widgets/custom_text.dart';
import 'cb/add_pet_cb.dart';

class AddPetScreen extends StatelessWidget {
  const AddPetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddPetController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEBF4FF), Color(0xFFE0E7FF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // Header Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.primaryGradient,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 16.w,
                  ),
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
                                    text: 'Add New Pet',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 4.h),
                                  CustomText(
                                    text: 'Fill in the details.',
                                    fontSize: 13,
                                    color: Colors.blue.shade100,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.pets_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Main Form Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      // Image Upload Section
                      _buildImageUploadSection(controller),

                      SizedBox(height: 32.h),

                      // Form Fields
                      _buildFormFields(controller, context),

                      // Submit Button
                      _buildSubmitButton(controller),
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

  Widget _buildImageUploadSection(AddPetController controller) {
    return Column(
      children: [
        Obx(
          () => GestureDetector(
            onTap: () => _showImagePickerOptions(controller),
            child: Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      controller.selectedImage.value != null
                          ? Colors.blue.shade200
                          : Colors.grey.shade300,
                  width: 4,
                ),
                color:
                    controller.selectedImage.value != null
                        ? null
                        : Colors.grey.shade100,
              ),
              child:
                  controller.selectedImage.value != null
                      ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(60.r),
                            child: Image.file(
                              controller.selectedImage.value!,
                              width: 120.w,
                              height: 120.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: -1.h,
                            right: -1.w,
                            child: GestureDetector(
                              onTap: controller.removeImage,
                              child: Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 3.w,
                                    color: Colors.white,
                                  ),
                                ),

                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                      : Icon(
                        Icons.camera_alt,
                        size: 32,
                        color: Colors.grey.shade400,
                      ),
            ),
          ),
        ),

        SizedBox(height: 16.h),

        ElevatedButton.icon(
          onPressed: () => _showImagePickerOptions(controller),
          icon: Icon(Icons.upload, size: 16.sp, color: Colors.white),
          label: CustomText(
            text: 'Upload Photo',
            fontSize: 14,
            color: Colors.white,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields(AddPetController controller, BuildContext context) {
    return Column(
      children: [
        // Name and Species Row
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Pet Name *',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
            SizedBox(height: 8.h),
            Obx(
              () => CustomInputField(
                icon: Icons.pets,
                placeholder: 'Enter pet\'s name',
                value: controller.name.value,
                onChanged: (val) {
                  controller.name.value = val;
                },
                marginBottom: 10.h,
              ),
            ),
          ],
        ),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Species *',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
            SizedBox(height: 8.h),
            Obx(
              () => CustomInputField(
                placeholder: 'e.g Canine, Feline',
                value: controller.specie.value,
                onChanged: (val) {
                  controller.specie.value = val;
                },
                marginBottom: 10.h,
              ),
            ),
          ],
        ),

        // Breed and Gender Row
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Breed',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
            SizedBox(height: 8.h),
            Obx(
              () => CustomInputField(
                placeholder: 'Enter breed (optional)',
                value: controller.breed.value,
                onChanged: (val) {
                  controller.breed.value = val;
                },
                marginBottom: 10.h,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Gender',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
            SizedBox(height: 8.h),
            Obx(
              () => DropdownButtonFormField<String>(
                value:
                    controller.selectedGender.value.isEmpty
                        ? null
                        : controller.selectedGender.value,
                decoration: InputDecoration(
                  hintText: 'Select gender',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
                items:
                    controller.genderOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option['value'] as String,
                        child: CustomText(
                          text: option['label'] as String,
                          fontSize: 14,
                        ),
                      );
                    }).toList(),
                onChanged: (value) {
                  controller.selectedGender.value = value ?? '';
                },
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        // Birth Date and Weight Row
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16.sp),
                SizedBox(width: 4.w),
                CustomText(
                  text: 'Birth Date',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Obx(
              () => GestureDetector(
                onTap: () => controller.selectBirthDate(context),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: CustomText(
                    text:
                        controller.birthDate.value != null
                            ? '${controller.birthDate.value!.day}/${controller.birthDate.value!.month}/${controller.birthDate.value!.year}'
                            : 'Select birth date',
                    fontSize: 14,
                    color:
                        controller.birthDate.value != null
                            ? Colors.black87
                            : Colors.grey.shade500,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.scale, size: 16.sp),
                SizedBox(width: 4.w),
                CustomText(
                  text: 'Weight (kg)',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Obx(
              () => CustomInputField(
                placeholder: 'Enter weight',
                value: controller.weight.value,
                onChanged: (val) {
                  controller.weight.value = val;
                },
                marginBottom: 10.h,
              ),
            ),
          ],
        ),

        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildSubmitButton(AddPetController controller) {
    return SizedBox(
      width: double.infinity,
      child: GradientButton(
        text: controller.pet != null ? "Update Pet" : "Add Pet",
        onPressed: () {
          controller.submitForm();
        },
        gradientColors: AppColors.primaryGradient,
      ),
    );
  }

  void _showImagePickerOptions(AddPetController controller) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: 'Select Image Source',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      controller.pickImageFromCamera();
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 32,
                            color: const Color(0xFF2563EB),
                          ),
                          SizedBox(height: 8.h),
                          CustomText(
                            text: 'Camera',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      controller.pickImageFromGallery();
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.photo_library,
                            size: 32,
                            color: const Color(0xFF2563EB),
                          ),
                          SizedBox(height: 8.h),
                          CustomText(
                            text: 'Gallery',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

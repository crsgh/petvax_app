import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petvax/app/constants/colors.dart';
import 'package:petvax/app/widgets/custom_text.dart';

import '../../../app/widgets/custom_input.dart';
import '../../../app/widgets/gradient_button.dart';
import 'auth_cb.dart';
// Import your components here

class SignUpView extends StatelessWidget {
  final AuthController controller = Get.find<AuthController>();

  SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.h),

        // Header with back button
        Row(
          children: [
            IconButton(
              onPressed: () => controller.setCurrentView('signin'),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.grey[600],
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Create Account',

                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
                CustomText(
                  text: 'Join us today',
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 32.h),

        // Form Fields
        Obx(
          () => CustomInputField(
            icon: Icons.person_outline,
            placeholder: 'Full Name',
            value: controller.fullName.value,
            onChanged: controller.updateFullName,
            marginBottom: 15.h,
          ),
        ),

        Obx(
          () => CustomInputField(
            icon: Icons.email_outlined,
            placeholder: 'Email address',
            value: controller.email.value,
            onChanged: controller.updateEmail,
            keyboardType: TextInputType.emailAddress,
            marginBottom: 15.h,
          ),
        ),

        Obx(
          () => CustomInputField(
            icon: Icons.phone_outlined,
            placeholder: 'Phone number',
            value: controller.phone.value,
            onChanged: controller.updatePhone,
            keyboardType: TextInputType.phone,
            marginBottom: 15.h,
          ),
        ),

        Obx(
          () => CustomInputField(
            icon: Icons.lock_outline,
            placeholder: 'Password',
            value: controller.password.value,
            onChanged: controller.updatePassword,
            isPassword: true,
            showPassword: controller.showPassword.value,
            onTogglePassword: controller.togglePasswordVisibility,
            marginBottom: 15.h,
          ),
        ),

        Obx(
          () => CustomInputField(
            icon: Icons.lock_outline,
            placeholder: 'Confirm Password',
            value: controller.confirmPassword.value,
            onChanged: controller.updateConfirmPassword,
            isPassword: true,
            showPassword: controller.showConfirmPassword.value,
            onTogglePassword: controller.toggleConfirmPasswordVisibility,
            marginBottom: 15.h,
          ),
        ),

        // Terms and Conditions
        Obx(
          () => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: controller.acceptTerms.value,
                onChanged: (value) => controller.toggleTermsAcceptance(),
                activeColor: Colors.blue[600],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                      children: [
                        const TextSpan(text: 'I agree to the '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: GoogleFonts.poppins(
                            color: Colors.blue[600],
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: GoogleFonts.poppins(
                            color: Colors.blue[600],
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 24.h),

        // Create Account Button
        GradientButton(
          text: 'Create Account',
          onPressed: controller.signUp,
          gradientColors: AppColors.primaryGradient,
        ),

        SizedBox(height: 24.h),

        // Sign In Link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: 'Already have an account? ',
              color: Colors.grey[600],
              fontSize: 14.sp,
            ),
            GestureDetector(
              onTap: () => controller.setCurrentView('signin'),
              child: CustomText(
                text: 'Sign In',

                color: Colors.blue[600],
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

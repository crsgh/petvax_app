import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petvax/app/widgets/custom_text.dart';

import '../../../app/widgets/custom_input.dart';
import '../../../app/widgets/gradient_button.dart';
import 'auth_cb.dart';
// Import your components here

class ForgotPasswordView extends StatelessWidget {
  final AuthController controller = Get.find<AuthController>();

  ForgotPasswordView({super.key});

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
                  text: 'Reset Password',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900],
                ),
                CustomText(
                  text: "We'll send you a reset link",
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 40.h),

        // Email Icon
        Container(
          width: 80.w,
          height: 80.h,
          decoration: BoxDecoration(
            color: Colors.blue[100],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.email_outlined,
            color: Colors.blue[600],
            size: 32.sp,
          ),
        ),

        SizedBox(height: 24.h),
        CustomText(
          text:
              'Enter your email address and we\'ll send you a link to reset your password.',
          fontSize: 14,
          color: Colors.grey[600],
        ),

        SizedBox(height: 32.h),

        // Email Field
        Obx(
          () => CustomInputField(
            icon: Icons.email_outlined,
            placeholder: 'Email address',
            value: controller.email.value,
            onChanged: controller.updateEmail,
            keyboardType: TextInputType.emailAddress,
          ),
        ),

        SizedBox(height: 10.h),

        // Send Reset Link Button
        GradientButton(
          text: 'Send Reset Link',
          onPressed: controller.forgotPassword,
          gradientColors: [Colors.purple[600]!, Colors.pink[600]!],
        ),

        SizedBox(height: 24.h),

        // Back to Sign In Link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: 'Remember your password? ',
              color: Colors.grey[600],
              fontSize: 14,
            ),
            GestureDetector(
              onTap: () => controller.setCurrentView('signin'),
              child: CustomText(
                text: 'Sign In',
                color: Colors.blue[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

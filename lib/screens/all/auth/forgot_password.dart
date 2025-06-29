import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petvax/app/widgets/custom_text.dart';

import '../../../app/widgets/custom_input.dart';
import '../../../app/widgets/gradient_button.dart';
import 'auth_cb.dart';

class ForgotPasswordView extends StatelessWidget {
  final AuthController controller = Get.find<AuthController>();

  ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child:
            controller.forgotPasswordStep.value == 'email'
                ? _buildEmailStep()
                : _buildOtpStep(),
      ),
    );
  }

  Widget _buildEmailStep() {
    return Column(
      key: const ValueKey('email_step'),
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
                  text: "We'll send you a reset code",
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
              'Enter your email address and we\'ll send you a verification code to reset your password.',
          fontSize: 14,
          color: Colors.grey[600],
          align: TextAlign.center,
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

        SizedBox(height: 20.h),

        // Send Reset Code Button
        Obx(
          () => GradientButton(
            text: controller.isLoading.value ? 'Sending...' : 'Send Reset Code',
            onPressed:
                controller.isLoading.value ? () {} : controller.forgotPassword,
            gradientColors: [Colors.purple[600]!, Colors.pink[600]!],
          ),
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

  Widget _buildOtpStep() {
    return Column(
      key: const ValueKey('otp_step'),
      children: [
        SizedBox(height: 16.h),

        // Header with back button
        Row(
          children: [
            IconButton(
              onPressed: () => controller.backToEmailStep(),
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
                  text: 'Verify & Reset',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900],
                ),
                CustomText(
                  text: 'Enter code and new password',
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 40.h),

        // OTP Icon
        Container(
          width: 80.w,
          height: 80.h,
          decoration: BoxDecoration(
            color: Colors.green[100],
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.security, color: Colors.green[600], size: 32.sp),
        ),

        SizedBox(height: 24.h),

        Obx(
          () => CustomText(
            text: 'We sent a verification code to\n${controller.email.value}',
            fontSize: 14,
            color: Colors.grey[600],
            align: TextAlign.center,
          ),
        ),

        SizedBox(height: 32.h),

        // OTP Boxes
        _buildOtpBoxes(),

        SizedBox(height: 24.h),

        // New Password Field
        Obx(
          () => CustomInputField(
            icon: Icons.lock_outline,
            placeholder: 'New Password',
            value: controller.newPassword.value,
            onChanged: controller.updateNewPassword,
            isPassword: true,
          ),
        ),

        SizedBox(height: 0.h),

        // Confirm Password Field
        Obx(
          () => CustomInputField(
            icon: Icons.lock_outline,
            placeholder: 'Confirm Password',
            value: controller.confirmNewPassword.value,
            onChanged: controller.updateConfirmPassword,
            isPassword: true,
          ),
        ),

        SizedBox(height: 10.h),

        // Reset Password Button
        Obx(
          () => GradientButton(
            text:
                controller.isLoading.value ? 'Resetting...' : 'Reset Password',
            onPressed:
                controller.isLoading.value ? () {} : controller.resetPassword,
            gradientColors: [Colors.purple[600]!, Colors.pink[600]!],
          ),
        ),

        SizedBox(height: 24.h),

        // Resend Code Link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: "Didn't receive the code? ",
              color: Colors.grey[600],
              fontSize: 14,
            ),
            GestureDetector(
              onTap: controller.isLoading.value ? null : controller.resendOtp,
              child: CustomText(
                text: 'Resend',
                color: Colors.blue[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        // Change Email Link
        GestureDetector(
          onTap: () => controller.backToEmailStep(),
          child: CustomText(
            text: 'Change email address',
            color: Colors.grey[500],
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        return Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  controller.otpBoxes[index].isNotEmpty
                      ? Colors.purple[600]!
                      : Colors.grey[300]!,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8.r),
            color:
                controller.otpBoxes[index].isNotEmpty
                    ? Colors.purple[50]
                    : Colors.white,
          ),
          child: TextField(
            controller: controller.otpControllers[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[900],
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: '',
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              controller.updateOtpBox(index, value);
              if (value.isNotEmpty && index < 5) {
                FocusScope.of(Get.context!).nextFocus();
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(Get.context!).previousFocus();
              }
            },
          ),
        );
      }),
    );
  }
}

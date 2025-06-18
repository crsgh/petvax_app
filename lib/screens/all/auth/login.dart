import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petvax/app/components/logo.dart';
import 'package:petvax/app/constants/colors.dart';
import 'package:petvax/app/widgets/custom_text.dart';
import '../../../app/widgets/custom_input.dart';
import '../../../app/widgets/gradient_button.dart';
import 'auth_cb.dart';
// Import your components here

class SignInView extends StatelessWidget {
  final AuthController controller = Get.find<AuthController>();

  SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.h),
        PetVaxLogo(),

        // Header
        // CustomText(
        //   text: 'Welcome Back',
        //
        //   fontSize: 30,
        //   fontWeight: FontWeight.bold,
        //   color: Colors.grey[900],
        // ),
        SizedBox(height: 10.h),
        CustomText(
          text: 'Sign in to your account',
          fontSize: 18,
          color: Colors.grey[600],
        ),
        SizedBox(height: 30.h),

        // Form Fields
        Obx(
          () => CustomInputField(
            icon: Icons.email_outlined,
            placeholder: 'Email address',
            value: controller.email.value,
            onChanged: controller.updateEmail,
            keyboardType: TextInputType.emailAddress,
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
            marginBottom: 8.h,
          ),
        ),

        // Forgot Password
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => controller.setCurrentView('forgot'),
            child: CustomText(
              text: 'Forgot Password?',

              color: Colors.blue[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        SizedBox(height: 5.h),

        // Sign In Button
        GradientButton(
          text: 'Sign In',
          onPressed: controller.signIn,
          gradientColors: AppColors.primaryGradient,
        ),

        SizedBox(height: 24.h),

        // Sign Up Link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: "Don't have an account? ",
              color: Colors.grey[600],
              fontSize: 14,
            ),
            GestureDetector(
              onTap: () => controller.setCurrentView('signup'),
              child: CustomText(
                text: 'Sign Up',

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

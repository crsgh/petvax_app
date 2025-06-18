import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petvax/app/widgets/custom_text.dart';
import 'package:petvax/screens/all/auth/signup.dart';

import '../../../app/components/social_login_buttons.dart';
import 'auth_cb.dart';
import 'forgot_password.dart';
import 'login.dart';
// Import your components here

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.put(AuthController());

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[50]!, Colors.white, Colors.purple[50]!],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),

                // Main Auth Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Obx(() {
                    switch (controller.currentView.value) {
                      case 'signup':
                        return SignUpView();
                      case 'forgot':
                        return ForgotPasswordView();
                      default:
                        return SignInView();
                    }
                  }),
                ),

                SizedBox(height: 24.h),

                // Social Login Section
                Obx(
                  () =>
                      controller.currentView.value == 'signin'
                          ? Column(
                            children: [
                              // Divider
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(color: Colors.grey[300]),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                    ),
                                    child: CustomText(
                                      text: 'Or continue with',
                                      color: Colors.grey[500],
                                      fontSize: 14,
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(color: Colors.grey[300]),
                                  ),
                                ],
                              ),

                              SizedBox(height: 24.h),

                              // Social Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: SocialLoginButton(
                                      text: 'Google',

                                      onPressed: controller.signInWithGoogle,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: SocialLoginButton(
                                      text: 'Facebook',
                                      icon: Icon(
                                        Icons.facebook,
                                        color: Colors.blue[600],
                                        size: 20.sp,
                                      ),
                                      onPressed: controller.signInWithFacebook,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                          : const SizedBox.shrink(),
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

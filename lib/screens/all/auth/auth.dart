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
        height: Get.height,
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
            child: Container(
              height: Get.height -50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  SizedBox(height: 12.h),
                  // Social Login Section
                  Obx(
                    () =>
                        controller.currentView.value == 'signin'
                            ? Column(
                              children: [
                                // Divider,
                                SizedBox(height: 24.2),
                              ],
                            )
                            : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petvax/screens/all/splash/splash_cb.dart';

import '../../../app/widgets/custom_text.dart';

class Splash extends GetView<SplashController> {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Obx(
            () => switch (controller.view.value) {
              SplashView.loading => _loading(),
              SplashView.loaded => _loaded(),
              SplashView.error => _error(),
            },
          ),
        ),
      ),
    );
  }

  _loading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/img/logo.png', width: 150.h, height: 150.h),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => CustomText(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                text:
                    "${controller.loadingText.value} ${controller.dots.value}",
              ),
            ),
          ],
        ),
        SizedBox(height: 50.h),
      ],
    );
  }

  _loaded() {
    return CustomText(text: "App Loaded");
  }

  _error() {
    return CustomText(text: "App Error");
  }
}

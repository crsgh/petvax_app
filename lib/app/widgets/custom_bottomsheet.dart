import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomBottomsheet {
  double? height;
  double? width;
  EdgeInsets? padding;
  Widget child;
  bool? dismissable;
  CustomBottomsheet({
    this.height,
    this.width,
    this.padding,
    this.dismissable,
    required this.child,
  });
  show(whenComplete) {
    showModalBottomSheet(
      isDismissible: dismissable ?? true,
      backgroundColor: Colors.transparent,
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: padding ?? EdgeInsets.all(16.h),
            height: height ?? 200.h,
            width: width ?? Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.r),
                topRight: Radius.circular(15.r),
              ),
              color: Colors.white,
            ),
            child: child,
          ),
        );
      },
    ).whenComplete(whenComplete);
  }

  showExpanding(whenComplete) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: padding ?? EdgeInsets.all(16.h),
          width: width ?? Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.r),
              topRight: Radius.circular(15.r),
            ),
            color: Colors.white,
          ),
          child: child,
        ),
      ),
      isDismissible: dismissable ?? true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    ).whenComplete(whenComplete);
  }

  floating({whenComplete}) {
    showModalBottomSheet(
      isDismissible: dismissable ?? true,
      backgroundColor: Colors.transparent,
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Wrap(
            children: [
              Container(
                padding: padding ?? EdgeInsets.all(16.h),
                margin: padding ?? EdgeInsets.all(16.h),
                height: height,
                width: width ?? Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Colors.white,
                ),
                child: child,
              ),
            ],
          ),
        );
      },
    );
  }
}

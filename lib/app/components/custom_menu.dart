import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petvax/app/constants/colors.dart';

class CustomMenu extends StatelessWidget {
  const CustomMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularMenu(
      radius: 90,
      toggleButtonSize: 30,

      items: [
        CircularMenuItem(
          color: AppColors.primary,
          iconSize: 25,
          icon: Icons.home,
          onTap: () {
            // Get.offUntil(, predicate)
            Get.toNamed('/home');
          },
        ),
        CircularMenuItem(
          color: AppColors.primary,
          iconSize: 25,
          icon: Icons.calendar_month_rounded,
          onTap: () {
            Get.toNamed('/appointments');
          },
        ),
        CircularMenuItem(
          iconSize: 25,
          icon: Icons.medical_services,
          color: AppColors.primary,
          onTap: () {
            Get.toNamed('/rule-base');
          },
        ),
        CircularMenuItem(
          iconSize: 25,
          icon: Icons.pets,
          color: AppColors.primary,
          onTap: () {
            Get.toNamed('/pets');
          },
        ),
        CircularMenuItem(
          iconSize: 25,
          icon: Icons.person,
          color: AppColors.primary,
          onTap: () {
            Get.toNamed('/profile');

            //Get.toNamed('/profile');
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petvax/app/widgets/custom_text.dart';

import 'cb/profile_cb.dart';

class PetProfile extends GetView<PetProfileController> {
  const PetProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => switch (controller.view.value) {
            PetProfileView.loading => _loading(),
            PetProfileView.loaded => _loaded(),
            PetProfileView.error => _error(),
          },
        ),
      ),
    );
  }

  _loaded() {
    return Column(children: []);
  }

  _loading() {
    return const Center(child: Text('Clinics Loaded'));
  }

  _error() {
    return Center(
      child: const Center(child: CustomText(text: 'Error loading clinics')),
    );
  }
}

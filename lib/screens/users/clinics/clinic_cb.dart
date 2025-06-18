import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:petvax/app/mixins/snackbar.dart';
import 'package:petvax/screens/all/utility/settings_controller.dart';

import '../../../app/models/clinic_model.dart';

enum ClinicsView { loading, loaded, error }

class ClinicsController extends GetxController with SnackBarMixin {
  var view = ClinicsView.loading.obs;
  var searchQuery = TextEditingController();
  var isTagSearchEnabled = false.obs;
  Settings settings = Get.find<Settings>();
  var currentSort = "Nearest First".obs;
  RxBool showOpenOnly = false.obs;
  RxList<Clinic> shownClinics = <Clinic>[].obs;

  @override
  void onInit() async {
    if (Get.arguments != null) searchQuery.text = Get.arguments['search_param'];
    shownClinics(settings.clinics);
    view(ClinicsView.loaded);
    super.onInit();
  }

  searchClinics(query) {
    if (query.isEmpty) {
      shownClinics.value = settings.clinics;
      return;
    }

    query = query.toLowerCase();
    shownClinics.value =
        settings.clinics.where((clinic) {
          final name = clinic.name.toLowerCase();
          final address = clinic.location.toLowerCase();

          if (isTagSearchEnabled.value) {
            return clinic.tags.any((tag) => tag.toLowerCase().contains(query));
          }

          return name.contains(query) || address.contains(query);
        }).toList();
  }

  sortClinics(value) {
    if (value == "Nearest First") {
      shownClinics.value = List.from(shownClinics)..sort((a, b) {
        var distanceA = Geolocator.distanceBetween(
          settings.position!.latitude,
          settings.position!.longitude,
          a.latitude,
          a.longitude,
        );
        var distanceB = Geolocator.distanceBetween(
          settings.position!.latitude,
          settings.position!.longitude,
          b.latitude,
          b.longitude,
        );
        return distanceA.compareTo(distanceB);
      });
    } else if (value == "A-Z") {
      shownClinics.value = List.from(shownClinics)..sort((a, b) {
        var name = a.name.toLowerCase();
        var name2 = b.name.toLowerCase();
        return name.compareTo(name2);
      });
    } else if (value == "Z-A") {
      shownClinics.value = List.from(shownClinics)..sort((a, b) {
        var name = a.name.toLowerCase();
        var name2 = b.name.toLowerCase();
        return name2.compareTo(name);
      });
    }
  }

  filterOpenClinics() {
    if (!showOpenOnly.value) {
      shownClinics.value = settings.clinics;
      return;
    }

    final now = DateTime.now();
    final weekDays = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    final currentDay =
        weekDays[now.weekday - 1]; // Get current day abbreviation
    final currentTime = now.hour * 60 + now.minute; // Convert to minutes
    print(shownClinics.first.operationDays);
    shownClinics.value =
        settings.clinics.where((clinic) {
          // Check if clinic operates on current day
          if (!clinic.operationDays.contains(currentDay)) return false;

          // Convert clinic hours to minutes for comparison
          final openingHour = int.parse(clinic.openingTime.split(':')[0]);
          final openingMinute = int.parse(clinic.openingTime.split(':')[1]);
          final openingTimeInMinutes = openingHour * 60 + openingMinute;

          final closingHour = int.parse(clinic.closingTime.split(':')[0]);
          final closingMinute = int.parse(clinic.closingTime.split(':')[1]);
          final closingTimeInMinutes = closingHour * 60 + closingMinute;

          // Check if current time is within operating hours
          return currentTime >= openingTimeInMinutes &&
              currentTime <= closingTimeInMinutes;
        }).toList();
  }
}

class ClinicsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClinicsController>(() => ClinicsController());
  }
}

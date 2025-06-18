import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:petvax/app/mixins/snackbar.dart';
import 'package:petvax/screens/all/utility/settings_controller.dart';

enum DashboardView { loading, loaded, error }

class DashboardController extends GetxController with SnackBarMixin {
  Settings settings = Get.find<Settings>();
  var view = DashboardView.loading.obs;
  var searchQuery = TextEditingController();
  Rx<bool> isTyped = false.obs;
  Position? position;

  @override
  void onInit() async {
    position = await determinePosition();
    view(DashboardView.loaded);
    super.onInit();
  }

  void updateSearchQuery(String query) {
    searchQuery.text = query;
    if (!isTyped.value) {
      isTyped(true);
      Future.delayed(Duration(seconds: 2)).then((onValue) {
        isTyped(false);
        Get.toNamed('/clinics', arguments: {'search_param': searchQuery.value});
      });
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getLastKnownPosition() ??
        await Geolocator.getCurrentPosition();
  }
}

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
  }
}

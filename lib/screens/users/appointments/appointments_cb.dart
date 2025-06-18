import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:petvax/app/mixins/snackbar.dart';
import 'package:petvax/app/models/appointment_model.dart';
import 'package:petvax/screens/all/utility/settings_controller.dart';

enum AppointmentsView { loading, loaded, error }

class AppointmentsController extends GetxController with SnackBarMixin {
  Settings settings = Get.find<Settings>();
  var view = AppointmentsView.loading.obs;
  var searchQuery = TextEditingController();
  // Selected filters for appointments
  final selectedFilter = "".obs;
  RxList<Appointment> showAppointment = <Appointment>[].obs;

  // Filter appointments based on selected status
  filterAppointments() {
    if (selectedFilter.isEmpty) {
      return settings.appointments;
    }
    print('filter ${selectedFilter.value}');
    showAppointment.value =
        settings.appointments.where((appointment) {
          switch (selectedFilter.value.toLowerCase()) {
            case 'pending':
              return appointment.status.toLowerCase() == 'pending';
            case 'cancelled':
              return appointment.status.toLowerCase() == 'cancelled';
            case 'declined':
              return appointment.status.toLowerCase() == 'declined';
            case 'completed':
              return appointment.status.toLowerCase() == 'completed';
            case 'confirmed':
              return appointment.status.toLowerCase() == 'confirmed';
            default:
              return true;
          }
        }).toList();
  }

  @override
  void onInit() async {
    showAppointment.value = settings.appointments.value;
    view(AppointmentsView.loaded);
    super.onInit();
  }
}

class AppointmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppointmentsController>(() => AppointmentsController());
  }
}

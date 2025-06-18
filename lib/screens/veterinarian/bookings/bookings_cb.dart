// Sort Option Model
import 'package:get/get.dart';
import 'package:petvax/app/models/appointment_model.dart';
import 'package:petvax/screens/all/utility/settings_controller.dart';

class SortOption {
  final String value;
  final String label;

  SortOption({required this.value, required this.label});
}

// GetX Controller
class AppointmentsController extends GetxController {
  final RxList<Appointment> appointments = <Appointment>[].obs;
  final RxString sortBy = 'date'.obs;
  final RxString sortOrder = 'desc'.obs;
  final RxBool showSortMenu = false.obs;
  final settings = Get.find<Settings>();

  final List<SortOption> sortOptions = [
    SortOption(value: 'date', label: 'Date'),
    SortOption(value: 'clinicName', label: 'Clinic Name'),
    SortOption(value: 'petName', label: 'Pet Name'),
    SortOption(value: 'amount', label: 'Amount'),
    SortOption(value: 'status', label: 'Status'),
  ];

  List<Appointment> get sortedAppointments {
    List<Appointment> sorted =
        settings.appointments
            .where(
              (e) => !["completed", "declined", "cancelled"].contains(e.status),
            )
            .toList();

    sorted.sort((a, b) {
      dynamic aValue = _getSortValue(a, sortBy.value);
      dynamic bValue = _getSortValue(b, sortBy.value);

      if (sortOrder.value == 'asc') {
        return aValue.compareTo(bValue);
      } else {
        return bValue.compareTo(aValue);
      }
    });

    return sorted;
  }

  dynamic _getSortValue(Appointment appointment, String sortField) {
    switch (sortField) {
      case 'date':
        return DateTime.parse(appointment.date);
      case 'clinicName':
        return appointment.clinicName.toLowerCase();
      case 'petName':
        return appointment.petName.toLowerCase();
      case 'amount':
        return double.parse(appointment.amount);
      case 'status':
        return appointment.status.toLowerCase();
      default:
        return appointment.date;
    }
  }

  void handleSort(String option) {
    if (sortBy.value == option) {
      sortOrder.value = sortOrder.value == 'asc' ? 'desc' : 'asc';
    } else {
      sortBy.value = option;
      sortOrder.value = 'asc';
    }
    showSortMenu.value = false;
  }

  void toggleSortMenu() {
    showSortMenu.value = !showSortMenu.value;
  }

  String getCurrentSortLabel() {
    return sortOptions.firstWhere((opt) => opt.value == sortBy.value).label;
  }
}

class VetBookingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppointmentsController());
  }
}

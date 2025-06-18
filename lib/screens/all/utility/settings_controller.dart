import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:petvax/app/constants/strings.dart';
import 'package:petvax/app/mixins/snackbar.dart';
import 'package:petvax/app/models/appointment_model.dart';
import 'package:petvax/app/models/clinic_model.dart';
import 'package:petvax/app/models/notification_model.dart';
import 'package:petvax/app/models/pet_model.dart';
import 'package:petvax/app/models/user_model.dart';

class Settings extends GetxController with SnackBarMixin {
  GetConnect connect = GetConnect();
  UserModel? user;
  RxList<Pet> pets = <Pet>[].obs;
  RxList<Clinic> clinics = <Clinic>[].obs;
  RxList<Appointment> appointments = <Appointment>[].obs;
  RxList<NotificationItem> notifications = <NotificationItem>[].obs;
  Position? position;
  Timer? _timer;

  @override
  onInit() async {
    connect.baseUrl = AppStrings.baseUrl;
    position = await determinePosition();
    // _timer = Timer.periodic(Duration(seconds: 15), (tick) async {
    //   fetchNotifications(id: user!.id);
    //   position = await determinePosition();
    // });
    super.onInit();
  }

  fetchAll({id}) async {
    id ??= user!.id;
    await fetchPets();
    await fetchAppointments();
    await fetchClinics();
    await fetchNotifications(id: id);
  }

  fetchPets({id}) async {
    id ??= user!.id;
    var res = await connect.get('pet/owner/$id');
    if (res.status.hasError) {
      showErrorSnackbar("Failed to fetch pets: ${res.statusText}");
    } else {
      var data = res.body['data'] as List;
      pets.value = data.map((e) => Pet.fromJson(e)).toList();
    }
  }

  fetchAppointments({id, limit = 3}) async {
    id ??= user!.id;
    var res = await connect.get('booking/user/$id?limit=$limit');
    if (res.status.hasError) {
      showErrorSnackbar("Failed to fetch appointments: ${res.statusText}");
    } else {
      var data = res.body['data'] as List;
      appointments.value = data.map((e) => Appointment.fromJson(e)).toList();
    }
  }

  fetchClinics() async {
    var res = await connect.get('clinic/all');
    if (res.status.hasError) {
      showErrorSnackbar("Failed to fetch clinics: ${res.statusText}");
    } else {
      var data = res.body['data'] as List;
      clinics.value = data.map((e) => Clinic.fromJson(e)).toList();
    }
  }

  fetchNotifications({id}) async {
    id ??= user!.id;
    var res = await connect.get('notification/user/$id');
    print("notif: ${res.body}");
    if (res.status.hasError) {
      showErrorSnackbar("Failed to fetch notifications: ${res.statusText}");
    } else {
      var data = res.body['data'] as List;
      notifications.value =
          data.map((e) {
            if (e['type'] == 'settings') {
              e['icon'] = 'gear';
              e['iconColor'] = 'blue';
            } else if (e['type'] == 'booking') {
              e['icon'] = 'calendar';
              e['iconColor'] =
                  e['title'].toString().toLowerCase().contains('decline')
                      ? 'red'
                      : 'green';
            }

            return NotificationItem.fromJson(e);
          }).toList();
    }
  }

  Future<Position> determinePosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return Future.error('Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied &&
        await Geolocator.requestPermission() == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions permanently denied');
    }

    return await Geolocator.getLastKnownPosition() ??
        await Geolocator.getCurrentPosition();
  }
}

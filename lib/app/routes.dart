import 'package:get/get.dart';
import 'package:petvax/screens/all/auth/auth.dart';
import 'package:petvax/screens/all/auth/auth_cb.dart';
import 'package:petvax/screens/all/notification/notification.dart';
import 'package:petvax/screens/all/notification/notification_cb.dart';
import 'package:petvax/screens/all/profile/profile.dart';
import 'package:petvax/screens/all/profile/profile_cb.dart';
import 'package:petvax/screens/all/splash/splash.dart';
import 'package:petvax/screens/all/splash/splash_cb.dart';
import 'package:petvax/screens/users/appointments/appointments.dart';
import 'package:petvax/screens/users/appointments/appointments_cb.dart';
import 'package:petvax/screens/users/clinics/clinic_cb.dart';
import 'package:petvax/screens/users/clinics/services.dart';
import 'package:petvax/screens/users/clinics/services_cb.dart';
import 'package:petvax/screens/users/dashboard/dashboard.dart';
import 'package:petvax/screens/users/dashboard/dashboard_cb.dart';
import 'package:petvax/screens/users/pets/add_pets.dart';
import 'package:petvax/screens/users/pets/cb/pets_cb.dart';
import 'package:petvax/screens/users/pets/cb/view_pet_cb.dart';
import 'package:petvax/screens/users/pets/view_pet.dart';
import 'package:petvax/screens/users/rule_base/rule_base.dart';
import 'package:petvax/screens/veterinarian/bookings/bookings.dart';
import 'package:petvax/screens/veterinarian/bookings/bookings_cb.dart';

import '../screens/users/clinics/clinics.dart';
import '../screens/users/pets/cb/add_pet_cb.dart';
import '../screens/users/pets/pets.dart';

appRoutes() => [
  GetPage(name: '/auth', page: () => AuthScreen(), binding: AuthBinding()),
  GetPage(name: '/splash', page: () => Splash(), binding: SplashBinding()),
  GetPage(
    name: '/home',
    page: () => DashboardScreen(),
    binding: DashboardBinding(),
  ),
  GetPage(
    name: '/vet-home',
    page: () => VetBookingsScreen(),
    binding: VetBookingsBinding(),
  ),
  GetPage(name: '/pets', page: () => Pets(), binding: PetsBinding()),
  GetPage(
    name: '/add-pet',
    page: () => AddPetScreen(),
    binding: AddPetBinding(),
  ),
  GetPage(name: '/clinics', page: () => Clinics(), binding: ClinicsBinding()),
  GetPage(
    name: '/appointments',
    page: () => Appointments(),
    binding: AppointmentsBinding(),
  ),
  GetPage(
    name: '/services',
    page: () => Services(),
    binding: ServicesBinding(),
  ),
  GetPage(
    name: '/profile',
    page: () => PetOwnerProfileScreen(),
    binding: PetOwnerBinding(),
  ),
  GetPage(name: '/view-pet', page: () => ViewPet(), binding: ViewPetBinding()),
  GetPage(
    name: '/rule-base',
    page: () => RuleBase(),
    binding: RuleBaseBinding(),
  ),
  GetPage(
    name: '/notifications',
    page: () => NotificationScreen(),
    binding: NotificationBinding(),
  ),
];

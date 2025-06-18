import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:petvax/app/constants/colors.dart';
import 'package:petvax/app/constants/strings.dart';
import 'package:petvax/app/mixins/snackbar.dart';
import 'package:petvax/app/models/clinic_model.dart';
import 'package:petvax/app/widgets/gradient_button.dart';
import 'package:petvax/screens/all/utility/settings_controller.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../app/models/pet_model.dart';
import '../../../app/models/services.dart';

enum ServicesView { loading, loaded, error }

class ServicesController extends GetxController with SnackBarMixin {
  var view = ServicesView.loading.obs;
  Settings settings = Get.find<Settings>();
  GetConnect connect = GetConnect();
  RxBool termsVisible = true.obs;
  RxString selectedPet = ''.obs;
  RxInt activeIndex = 0.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxInt selectedHour = 8.obs;
  RxString selectedAmPm = "AM".obs;
  RxBool isDateAvailable = true.obs;
  RxList<Map<String, dynamic>> availableSlots = <Map<String, dynamic>>[].obs;
  RxList<String> shownTime = <String>[].obs;
  var selectedPaymentMethod = "gcash".obs;
  Rx<String?> imagePath = Rx<String?>(null);
  RxString referenceNumber = ''.obs;
  RxBool isHomeService = false.obs;
  RxString selectedAddress = ''.obs;
  RxDouble selectedLat = 0.0.obs;
  RxDouble selectedLng = 0.0.obs;
  RxString selectedTime = ''.obs;

  Clinic? clinic;
  RxList<ServicesModel> services = <ServicesModel>[].obs;
  List<Pet> pets = [];
  @override
  void onInit() async {
    clinic = Get.arguments;
    connect.baseUrl = AppStrings.baseUrl;
    await loadServices(clinicId: clinic!.id);

    await loadPets(owner: settings.user!.id);

    view(ServicesView.loaded);
    super.onInit();
  }

  loadServices({clinicId}) async {
    var res = await connect.get('service/clinic/$clinicId');
    if (res.status.hasError) {
      showErrorSnackbar("Failed to fetch services: ${res.statusText}");
    } else {
      var data = res.body['data'] as List;
      services.value = data.map((e) => ServicesModel.fromJson(e)).toList();
    }
  }

  loadServicesTime(id) async {
    availableSlots.clear();
    shownTime.clear();
    var res = await connect.post('check-schedule', {
      "clinic_id": clinic!.id,
      "service_id": id,
      "day": DateFormat('EEEE').format(selectedDate.value).toLowerCase(),
    });

    print(res.body['data']);

    var data =
        res.body['data'].runtimeType == String
            ? jsonDecode(res.body['data'] ?? "[]")
            : res.body['data'] ?? [];

    for (var slot in data) {
      var splitedSlot = slot.split(" ");
      String time = splitedSlot[0];
      bool isAM = splitedSlot[1] == "AM";
      Map<String, dynamic> newSlot = {'time': time, 'isAM': isAM};

      availableSlots.add(newSlot);
    }

    showTime(isAm: selectedAmPm.value == "AM");
  }

  loadPets({owner}) async {
    var res = await connect.get('pet/owner/$owner');
    pets = res.body['data'].map<Pet>((e) => Pet.fromJson(e)).toList();
    if (pets.isNotEmpty) selectedPet(pets.map((e) => e.name).toList()[0]);
  }

  bookNow(id, amount) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    var body = {
      "clinic_id": clinic!.id,
      "service_id": id,
      "pet_id":
          pets
              .firstWhere(
                (e) => e.name.toLowerCase() == selectedPet.value.toLowerCase(),
              )
              .id,
      "client_id": settings.user!.id,
      "staff_id": null,
      "appointment_datetime":
          DateTime(
            selectedDate.value.year,
            selectedDate.value.month,
            selectedDate.value.day,
            selectedAmPm.value == "PM"
                ? selectedHour.value + 12
                : selectedHour.value,
          ).toIso8601String(),
      "notes": "any",
      "total_amount": amount,
      "status": "pending",
      "payment_method": selectedPaymentMethod,
      "payment_reference": referenceNumber.value,
    };

    // Add payment proof file if exists
    if (imagePath.value != null) {
      final file = File(imagePath.value!);
      body['payment_proof'] = MultipartFile(
        file,
        filename: 'payment_proof.jpg',
      );
    }

    var res = await connect.post('booking/add', FormData(body));
    Get.back();

    if (res.body['status'] == 'success') {
      final bookingId = res.body['data']['id'];

      if (isHomeService.value) {
        try {
          var r = await connect.post('homeservice/add', {
            "booking_id": bookingId,
            "latitude": selectedLat.value,
            "longitude": selectedLng.value,
            "address": selectedAddress.value,
          });
          print("home service: ${r.body}");
        } catch (e) {
          showErrorSnackbar("Failed to add home service details");
          return;
        }
      }

      showSuccessSnackBar("Booking has been scheduled!");
    } else {
      showErrorSnackbar("Something went wrong, try again or contact admin!");
    }
  }

  book(id, price, hs) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    // Reset all input values to default
    //selectedPet.value = pets.isNotEmpty ? pets[0].name : '';
    selectedDate.value = DateTime.now();
    isDateAvailable.value = true;
    availableSlots.clear();
    shownTime.clear();
    selectedPaymentMethod.value = "gcash";
    imagePath.value = null;
    referenceNumber.value = '';

    await loadServicesTime(id);
    Get.back();
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Book Appointment",
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 5.h),
            Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primary),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      "Select your preferred date and time for the appointment",
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            Row(
              children: [
                Icon(Icons.access_time, color: AppColors.primary, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  "Select Time",
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Obx(
                  () => Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 0.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value:
                              selectedTime.value == ""
                                  ? (shownTime.isNotEmpty ? shownTime[0] : null)
                                  : selectedTime.value,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.primary,
                          ),
                          items:
                              shownTime
                                  .map(
                                    (time) => DropdownMenuItem(
                                      value: time,
                                      child: Text(
                                        time,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) async {
                            if (value != null) {
                              selectedTime.value = value;
                              await checkSlots();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 0.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Obx(
                      () => DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedAmPm.value,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.primary,
                          ),
                          items:
                              ['AM', 'PM']
                                  .map(
                                    (period) => DropdownMenuItem(
                                      value: period,
                                      child: Text(
                                        period,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) async {
                            showTime(isAm: value == "AM");
                            selectedTime.value = '';
                            selectedAmPm.value = value!;
                            await checkSlots();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  "Select Date",
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Obx(
                () => TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(const Duration(days: 120)),
                  focusedDay: selectedDate.value,
                  selectedDayPredicate: (day) {
                    return isSameDay(selectedDate.value, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) async {
                    selectedDate.value = selectedDay;
                    await loadServicesTime(id);
                    await checkSlots();
                  },
                  calendarFormat: CalendarFormat.twoWeeks,
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    cellMargin: EdgeInsets.all(4),
                    cellPadding: EdgeInsets.all(4),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  daysOfWeekHeight: 45.h,
                  rowHeight: 45.h,
                ),
              ),
            ),

            SizedBox(height: 15.h),
            Obx(
              () => Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color:
                      isDateAvailable.value
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isDateAvailable.value ? Icons.check_circle : Icons.cancel,
                      color: isDateAvailable.value ? Colors.green : Colors.red,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      isDateAvailable.value
                          ? "Time slot available"
                          : "Time slot not available",
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        color:
                            isDateAvailable.value ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15.h),
            GradientButton(
              text: "Confirm Booking",
              onPressed: () {
                if (isDateAvailable.value) {
                  Get.bottomSheet(
                    Wrap(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.r),
                              topRight: Radius.circular(20.r),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Confirm Booking Details",
                                style: GoogleFonts.poppins(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 15.h),
                              hs
                                  ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Home Service",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Obx(
                                        () => Switch(
                                          value: isHomeService.value,
                                          onChanged: (bool value) {
                                            isHomeService(value);
                                          },
                                          activeColor: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  )
                                  : const SizedBox.shrink(),
                              SizedBox(height: 5.h),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.3),
                                  ),
                                ),
                                child: Obx(
                                  () => DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: selectedPet.value,
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: AppColors.primary,
                                      ),
                                      items:
                                          pets
                                              .map(
                                                (pet) => DropdownMenuItem(
                                                  value: pet.name,
                                                  child: Text(
                                                    pet.name,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                      onChanged: (value) {
                                        selectedPet.value = value!;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Container(
                                padding: EdgeInsets.all(15.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Date:",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        Text(
                                          DateFormat(
                                            'MMM dd, yyyy',
                                          ).format(selectedDate.value),
                                          style: GoogleFonts.poppins(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Time:",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        Text(
                                          "${selectedHour.value}:00 ${selectedAmPm.value}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "Payment Method",
                                style: GoogleFonts.poppins(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Obx(
                                () => Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: AppColors.primary.withOpacity(0.3),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: Radio(
                                          value: 'cash',
                                          groupValue:
                                              selectedPaymentMethod.value,
                                          onChanged: (value) {
                                            selectedPaymentMethod.value =
                                                value!;
                                          },
                                          activeColor: AppColors.primary,
                                        ),
                                        title: Text(
                                          'Cash',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        trailing: Icon(
                                          Icons.money,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      Divider(height: 1),
                                      ListTile(
                                        leading: Radio(
                                          value: 'gcash',
                                          groupValue:
                                              selectedPaymentMethod.value,
                                          onChanged: (value) {
                                            selectedPaymentMethod.value =
                                                value!;
                                          },
                                          activeColor: AppColors.primary,
                                        ),
                                        title: Text(
                                          'GCash',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        trailing: Icon(
                                          Icons.account_balance_wallet,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              GradientButton(
                                text: "Proceed with Booking",
                                onPressed: () {
                                  if (isHomeService.value) {
                                    Get.bottomSheet(
                                      Container(
                                        height: Get.height * 0.8,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20.r),
                                            topRight: Radius.circular(20.r),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10.h),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 20.w,
                                                vertical: 10.h,
                                              ),
                                              child: Text(
                                                "Select Location",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            Expanded(
                                              child: FlutterMap(
                                                options: MapOptions(
                                                  initialCenter: LatLng(
                                                    settings.position!.latitude,
                                                    settings
                                                        .position!
                                                        .longitude,
                                                  ), // Manila coordinates
                                                  initialZoom: 13.0,
                                                  onTap: (tapPosition, point) {
                                                    selectedLat.value =
                                                        point.latitude;
                                                    selectedLng.value =
                                                        point.longitude;
                                                    print(point);
                                                    // Reverse geocode the tapped location
                                                    selectedAddress.value =
                                                        "Selected location (${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)})";
                                                  },
                                                ),
                                                children: [
                                                  TileLayer(
                                                    urlTemplate:
                                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                    userAgentPackageName:
                                                        'com.example.app',
                                                  ),
                                                  Obx(
                                                    () => MarkerLayer(
                                                      markers: [
                                                        Marker(
                                                          width: 40.0,
                                                          height: 40.0,
                                                          point: LatLng(
                                                            selectedLat.value,
                                                            selectedLng.value,
                                                          ),
                                                          child: Icon(
                                                            Icons.location_pin,
                                                            color: Colors.red,
                                                            size: 40,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(16.w),
                                              child: GradientButton(
                                                text: "Confirm Location",
                                                onPressed: () {
                                                  if (selectedLat.value == 0 &&
                                                      selectedLng.value == 0) {}

                                                  if (selectedPaymentMethod
                                                          .value ==
                                                      "gcash") {
                                                    gcashPopUp(id, price);
                                                  } else {
                                                    bookNow(id, price);
                                                  }
                                                },
                                                gradientColors:
                                                    AppColors.primaryGradient,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                    );
                                  } else if (selectedPaymentMethod.value ==
                                      "gcash") {
                                    gcashPopUp(id, price);
                                  } else {
                                    bookNow(id, price);

                                    Get.back();
                                    Get.back();
                                  }
                                },
                                gradientColors: AppColors.primaryGradient,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                  );
                  //Get.back();
                } else {
                  showErrorSnackbar("Please select an available date and time");
                }
              },
              gradientColors: AppColors.primaryGradient,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  gcashPopUp(id, price) async {
    Get.bottomSheet(
      Wrap(
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "GCash Payment Details",
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20.h),
                TextField(
                  onChanged: (value) => referenceNumber.value = value,
                  decoration: InputDecoration(
                    labelText: 'Reference Number',
                    labelStyle: GoogleFonts.poppins(color: AppColors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: AppColors.primary.withOpacity(0.5),
                      ),
                    ),
                    hintText: 'Enter GCash reference number',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey),
                    prefixIcon: Icon(Icons.receipt, color: AppColors.primary),
                  ),
                ),
                SizedBox(height: 20.h),
                Obx(
                  () => Container(
                    height: 150.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child:
                        imagePath.value == null
                            ? Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8.r),
                                onTap: () async {
                                  var img = await ImagePicker().pickImage(
                                    source: ImageSource.gallery,
                                  );
                                  imagePath.value = img?.path;
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cloud_upload_outlined,
                                      size: 40.sp,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Upload Payment Screenshot',
                                      style: GoogleFonts.poppins(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Tap to select image',
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            : Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.file(
                                    File(imagePath.value!),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: IconButton(
                                    onPressed: () => imagePath.value = null,
                                    icon: Icon(Icons.close),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
                SizedBox(height: 20.h),
                GradientButton(
                  text: "Submit Payment",
                  onPressed: () {
                    if (referenceNumber.value.isEmpty) {
                      showErrorSnackbar("Please enter reference number");
                      return;
                    }
                    if (imagePath.value == null) {
                      showErrorSnackbar("Please upload payment screenshot");
                      return;
                    }
                    bookNow(id, price);
                    Get.back();
                  },
                  gradientColors: AppColors.primaryGradient,
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  checkSlots() async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    var res = await connect.post('check-slot', {
      "clinic_id": clinic!.id,
      "service_id": services[activeIndex.value].id,
      "time": "${selectedTime.value} $selectedAmPm",
      "date": DateFormat('yyyy-MM-dd').format(selectedDate.value),
    });

    Get.back();
    if (res.body['status'] == 'success') {
      isDateAvailable.value = res.body['available'];
    } else {
      isDateAvailable.value = false;
    }
  }

  showTime({isAm = true}) {
    shownTime.value =
        availableSlots
            .where((slot) => slot['isAM'] == isAm)
            .map((slot) => slot['time'] as String)
            .toList();
  }
}

class ServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServicesController>(() => ServicesController());
  }
}

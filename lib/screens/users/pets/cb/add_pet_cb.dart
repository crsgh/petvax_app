import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:petvax/app/constants/strings.dart';
import 'package:petvax/app/mixins/snackbar.dart';
import 'package:petvax/app/models/pet_model.dart';
import 'package:petvax/screens/all/utility/settings_controller.dart';

import '../../../../app/widgets/custom_text.dart';

enum AddPetView { loading, loaded, error }

class AddPetController extends GetxController with SnackBarMixin {
  var view = AddPetView.loading.obs;
  Settings settings = Get.find<Settings>();
  GetConnect connect = GetConnect();
  final GlobalKey<FormState> formKey = GlobalKey();
  Pet? pet;
  // Form data
  final name = "".obs;
  RxString specie = "".obs;
  RxString? breed;
  final weight = "".obs;

  @override
  void onInit() async {
    super.onInit();
    pet = Get.arguments;
    if (pet != null) {
      print(pet!.toJson());
      name.value = pet!.name;

      specie =
          settings.species
              .firstWhere(
                (e) =>
                    e.name.toLowerCase().toString() == pet!.species.toString(),
              )
              .name
              .toString()
              .obs;
      breed = pet!.breed?.obs;
      birthDate.value = pet!.birthDate;
      weight.value = pet!.weight.toString();
      selectedGender.value = pet!.gender ?? "Male";
      selectedImage(
        pet!.image != null
            ? await _downloadAndSaveImage(AppStrings.imageUrl + pet!.image!)
            : null,
      );
    }
    connect.baseUrl = AppStrings.baseUrl;
    // Add listeners for real-time validation
    name.listen((value) => validateName());
    specie.listen((value) => validateSpecies());
    breed?.listen((value) => validateBreed());
    weight.listen((value) => validateWeight());
    view(AddPetView.loaded);
  }

  // Observable variables
  final selectedImage = Rx<File?>(null);
  final birthDate = Rx<DateTime?>(null);
  final selectedGender = RxString('');
  final selectedOwnerId = RxString('');
  final selectedClinicId = RxString('');

  // Error states
  final nameError = RxString('');
  final speciesError = RxString('');
  final breedError = RxString('');
  final weightError = RxString('');
  final ownerError = RxString('');
  final clinicError = RxString('');
  final genderError = RxString('');
  final birthDateError = RxString('');

  // Loading state
  final isLoading = RxBool(false);

  // Dropdown data (replace with your actual data)
  final genderOptions = [
    {'value': 'male', 'label': 'Male'},
    {'value': 'female', 'label': 'Female'},
    {'value': 'unspecified', 'label': 'Unspecified'},
  ];

  final ownerOptions = [
    {'value': '1', 'label': 'John Doe'},
    {'value': '2', 'label': 'Jane Smith'},
    {'value': '3', 'label': 'Bob Johnson'},
  ];

  final clinicOptions = [
    {'value': '1', 'label': 'City Veterinary Clinic'},
    {'value': '2', 'label': 'Happy Pets Hospital'},
    {'value': '3', 'label': 'Animal Care Center'},
  ];

  // Image picker methods
  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  Future<File?> _downloadAndSaveImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        final dir = await getTemporaryDirectory();
        final filePath =
            '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.png';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        print('Failed to load image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  void removeImage() {
    selectedImage.value = null;
  }

  // Date picker
  Future<void> selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthDate.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      birthDate.value = picked;
    }
  }

  // Validation methods
  void validateName() {
    if (name.value.isEmpty) {
      nameError.value = 'Pet name is required';
    } else if (name.value.length > 255) {
      nameError.value = 'Name must be less than 255 characters';
    } else {
      nameError.value = '';
    }
  }

  void validateSpecies() {
    if (specie == null || specie!.isEmpty) {
      speciesError.value = 'Species is required';
    } else if (specie!.value.length > 255) {
      speciesError.value = 'Species must be less than 255 characters';
    } else {
      speciesError.value = '';
    }
  }

  void validateBreed() {
    if (breed == null) {
      breedError.value = 'You must select a breed';
    } else if (breed!.value.length > 255) {
      breedError.value = 'Breed must be less than 255 characters';
    }
  }

  void validateGender() {
    if (selectedGender.value.isEmpty) {
      genderError.value = 'Gender is required';
    } else if (![
      'male',
      'female',
      'other',
    ].contains(selectedGender.value.toLowerCase())) {
      genderError.value = 'Invalid gender';
    } else {
      genderError.value = '';
    }
  }

  void validateBirthDate() {
    if (birthDate.value == null) {
      birthDateError.value = 'Birth date is required';
    } else {
      try {
        final parsedDate = (birthDate.value);
        if (parsedDate!.isAfter(DateTime.now())) {
          birthDateError.value = 'Birth date cannot be in the future';
        } else {
          birthDateError.value = '';
        }
      } catch (e) {
        birthDateError.value = 'Invalid date format (use YYYY-MM-DD)';
      }
    }
  }

  void validateWeight() {
    if (weight.value.isNotEmpty) {
      final w = double.tryParse(weight.value);
      if (w == null || w < 0) {
        weightError.value = 'Weight must be a valid positive number';
      } else {
        weightError.value = '';
      }
    } else {
      weightError.value = '';
    }
  }

  void validateOwner() {
    if (selectedOwnerId.value.isEmpty) {
      ownerError.value = 'Owner is required';
    } else {
      ownerError.value = '';
    }
  }

  void validateClinic() {
    if (selectedClinicId.value.isEmpty) {
      clinicError.value = 'Clinic is required';
    } else {
      clinicError.value = '';
    }
  }

  String? validateForm() {
    nameError.value = '';
    speciesError.value = '';
    breedError.value = '';
    weightError.value = '';
    ownerError.value = '';
    clinicError.value = '';
    genderError.value = '';
    birthDateError.value = '';

    if (name.value.trim().isEmpty) {
      nameError.value = 'Name is required';
      return nameError.value;
    }

    if (specie.value.trim().isEmpty) {
      speciesError.value = 'Species is required';
      return speciesError.value;
    }

    if (breed!.value.trim().isEmpty) {
      breedError.value = 'Breed is required';
      return breedError.value;
    }

    if (weight.value.trim().isEmpty) {
      weightError.value = 'Weight is required';
      return weightError.value;
    }

    if (selectedGender.value.trim().isEmpty) {
      genderError.value = 'Gender is required';
      return genderError.value;
    }

    if (birthDate.value == null || birthDate.value.toString().isEmpty) {
      birthDateError.value = 'Birth date is required';
      return birthDateError.value;
    }

    return null; // No errors
  }

  // Submit form
  Future<void> submitForm() async {
    var errorMessage = validateForm();
    if (errorMessage != null) {
      Get.snackbar(
        "Validation Error",
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final formData = FormData({
        'name': name.value,
        'species': specie.value.toString().toLowerCase(),
        'breed': breed!.value.toString(),
        'birth_date': birthDate.value?.toIso8601String().split('T')[0],
        'clinic_id': 7,
        'owner_id': settings.user!.id,
        'weight': weight.value.isEmpty ? null : double.tryParse(weight.value),
        'gender': selectedGender.value.isEmpty ? null : selectedGender.value,
      });

      if (selectedImage.value != null) {
        formData.files.add(
          MapEntry(
            'image',
            MultipartFile(
              selectedImage.value!.path,
              filename: 'pet_${DateTime.now().millisecondsSinceEpoch}.jpg',
            ),
          ),
        );
      }

      var endPoint = pet != null ? 'pet/edit/${pet!.id}' : 'pet/add';

      var res = await GetConnect().post(
        "${AppStrings.baseUrl}$endPoint",
        formData,
        contentType: "multipart/form-data",
      );
      print(res.body);

      if (res.body['status'] != 'success') {
        throw Exception('Failed to add pet: ${res.body['message']}');
      } else {
        await settings.fetchPets();
        resetForm();
        showSuccessSnackBar(
          pet != null ? "Pet updated successfully!" : "Pet added successfully!",
        );
      }
      // Reset form

      //Get.back();
    } catch (e, ex) {
      print(ex);
      showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void resetForm() {
    name('');
    weight('');
    selectedImage.value = null;
    birthDate.value = null;
    selectedGender.value = '';
    selectedOwnerId.value = '';
    selectedClinicId.value = '';

    // Clear errors
    nameError.value = '';
    speciesError.value = '';
    breedError.value = '';
    weightError.value = '';
    ownerError.value = '';
    clinicError.value = '';
  }

  List<DropdownMenuItem<String>> getBreeds(value) {
    if (value == null || value.isEmpty) {
      return [];
    }
    var specie =
        settings.species
            .firstWhere(
              (e) => e.name == value,
              orElse: () => settings.species.first,
            )
            .id;

    var breeds =
        settings.breeds
            .where((item) => item.specieId.toString() == specie.toString())
            .toList();

    return breeds.map((item) {
      return DropdownMenuItem<String>(
        value: item.id.toString(),
        child: CustomText(text: item.name, fontSize: 14),
      );
    }).toList();
  }
}

class AddPetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPetController>(() => AddPetController());
  }
}

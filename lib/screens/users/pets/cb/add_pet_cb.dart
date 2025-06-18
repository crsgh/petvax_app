import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petvax/app/constants/strings.dart';
import 'package:petvax/app/mixins/snackbar.dart';
import 'package:petvax/app/models/pet_model.dart';
import 'package:petvax/screens/all/utility/settings_controller.dart';

enum AddPetView { loading, loaded, error }

class AddPetController extends GetxController with SnackBarMixin {
  var view = AddPetView.loading.obs;
  Settings settings = Get.find<Settings>();
  GetConnect connect = GetConnect();
  Pet? pet;
  // Form data
  final name = "".obs;
  final specie = "".obs;
  final breed = "".obs;
  final weight = "".obs;

  @override
  void onInit() async {
    super.onInit();
    pet = Get.arguments;
    if (pet != null) {
      name.value = pet!.name;
      specie.value = pet!.species;
      breed.value = pet!.breed ?? "";
      weight.value = pet!.weight.toString();
      selectedGender.value = pet!.gender ?? "Male";
      selectedImage.value =
          pet!.image != null
              ? await _downloadAndSaveImage(AppStrings.imageUrl + pet!.image!)
              : null;
    }
    connect.baseUrl = AppStrings.baseUrl;
    // Add listeners for real-time validation
    name.listen((value) => validateName());
    specie.listen((value) => validateSpecies());
    breed.listen((value) => validateBreed());
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
      final response = await connect.get(imageUrl);
      if (response.status.isOk) {
        // Create a temporary file
        final tempDir = Directory.systemTemp;
        final tempFile = File(
          '${tempDir.path}/temp_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );

        // Write image data to file
        await tempFile.writeAsBytes(response.bodyBytes as List<int>);
        print(tempFile.path);
        return tempFile;
      }
      return null;
    } catch (e) {
      print('Error downloading image: $e');
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
    if (specie.value.isEmpty) {
      speciesError.value = 'Species is required';
    } else if (specie.value.length > 255) {
      speciesError.value = 'Species must be less than 255 characters';
    } else {
      speciesError.value = '';
    }
  }

  void validateBreed() {
    if (breed.value.length > 255) {
      breedError.value = 'Breed must be less than 255 characters';
    } else {
      breedError.value = '';
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

  // Form validation
  bool validateForm() {
    validateName();
    validateSpecies();
    validateBreed();
    validateWeight();
    validateOwner();
    validateClinic();

    return nameError.value.isEmpty &&
        speciesError.value.isEmpty &&
        breedError.value.isEmpty &&
        weightError.value.isEmpty &&
        ownerError.value.isEmpty &&
        clinicError.value.isEmpty;
  }

  // Submit form
  Future<void> submitForm() async {
    // if (!validateForm()) return;

    isLoading.value = true;

    try {
      final formData = {
        'name': name.value,
        'species': specie.value,
        'breed': breed.value.isEmpty ? null : breed.value,
        'birth_date': birthDate.value?.toIso8601String().split('T')[0],
        'clinic_id': 7,
        'owner_id': settings.user!.id,
        'weight': weight.value.isEmpty ? null : double.tryParse(weight.value),
        'gender': selectedGender.value.isEmpty ? null : selectedGender.value,
      };
      var endPoint = pet != null ? 'pet/edit/${pet!.id}' : 'pet/add';
      var res = await connect.post(AppStrings.baseUrl + endPoint, formData);

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
    } catch (e) {
      showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void resetForm() {
    name('');
    specie('');
    breed('');
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
}

class AddPetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPetController>(() => AddPetController());
  }
}

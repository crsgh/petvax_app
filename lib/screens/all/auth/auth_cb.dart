import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petvax/app/constants/strings.dart';
import 'package:petvax/app/models/user_model.dart';
import 'package:petvax/app/services/storage_service.dart';
import 'package:petvax/app/widgets/custom_text.dart';

import '../../../app/components/pretty_alerts.dart';

enum AuthView { loading, login, signup, forgotPassword, error }

class AuthController extends GetxController {
  var view = AuthView.loading.obs;
  GetConnect connect = GetConnect();

  @override
  void onInit() async {
    connect.baseUrl = AppStrings.baseUrl;
    view(AuthView.login);
    super.onInit();
  }

  // Observable variables
  var currentView = 'signin'.obs; // 'signin', 'signup', 'forgot'
  var showPassword = false.obs;
  var showConfirmPassword = false.obs;
  var acceptTerms = false.obs;

  // Form data
  var email = 'admin@petvax.com'.obs;
  var password = 'asdasd123'.obs;
  var confirmPassword = ''.obs;
  var fullName = ''.obs;
  var phone = ''.obs;

  // Methods
  void setCurrentView(String view) {
    currentView.value = view;
  }

  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    showConfirmPassword.value = !showConfirmPassword.value;
  }

  void toggleTermsAcceptance() {
    acceptTerms.value = !acceptTerms.value;
  }

  void updateEmail(String value) {
    email.value = value;
  }

  void updatePassword(String value) {
    password.value = value;
  }

  void updateConfirmPassword(String value) {
    confirmPassword.value = value;
  }

  void updateFullName(String value) {
    fullName.value = value;
  }

  void updatePhone(String value) {
    phone.value = value;
  }

  // Authentication methods
  void signIn() async {
    showDialog(
      context: Get.context!,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );
    var res = await connect.post("login", {
      "email": email.value,
      "password": password.value,
    });
    Get.back();
    print(res.body);
    if (res.body['status']) {
      showDialog(
        context: Get.context!,
        builder:
            (_) => PopupDialog(
              isOpen: true,
              onPrimary: () async {
                UserModel user = UserModel.fromJson(res.body['user']);
                await Storage.saveUser(user: user);

                Get.offAndToNamed('/splash');
              },
              onClose: () {
                Get.back();
              },
              showCloseButton: false,
              title: "Success!",
              type: PopupDialogType.success,
              secondaryButton: null, // Hides back button
              primaryButton: "Got it",
              child: CustomText(text: "Operation completed successfully."),
            ),
      );
    } else {
      showDialog(
        context: Get.context!,
        builder:
            (_) => PopupDialog(
              isOpen: true,
              onClose: () {
                Get.back();
              },
              title: "Failed!",
              type: PopupDialogType.error,
              secondaryButton: null, // Hides back button
              primaryButton: "Got it",
              child: CustomText(text: "Invalid Credentials"),
            ),
      );
    }
  }

  void signUp() async {
    // Validate inputs
    if (fullName.value.isEmpty ||
        email.value.isEmpty ||
        password.value.isEmpty) {
      showDialog(
        context: Get.context!,
        builder:
            (_) => PopupDialog(
              isOpen: true,
              onClose: () {
                Get.back();
              },
              title: "Validation Error",
              type: PopupDialogType.error,
              secondaryButton: null,
              primaryButton: "Got it",
              child: CustomText(text: "Please fill in all required fields"),
            ),
      );
      return;
    }

    if (password.value != confirmPassword.value) {
      showDialog(
        context: Get.context!,
        builder:
            (_) => PopupDialog(
              isOpen: true,
              onClose: () {
                Get.back();
              },
              title: "Validation Error",
              type: PopupDialogType.error,
              secondaryButton: null,
              primaryButton: "Got it",
              child: CustomText(text: "Passwords do not match"),
            ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: Get.context!,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );

    // Send signup request
    var res = await connect.post("signup", {
      "name": fullName.value,
      "email": email.value,
      "password": password.value,
      // "password_confirmation": confirmPassword.value,
      //"contact_number": phone.value,
    });

    Get.back(); // Dismiss loading indicator

    if (res.body['status']) {
      showDialog(
        context: Get.context!,
        builder:
            (_) => PopupDialog(
              isOpen: true,
              onPrimary: () async {
                UserModel user = UserModel.fromJson(res.body['user']);
                await Storage.saveUser(user: user);
                Get.offAndToNamed('/splash');
              },
              onClose: () {
                Get.back();
              },
              showCloseButton: false,
              title: "Success!",
              type: PopupDialogType.success,
              secondaryButton: null,
              primaryButton: "Got it",
              child: CustomText(text: "Account created successfully"),
            ),
      );
    } else {
      showDialog(
        context: Get.context!,
        builder:
            (_) => PopupDialog(
              isOpen: true,
              onClose: () {
                Get.back();
              },
              title: "Failed!",
              type: PopupDialogType.error,
              secondaryButton: null,
              primaryButton: "Got it",
              child: CustomText(
                text: res.body['message'] ?? "Registration failed",
              ),
            ),
      );
    }
  }

  void forgotPassword() {
    print('Reset password for: ${email.value}');
    // Implement your forgot password logic here
  }

  void signInWithGoogle() {
    print('Sign in with Google');
    // Implement Google sign in
  }

  void signInWithFacebook() {
    print('Sign in with Facebook');
    // Implement Facebook sign in
  }

  void clearForm() {
    email.value = '';
    password.value = '';
    confirmPassword.value = '';
    fullName.value = '';
    phone.value = '';
    showPassword.value = false;
    showConfirmPassword.value = false;
    acceptTerms.value = false;
  }
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}

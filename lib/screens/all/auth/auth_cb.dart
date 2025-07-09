import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petvax/app/constants/strings.dart';
import 'package:petvax/app/models/user_model.dart';
import 'package:petvax/app/services/storage_service.dart';
import 'package:petvax/app/widgets/custom_text.dart';
import 'package:petvax/screens/all/utility/settings_controller.dart';

import '../../../app/components/pretty_alerts.dart';

enum AuthView { loading, login, signup, forgotPassword, error }

class AuthController extends GetxController {
  final formKey = GlobalKey<FormState>();
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
  var email = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var fullName = ''.obs;
  var phone = ''.obs;

  // Forgot Password variables
  var otp = ''.obs;
  var forgotPasswordStep = 'email'.obs; // 'email' or 'otp'
  var isLoading = false.obs;
  var userId = ''.obs;

  // NEW: OTP Box controllers and values
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final RxList<String> otpBoxes = List.generate(6, (index) => '').obs;

  // NEW: Password reset fields
  final RxString newPassword = ''.obs;
  final RxString confirmNewPassword = ''.obs;
  final RxBool showNewPassword = false.obs;
  final RxBool showConfirmNewPassword = false.obs;

  // GetConnect instance
  final GetConnect _connect = GetConnect();

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

  // NEW: Toggle new password visibility
  void toggleNewPasswordVisibility() {
    showNewPassword.value = !showNewPassword.value;
  }

  void toggleConfirmNewPasswordVisibility() {
    showConfirmNewPassword.value = !showConfirmNewPassword.value;
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
    confirmNewPassword.value = value;
  }

  void updateFullName(String value) {
    fullName.value = value;
  }

  void updatePhone(String value) {
    phone.value = value;
  }

  // Update methods
  void updateOtp(String value) => otp.value = value;
  void setForgotPasswordStep(String step) => forgotPasswordStep.value = step;

  // NEW: OTP Box management
  void updateOtpBox(int index, String value) {
    otpBoxes[index] = value;
    otpControllers[index].text = value;

    // Update the main OTP string
    otp.value = otpBoxes.join('');
  }

  void clearOtpBoxes() {
    for (int i = 0; i < otpControllers.length; i++) {
      otpControllers[i].clear();
      otpBoxes[i] = '';
    }
    otp.value = '';
  }

  // NEW: Password reset field updates
  void updateNewPassword(String value) {
    newPassword.value = value;
  }

  void updateConfirmNewPassword(String value) {
    confirmNewPassword.value = value;
  }

  // Authentication methods
  void signIn() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
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
                Get.deleteAll(force: true);
                Get.put(Settings);
                Get.offAllNamed('/splash');
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
    print("password: ${password.value}");
    print("confirm password: ${confirmNewPassword.value}");
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

    if (password.value != confirmNewPassword.value) {
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

  void clearForm() {
    email.value = '';
    password.value = '';
    confirmPassword.value = '';
    fullName.value = '';
    phone.value = '';
    showPassword.value = false;
    showConfirmPassword.value = false;
    acceptTerms.value = false;

    // NEW: Clear forgot password form
    clearOtpBoxes();
    newPassword.value = '';
    confirmNewPassword.value = '';
    showNewPassword.value = false;
    showConfirmNewPassword.value = false;
    forgotPasswordStep.value = 'email';
    userId.value = '';
  }

  // Forgot Password - Send Reset Link
  Future<void> forgotPassword() async {
    if (email.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email address',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    if (!GetUtils.isEmail(email.value)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await connect.post(
        'mail',
        {'type': 'forgot-password', 'email': email.value},
        // headers: {
        //   'Content-Type': 'application/json',
        // },
      );

      if (response.hasError) {
        Get.snackbar(
          'Error',
          'Network error. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
        return;
      }

      final responseData = response.body;

      if (response.statusCode == 200 && responseData['success'] == true) {
        if (responseData['id'] != null) {
          userId.value = responseData['id'].toString();
        }

        Get.snackbar(
          'Success',
          'Reset code sent to your email',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
        );

        // Switch to OTP step
        setForgotPasswordStep('otp');
      } else {
        Get.snackbar(
          'Error',
          responseData['message'] ?? 'Failed to send reset link',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      print('Forgot password error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // NEW: Updated Reset Password method (replaces verifyOtp)
  Future<void> resetPassword() async {
    // Validate OTP
    if (otp.value.length != 4) {
      Get.snackbar(
        'Error',
        'Please enter the complete verification code',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    // Validate new password
    if (newPassword.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a new password',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    if (newPassword.value != confirmNewPassword.value) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    if (newPassword.value.length < 6) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    // if (userId.value.isEmpty) {
    //   Get.snackbar(
    //     'Error',
    //     'Session expired. Please try again.',
    //     snackPosition: SnackPosition.TOP,
    //     backgroundColor: Colors.red[100],
    //     colorText: Colors.red[800],
    //   );
    //   setForgotPasswordStep('email');
    //   return;
    // }

    isLoading.value = true;

    try {
      final response = await connect.post(
        'verify', // You might need to update this endpoint
        {
          'email': email.value,
          'otp': otp.value,
          'new_password': newPassword.value,
          //'password_confirmation': confirmNewPassword.value,
        },
      );
      print("${newPassword.value}");
      print("${confirmNewPassword.value}");
      print("response: ${response.body}");
      if (response.hasError) {
        Get.snackbar(
          'Error',
          'Network error. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
        return;
      }

      final responseData = response.body;

      if (response.statusCode == 200 && responseData['success'] == true) {
        Get.snackbar(
          'Success',
          'Password reset successful! Please sign in.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
        );

        // Clear form and go back to signin
        clearForm();
        setCurrentView('signin');
      } else {
        Get.snackbar(
          'Error',
          responseData['message'] ?? 'Password reset failed. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      print('Reset password error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Keep the original verifyOtp method for backward compatibility if needed
  Future<void> verifyOtp() async {
    if (otp.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter the OTP',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    if (userId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Session expired. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      setForgotPasswordStep('email');
      return;
    }

    isLoading.value = true;

    try {
      final response = await connect.post(
        'verify',
        {'id': userId.value, 'otp': otp.value},
        // headers: {
        //   'Content-Type': 'application/json',
        // },
      );

      if (response.hasError) {
        Get.snackbar(
          'Error',
          'Network error. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
        return;
      }

      final responseData = response.body;

      if (response.statusCode == 200 && responseData['success'] == true) {
        Get.snackbar(
          'Success',
          'Password reset successful! Please sign in.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
        );

        // Clear form and go back to signin
        clearForm();
        setCurrentView('signin');
      } else {
        Get.snackbar(
          'Error',
          responseData['message'] ?? 'Invalid OTP. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      print('Verify OTP error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Resend OTP
  Future<void> resendOtp() async {
    await forgotPassword();
  }

  // Go back to email step
  void backToEmailStep() {
    setForgotPasswordStep('email');
    clearOtpBoxes();
    newPassword.value = '';
    confirmNewPassword.value = '';
  }

  @override
  void onClose() {
    // NEW: Dispose OTP controllers
    for (var controller in otpControllers) {
      controller.dispose();
    }
    _connect.httpClient.close();
    super.onClose();
  }
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}

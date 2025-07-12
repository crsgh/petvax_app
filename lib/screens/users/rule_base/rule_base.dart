import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/constants/strings.dart';
import '../../../app/models/rule_base_model.dart';
import '../../../app/widgets/custom_text.dart';

class RuleBaseScreen extends StatelessWidget {
  const RuleBaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller here to ensure it persists
    Get.put(RuleBaseController(), permanent: true);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade300, Colors.teal.shade600],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Pet Diagnostic Assistant',
                style: GoogleFonts.poppins(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              Text(
                'Select your pet type to begin',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 50.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPetCard(
                    title: 'Dog',
                    icon: Icons.pets,
                    color: Colors.orange,
                    onTap:
                        () => Get.to(
                          () => DiagnosticScreen(petType: PetType.dog),
                        ),
                  ),
                  _buildPetCard(
                    title: 'Cat',
                    icon: Icons.pets,
                    color: Colors.purple,
                    onTap:
                        () => Get.to(
                          () => DiagnosticScreen(petType: PetType.cat),
                        ),
                  ),
                ],
              ),
              SizedBox(height: 100.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: "Back to ",
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  GestureDetector(
                    onTap: () => Get.offAllNamed('/home'),
                    child: Text(
                      'Home.',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.teal[200],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120.w,
        height: 120.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40.sp, color: color),
            SizedBox(height: 8.h),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RuleBaseController extends GetxController {
  var isLoading = false.obs;
  var rules = <RuleBase>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRuleBaseData();
  }

  Future<void> loadRuleBaseData() async {
    try {
      isLoading.value = true;

      // Simulate API call delay
      await Future.delayed(Duration(seconds: 2));

      // Load your rule base data here
      await _loadRules();
    } catch (e,ex) {
      print(ex);
      Get.snackbar('Error', 'Failed to load diagnostic data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadRules() async {
    var res = await GetConnect().get('${AppStrings.baseUrl}rule-base');
    // Fixed: Direct mapping without JSON decoding since data is already parsed
    print("carlos: ${res.body}");
    List<Map<String, dynamic>> ruleData = List<Map<String, dynamic>>.from(
      res.body['data'],
    );

    print("data: ${res.body}");
    rules.value = ruleData.map((json) => RuleBase.fromJson(json)).toList();
  }
}

class RuleBaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RuleBaseController>(() => RuleBaseController());
  }
}

enum PetType { dog, cat }

class DiagnosticController extends GetxController {
  final PetType petType;
  late final RuleBaseController ruleBaseController;

  DiagnosticController(this.petType);

  var currentStep = ''.obs;
  var finalResult = Rx<String?>(null);
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Get or create the RuleBaseController
    ruleBaseController = Get.find<RuleBaseController>();
    // Start with the first rule for the selected pet type
    _setInitialStep();
  }

  void _setInitialStep() {
    // Wait for rules to load if they haven't already
    if (ruleBaseController.rules.isEmpty &&
        !ruleBaseController.isLoading.value) {
      ruleBaseController.loadRuleBaseData();
    }

    // Find the first rule for the selected pet type where isFirstQuestion is true
    final firstRule = rules.firstWhereOrNull(
      (rule) =>
          rule.target.toLowerCase() == petName.toLowerCase() &&
          rule.isFirstQuestion == true,
    );

    if (firstRule != null) {
      currentStep.value = firstRule.id.toString();
    } else {
      // Fallback: if no first question found, try to find any rule for the pet type
      final anyRule = rules.firstWhereOrNull(
        (rule) => rule.target.toLowerCase() == petName.toLowerCase(),
      );

      if (anyRule != null) {
        currentStep.value = anyRule.id.toString();
      } else {
        // Final fallback if no rules found
        currentStep.value = petType == PetType.dog ? 'dog' : 'cat';
      }
    }
  }

  List<RuleBase> get rules => ruleBaseController.rules;

  String get petName => petType == PetType.dog ? 'dog' : 'cat';
  Color get petColor => petType == PetType.dog ? Colors.orange : Colors.purple;

  RuleBase? getCurrentRule() {
    // First try to find by ID (for numeric references)
    final ruleById = rules.firstWhereOrNull(
      (rule) => rule.id.toString() == currentStep.value,
    );
    if (ruleById != null) return ruleById;

    // Then try to find by target (for initial step)
    return rules.firstWhereOrNull(
      (rule) => rule.target.toLowerCase() == currentStep.value.toLowerCase(),
    );
  }

  Future<void> handleAnswer(String answer) async {
    try {
      isLoading.value = true;

      // Simulate processing delay
      await Future.delayed(Duration(milliseconds: 500));

      final currentRule = getCurrentRule();
      if (currentRule == null) return;

      final nextStep = answer == 'yes' ? currentRule.yes : currentRule.no;

      // Check if the next step is a final result (not a number and not a target)
      if (_isFinalResult(nextStep)) {
        finalResult.value = nextStep;
      } else {
        currentStep.value = nextStep;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to process answer: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool _isFinalResult(String step) {
    // Check if it's a numeric string (references another rule)
    if (step.isNumericOnly) {
      return false;
    }

    // Check if it's a target (dog/cat)
    if (step.toLowerCase() == 'dog' || step.toLowerCase() == 'cat') {
      return false;
    }

    // Everything else is considered a final result
    return true;
  }

  void reset() {
    print("Reset called - clearing final result and setting initial step");
    finalResult.value = null;
    _setInitialStep();
  }

  void goBack() {
    Get.back();
  }
}

class DiagnosticScreen extends StatelessWidget {
  final PetType petType;

  const DiagnosticScreen({super.key, required this.petType});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DiagnosticController(petType));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${controller.petName.capitalize} Diagnostic Assistant',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: controller.petColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: controller.goBack,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [controller.petColor.withOpacity(0.1), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Obx(() {
              if (controller.ruleBaseController.isLoading.value) {
                return _buildLoadingView();
              }

              return controller.finalResult.value == null
                  ? _buildQuestionView(controller)
                  : _buildResultView(controller);
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
        ),
        SizedBox(height: 20.h),
        Text(
          'Loading diagnostic data...',
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionView(DiagnosticController controller) {
    final currentRule = controller.getCurrentRule();

    if (currentRule == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60.sp, color: Colors.red),
            SizedBox(height: 20.h),
            Text(
              'Question not found',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () => controller.reset(),
              child: Text('Start Over'),
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(Icons.pets, size: 50.sp, color: controller.petColor),
              SizedBox(height: 20.h),
              Text(
                currentRule.question.capitalize ?? 'No question available',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: 40.h),
        Obx(() {
          if (controller.isLoading.value) {
            return Container(
              height: 50.h,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    controller.petColor,
                  ),
                ),
              ),
            );
          }

          return Row(
            children: [
              Expanded(
                child: _buildAnswerButton(
                  text: 'Yes',
                  color: Colors.green,
                  onPressed: () => controller.handleAnswer('yes'),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildAnswerButton(
                  text: 'No',
                  color: Colors.red,
                  onPressed: () => controller.handleAnswer('no'),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildResultView(DiagnosticController controller) {
    final result = controller.finalResult.value ?? '';
    final isHealthy =
        result.toLowerCase().contains('walang sakit') ||
        result.toLowerCase().contains('healthy') ||
        result.toLowerCase().contains('normal');

    final resultColor = isHealthy ? Colors.green : Colors.red;
    final resultIcon = isHealthy ? Icons.check_circle : Icons.warning;
    final resultText = isHealthy ? 'APPEARS HEALTHY' : 'NEEDS ATTENTION';
    final resultMessage =
        isHealthy
            ? 'Your pet appears to be healthy based on the assessment.'
            : 'Diagnosis: $result\n\nYour pet may need veterinary attention.';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(resultIcon, size: 50.sp, color: resultColor),
              SizedBox(height: 20.h),
              Text(
                resultText,
                style: GoogleFonts.poppins(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: resultColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Text(
                resultMessage,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: 40.h),
        Column(
          children: [
            _buildAnswerButton(
              text: 'Start Over',
              color: controller.petColor,
              onPressed: () {
                print("Start Over button pressed");
                controller.reset();
              },
            ),
            if (!isHealthy) ...[
              SizedBox(height: 16.h),
              _buildAnswerButton(
                text: 'Find Nearby Clinics',
                color: Colors.teal,
                onPressed: () => Get.offAndToNamed('/clinics'),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildAnswerButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
          elevation: 5,
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// Updated RuleBase model to match your data structure
class RuleBase {
  final int id;
  final String target;
  final String question;
  final String yes;
  final String no;
  final bool isFirstQuestion;
  final String? createdAt;
  final String? updatedAt;

  RuleBase({
    required this.id,
    required this.target,
    required this.question,
    required this.yes,
    required this.no,
    this.isFirstQuestion = false, // Fixed: provide default value
    this.createdAt,
    this.updatedAt,
  });

  factory RuleBase.fromJson(Map<String, dynamic> json) {
    return RuleBase(
      id: json['id'] ?? 0,
      target: json['target'] ?? '',
      question: json['question'] ?? '',
      yes: json['yes'] ?? '',
      no: json['no'] ?? '',
      isFirstQuestion: json['is_first_question'] == 1 ? true : false,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'target': target,
      'question': question,
      'yes': yes,
      'no': no,
      'is_first_question': isFirstQuestion,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

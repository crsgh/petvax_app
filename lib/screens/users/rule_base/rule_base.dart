import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petvax/app/widgets/custom_text.dart';

class RuleBase extends StatelessWidget {
  const RuleBase({super.key});

  @override
  Widget build(BuildContext context) {
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
                        //decoration: TextDecoration.underline,
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

class RuleBaseController extends GetxController {}

class RuleBaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RuleBaseController>(() => RuleBaseController());
  }
}

enum PetType { dog, cat }

class DiagnosticController extends GetxController {
  final PetType petType;

  DiagnosticController(this.petType);

  var currentStep = 'Q0'.obs;
  var diagnosis = Rx<String?>(null);

  // Dog questions
  final Map<String, dynamic> dogQuestions = {
    'Q0': {
      'question': 'Is your dog acting unusually (lethargic, restless, aggressive)?',
      'yes': 'Q1',
      'no': 'END_OK',
    },
    'Q1': {
      'question': 'Is your dog vomiting or having diarrhea?',
      'yes': 'Q2',
      'no': 'Q4',
    },
    'Q2': {
      'question': 'Is there blood in the vomit or stool?',
      'yes': 'DIAG_PARVO',
      'no': 'Q3',
    },
    'Q3': {
      'question': 'Is your dog showing signs of jaundice (yellow eyes/skin)?',
      'yes': 'DIAG_LEPTO',
      'no': 'Q4',
    },
    'Q4': {
      'question': 'Does your dog have nasal discharge or sneezing?',
      'yes': 'Q4a',
      'no': 'Q5',
    },
    'Q4a': {
      'question': 'Is your dog also showing fever or seizures?',
      'yes': 'DIAG_DISTEMPER',
      'no': 'END_MONITOR',
    },
    'Q5': {
      'question': 'Is your dog coughing or easily tired after activity?',
      'yes': 'DIAG_HEARTWORM',
      'no': 'Q6',
    },
    'Q6': {
      'question': 'Has your dog been exposed to ticks recently?',
      'yes': 'Q7',
      'no': 'Q8',
    },
    'Q7': {
      'question': 'Is your dog showing fever or joint pain?',
      'yes': 'DIAG_TICKBORNE',
      'no': 'Q8',
    },
    'Q8': {
      'question': 'Is your dog excessively drooling or showing behavior changes?',
      'yes': 'DIAG_RABIES',
      'no': 'Q9',
    },
    'Q9': {
      'question': 'Is your dog constantly scratching or has inflamed skin?',
      'yes': 'DIAG_SKIN',
      'no': 'END_MONITOR',
    },
  };

  // Cat questions
  final Map<String, dynamic> catQuestions = {
    'Q0': {
      'question': 'Is your cat acting unusually (hiding, lethargy, vocalizing)?',
      'yes': 'Q1',
      'no': 'END_OK',
    },
    'Q1': {
      'question': 'Is your cat eating or drinking less than usual?',
      'yes': 'Q2',
      'no': 'Q4',
    },
    'Q2': {
      'question': 'Is your cat vomiting, has diarrhea, or shows digestive upset?',
      'yes': 'Q3',
      'no': 'Q6',
    },
    'Q3': {
      'question': 'Is there blood in the vomit or stool?',
      'yes': 'DIAG_PANLEUKOPENIA',
      'no': 'DIAG_GASTRITIS',
    },
    'Q4': {
      'question': 'Is your cat sneezing, coughing, or has nasal/eye discharge?',
      'yes': 'Q5',
      'no': 'Q6',
    },
    'Q5': {
      'question': 'Are the eyes swollen or has thick discharge?',
      'yes': 'DIAG_HERPESVIRUS',
      'no': 'DIAG_CALICIVIRUS',
    },
    'Q6': {
      'question': 'Is your cat scratching, losing hair, or grooming excessively?',
      'yes': 'DIAG_FLEAALLERGY',
      'no': 'Q7',
    },
    'Q7': {
      'question': 'Is your cat having trouble urinating or yowling in the litter box?',
      'yes': 'DIAG_URETHRALBLOCK',
      'no': 'Q8',
    },
    'Q8': {
      'question': 'Is your cat drinking or urinating more than usual?',
      'yes': 'DIAG_KIDNEYDISEASE',
      'no': 'END_MONITOR',
    },
  };

  // Dog diagnoses
  final Map<String, String> dogDiagnoses = {
    'END_OK': 'Your dog appears healthy. Continue regular checkups.',
    'END_MONITOR': 'Monitor your dog’s condition. If symptoms persist, consult your veterinarian.',
    'DIAG_PARVO': 'Possible Canine Parvovirus. Severe vomiting and bloody diarrhea are critical. Emergency care is needed.',
    'DIAG_DISTEMPER': 'Possible Canine Distemper. Affects the respiratory and nervous systems. Seek veterinary care immediately.',
    'DIAG_HEARTWORM': 'Possible Heartworm Disease or Kennel Cough. Signs include cough and fatigue. Visit a vet for testing.',
    'DIAG_TICKBORNE': 'Possible Ehrlichiosis or Anaplasmosis. Tick fever causes joint pain and fever. Vet treatment recommended.',
    'DIAG_RABIES': 'Possible Rabies. Behavior changes, drooling, and paralysis are signs. Contact a vet and local authorities immediately.',
    'DIAG_LEPTO': 'Possible Leptospirosis. Common in rainy seasons. Watch for vomiting and yellow eyes. Visit a vet promptly.',
    'DIAG_SKIN': 'Possible skin allergy or infection. Hot climate causes flea/mite/fungal problems. Contact vet for proper treatment and grooming.',
  };

  // Cat diagnoses
  final Map<String, String> catDiagnoses = {
    'END_OK': 'Your cat appears healthy. Continue regular checkups with your veterinarian.',
    'END_MONITOR': 'Monitor your cat’s condition. If symptoms persist or worsen, consult your veterinarian.',
    'DIAG_PANLEUKOPENIA': 'Possible viral gastrointestinal disease. Seek urgent veterinary care.',
    'DIAG_GASTRITIS': 'Possible digestive issue such as gastritis, intolerance, or constipation. A veterinary consultation is recommended.',
    'DIAG_HERPESVIRUS': 'Possible respiratory infection (FHV). Please consult your veterinarian for diagnosis and treatment.',
    'DIAG_CALICIVIRUS': 'Possible respiratory infection (FCV). Monitor closely and visit your vet for further evaluation.',
    'DIAG_FLEAALLERGY': 'Possible skin allergy or parasite issue (e.g. fleas, mange). Veterinary advice is recommended for proper treatment.',
    'DIAG_KIDNEYDISEASE': 'Possible kidney or endocrine disease (e.g. diabetes, hyperthyroidism). Please consult your veterinarian promptly.',
    'DIAG_URETHRALBLOCK': 'Possible urinary emergency. Seek veterinary care immediately.',
  };

  Map<String, dynamic> get questions =>
      petType == PetType.dog ? dogQuestions : catQuestions;
  Map<String, String> get diagnoses =>
      petType == PetType.dog ? dogDiagnoses : catDiagnoses;

  String get petName => petType == PetType.dog ? 'Dog' : 'Cat';
  Color get petColor => petType == PetType.dog ? Colors.orange : Colors.purple;

  void handleAnswer(String answer) {
    final nextStep = questions[currentStep.value][answer];
    if (nextStep.toString().startsWith('DIAG') ||
        nextStep.toString().startsWith('END')) {
      diagnosis.value = diagnoses[nextStep];
    } else {
      currentStep.value = nextStep;
    }
  }

  void reset() {
    currentStep.value = 'Q0';
    diagnosis.value = null;
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
          '${controller.petName} Diagnostic Assistant',
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
              return controller.diagnosis.value == null
                  ? _buildQuestionView(controller)
                  : _buildDiagnosisView(controller);
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionView(DiagnosticController controller) {
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
                controller.questions[controller.currentStep.value]['question'],
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
        Row(
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
        ),
      ],
    );
  }

  Widget _buildDiagnosisView(DiagnosticController controller) {
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
              Icon(
                Icons.medical_services,
                size: 50.sp,
                color: controller.petColor,
              ),
              SizedBox(height: 20.h),
              Text(
                'Diagnosis',
                style: GoogleFonts.poppins(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: controller.petColor,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                controller.diagnosis.value!,
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
              onPressed: controller.reset,
            ),
            SizedBox(height: 16.h),
            _buildAnswerButton(
              text: 'Find Nearby Clinics',
              color: Colors.teal,
              onPressed: () => Get.offAndToNamed('/clinics'),
            ),
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

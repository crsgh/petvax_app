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
      'question':
          'Is your dog acting unusually (lethargic, irritable, restless)?',
      'yes': 'Q1',
      'no': 'END_OK',
    },
    'Q1': {
      'question': 'Is your dog eating and drinking normally?',
      'yes': 'Q4',
      'no': 'Q2',
    },
    'Q2': {
      'question': 'Is your dog vomiting or having diarrhea?',
      'yes': 'Q3',
      'no': 'Q6',
    },
    'Q3': {
      'question': 'Does vomit or stool contain blood?',
      'yes': 'DIAG_PARVOVIRUS',
      'no': 'Q13',
    },
    'Q4': {
      'question': 'Is your dog coughing, sneezing, or has nasal discharge?',
      'yes': 'Q5',
      'no': 'Q6',
    },
    'Q5': {
      'question': 'Is it a dry cough or discharge thickens at night?',
      'yes': 'DIAG_HEARTCOUGH',
      'no': 'DIAG_KENNELCOUGH',
    },
    'Q6': {
      'question': 'Is your dog itching or has visible skin issues?',
      'yes': 'Q7',
      'no': 'Q8',
    },
    'Q7': {
      'question': 'Are fleas, mange, or skin wounds visible?',
      'yes': 'DIAG_FLEAALLERGY',
      'no': 'DIAG_DERMATITIS',
    },
    'Q8': {
      'question': 'Is your dog limping or avoiding a limb?',
      'yes': 'DIAG_INJURY',
      'no': 'Q9',
    },
    'Q9': {
      'question': 'Are there swellings, bad smell, or oral/ear problems?',
      'yes': 'Q10',
      'no': 'Q11',
    },
    'Q10': {
      'question': 'Which area is affected?',
      'yes': 'DIAG_ORAL_EAR_SKIN',
      'no': 'Q11',
    },
    'Q11': {
      'question': 'Is your dog drinking/urinating more than usual?',
      'yes': 'DIAG_DIABETES',
      'no': 'Q12',
    },
    'Q12': {
      'question': 'Any seizures, head tilt, or confusion?',
      'yes': 'DIAG_NEURO',
      'no': 'END_MONITOR',
    },
    'Q13': {
      'question': 'Is your dog in pain while chewing or eating?',
      'yes': 'DIAG_DENTAL',
      'no': 'DIAG_GASTRO',
    },
  };

  // Cat questions
  final Map<String, dynamic> catQuestions = {
    'Q0': {
      'question':
          'Is your cat acting differently (hiding, lethargy, vocalizing)?',
      'yes': 'Q1',
      'no': 'END_OK',
    },
    'Q1': {
      'question': 'Is your cat eating and drinking normally?',
      'yes': 'Q4',
      'no': 'Q2',
    },
    'Q2': {
      'question': 'Is your cat vomiting or having diarrhea?',
      'yes': 'Q3',
      'no': 'Q6',
    },
    'Q3': {
      'question': 'Does the vomit/stool contain blood?',
      'yes': 'DIAG_PANLEUKOPENIA',
      'no': 'DIAG_GASTRITIS',
    },
    'Q4': {
      'question': 'Is your cat sneezing, coughing, or has nasal/eye discharge?',
      'yes': 'Q5',
      'no': 'Q6',
    },
    'Q5': {
      'question': 'Are the eyes swollen or is there thick discharge?',
      'yes': 'DIAG_HERPESVIRUS',
      'no': 'DIAG_CALICIVIRUS',
    },
    'Q6': {
      'question': 'Is your cat scratching, overgrooming, or has hair loss?',
      'yes': 'Q7',
      'no': 'Q8',
    },
    'Q7': {
      'question': 'Are fleas or skin lesions visible?',
      'yes': 'DIAG_FLEAALLERGY',
      'no': 'DIAG_PSYCHOGROOMING',
    },
    'Q8': {
      'question': 'Is your cat using the litter box normally?',
      'yes': 'Q9',
      'no': 'Q10',
    },
    'Q9': {
      'question': 'Is your cat drinking more or urinating more frequently?',
      'yes': 'DIAG_KIDNEYDISEASE',
      'no': 'Q11',
    },
    'Q10': {
      'question':
          'Is the cat straining, yowling in pain, or producing little to no urine?',
      'yes': 'DIAG_URETHRALBLOCK',
      'no': 'DIAG_CONSTIPATION',
    },
    'Q11': {
      'question':
          'Is your cat showing any neurological signs (seizures, head tilt)?',
      'yes': 'DIAG_NEURO',
      'no': 'END_MONITOR',
    },
  };

  // Dog diagnoses
  final Map<String, String> dogDiagnoses = {
    'END_OK': 'Your dog appears healthy. Continue regular checkups.',
    'DIAG_PARVOVIRUS':
        'Possible Parvovirus or severe gastroenteritis. Emergency care needed.',
    'DIAG_KENNELCOUGH': 'Possible Kennel Cough or mild respiratory infection.',
    'DIAG_HEARTCOUGH':
        'Possible heart condition or tracheal collapse. Vet evaluation needed.',
    'DIAG_FLEAALLERGY': 'Possible flea allergy or mange infection.',
    'DIAG_DERMATITIS':
        'Skin issue possibly due to allergy or fungal/bacterial infection.',
    'DIAG_INJURY': 'Possible sprain, arthritis, or bone injury.',
    'DIAG_ORAL_EAR_SKIN':
        'Ear infection, dental issue, or skin abscess suspected.',
    'DIAG_DIABETES': 'Possible diabetes or kidney-related condition.',
    'DIAG_NEURO':
        'Neurological symptoms suggest seizure disorder or vestibular issue.',
    'DIAG_DENTAL': 'Dental pain or gum disease likely.',
    'DIAG_GASTRO': 'Likely mild gastro issue or food intolerance.',
    'END_MONITOR': 'Mild symptoms. Continue monitoring or consult vet.',
  };

  // Cat diagnoses
  final Map<String, String> catDiagnoses = {
    'END_OK': 'Your cat appears healthy. Continue regular checkups.',
    'DIAG_PANLEUKOPENIA':
        'Possible panleukopenia or toxin ingestion. Seek urgent vet care.',
    'DIAG_GASTRITIS': 'Possible gastritis, hairballs, or food intolerance.',
    'DIAG_HERPESVIRUS': 'Possible feline herpesvirus infection.',
    'DIAG_CALICIVIRUS': 'Possible mild URI or feline calicivirus.',
    'DIAG_FLEAALLERGY': 'Possible flea allergy dermatitis or mange.',
    'DIAG_PSYCHOGROOMING': 'Possible psychogenic alopecia or allergies.',
    'DIAG_KIDNEYDISEASE':
        'Possible diabetes, kidney disease, or hyperthyroidism.',
    'DIAG_URETHRALBLOCK':
        'Possible FLUTD or urethral blockage. Urgent care needed.',
    'DIAG_CONSTIPATION': 'Possible behavioral issue or constipation.',
    'DIAG_NEURO': 'Possible neurological condition. Vet visit recommended.',
    'END_MONITOR': 'Monitor your cat\'s condition or consult your vet.',
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

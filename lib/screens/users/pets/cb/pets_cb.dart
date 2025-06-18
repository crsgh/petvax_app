import 'package:get/get.dart';
import 'package:petvax/app/constants/strings.dart';
import 'package:petvax/app/mixins/snackbar.dart';
import 'package:petvax/screens/all/utility/settings_controller.dart';

enum PetsView { loading, loaded, error }

class PetsController extends GetxController with SnackBarMixin {
  var view = PetsView.loading.obs;
  Settings settings = Get.find<Settings>();
  GetConnect connect = GetConnect();
  @override
  void onInit() async {
    connect.baseUrl = AppStrings.baseUrl;
    view(PetsView.loaded);
    super.onInit();
  }
}

class PetsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PetsController>(() => PetsController());
  }
}

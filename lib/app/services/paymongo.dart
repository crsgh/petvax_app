import 'package:get/get.dart';
import 'package:paymongo_sdk/paymongo_sdk.dart';
import 'package:petvax/app/constants/strings.dart';

import '../../screens/all/utility/settings_controller.dart';

class Paymongo {
  final publicSDK = PaymongoClient<PaymongoPublic>(
    'pk_test_J1wrRzPh1V8NpRhqTNLYcEFG',
  );
  Future<SourceResult> makePayment({amount, id}) async {
    var settings = Get.find<Settings>();
    print("url: ${"${AppStrings.baseUrl}payment/success?id=$id"}");
    final data = SourceAttributes(
      type: 'gcash',
      amount: amount,
      currency: 'PHP',
      redirect: Redirect(
        success: "${AppStrings.baseUrl}payment/success?id=$id",
        failed: "${AppStrings.baseUrl}payment/failed?id=$id",
      ),
      billing: PayMongoBilling(
        name: "carlos",
        phone: "09171234567",
        email: "carlos@petvax.shop",
        address: PayMongoAddress(
          line1: "123 Main Street",
          city: "marilao",
          state: "bulacan",
          country: "PH",
        ),
      ),
    );

    return await publicSDK.instance.source.create(data);
  }
}

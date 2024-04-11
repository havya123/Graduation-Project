import 'package:get/get.dart';
import 'package:graduation_project/app/route/route_name.dart';
import 'package:graduation_project/extension/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  Future<void> logout() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      prefs.clear();
      MyDialogs.success(msg: "Logout Successfully");
      Get.offAllNamed(RouteName.loginRoute);
    } catch (e) {}
  }
}

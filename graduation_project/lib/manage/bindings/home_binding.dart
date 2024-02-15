import 'package:get/get.dart';
import 'package:graduation_project/manage/controller/home_controller.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}

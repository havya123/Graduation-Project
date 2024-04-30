import 'package:get/get.dart';
import 'package:graduation_project/manage/controller/custom_stepper_controller.dart';

class CustomStepperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CustomStepperController());
  }
}

import 'package:get/get.dart';
import 'package:graduation_project/manage/controller/create_request_controller.dart';
import 'package:graduation_project/manage/controller/custom_stepper_controller.dart';

class RequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RequestController());
    Get.lazyPut(() => CustomStepperController());
  }
}

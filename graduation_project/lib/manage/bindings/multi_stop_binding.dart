import 'package:get/get.dart';
import 'package:graduation_project/manage/controller/create_multi_request_controller.dart';
import 'package:graduation_project/manage/controller/custom_stepper_multi_controller.dart';
//import 'package:graduation_project/manage/controller/multi_stop_controller.dart';

class MultiStopBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => MultiStopController());
    Get.lazyPut(() => CustomStepperMultiController());
    Get.lazyPut(() => CreateRequestMultiController());
  }
}

import 'package:get/get.dart';
import 'package:graduation_project/manage/controller/create_request_controller.dart';
import 'package:graduation_project/manage/controller/custom_stepper_controller.dart';

class CustomStepperBinding extends Bindings {
  @override
  void dependencies() {
    var requestController = RequestController();
    Get.lazyPut(() => requestController);
    requestController.onInit();
    Get.lazyPut(() => CustomStepperController());
  }
}

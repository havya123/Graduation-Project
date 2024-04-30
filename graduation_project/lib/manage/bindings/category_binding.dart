import 'package:get/get.dart';
import 'package:graduation_project/manage/controller/category_controller.dart';
import 'package:graduation_project/manage/controller/create_request_controller.dart';
import 'package:graduation_project/manage/controller/custom_stepper_controller.dart';
import 'package:graduation_project/manage/controller/geofire_assistant.dart';
import 'package:graduation_project/manage/controller/picker_controller.dart';

class CategoryBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => GeoFireAssistant());

    var requestController = RequestController();
    Get.lazyPut(() => requestController);
    requestController.onInit();

    var categoryController = CategoryController();
    Get.lazyPut(() => categoryController);
    await categoryController.init();
  }
}

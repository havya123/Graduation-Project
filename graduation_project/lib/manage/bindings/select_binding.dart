import 'package:get/get.dart';
import 'package:graduation_project/manage/controller/select_controller.dart';

class SelectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SelectController());
  }
}

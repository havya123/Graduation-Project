import 'package:get/get.dart';
import 'package:graduation_project/manage/controller/history_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() async {
    var controller = HistoryController();
    Get.lazyPut(() => controller);
    await controller.onInit();
  }
}

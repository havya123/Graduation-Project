import 'package:get/get.dart';
import 'package:graduation_project/manage/controller/category_controller.dart';
import 'package:graduation_project/manage/controller/geofire_assistant.dart';
import 'package:graduation_project/manage/controller/picker_controller.dart';

class CategoryBinding extends Bindings {
  @override
  void dependencies() async {
    await Get.putAsync(() => CategoryController().init());
    Get.lazyPut(() => GeoFireAssistant());
  }
}

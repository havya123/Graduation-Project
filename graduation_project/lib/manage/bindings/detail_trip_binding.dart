import 'package:get/get.dart';
import 'package:graduation_project/manage/controller/detail_trip_controller.dart';

class DetailTripBinding extends Bindings {
  @override
  void dependencies() async {
    var controller = DetailTripController();
    Get.lazyPut(() => controller);
    await controller.init();
  }
}

import 'package:drivers/app/store/app_store.dart';
import 'package:drivers/controller/delivery_multi_controller.dart';
import 'package:drivers/controller/pickup_controller.dart';
import 'package:drivers/model/request_multi.dart';
import 'package:get/get.dart';

class PickupBinding extends Bindings {
  @override
  void dependencies() async {
    var controller = PickupController();
    Get.put(controller);
    await controller.onInit();
    if (AppStore.to.currentRequest.value is RequestMulti) {
      Get.lazyPut(() => DeliveryMultiController(), fenix: true);
    }
  }
}

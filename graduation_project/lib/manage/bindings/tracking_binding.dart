import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:graduation_project/manage/controller/geofire_assistant.dart';
import 'package:graduation_project/manage/controller/tracking_controller.dart';

class TrackingBinding extends Bindings {
  @override
  void dependencies() async {
    var controller = TrackingController();
    Get.lazyPut(() => controller);
    await controller.init();
  }
}

import 'package:get/get.dart';
import 'package:graduation_project/manage/firebase_service/notification_service.dart';

class CategoryController extends GetxController {
  static CategoryController get to => Get.find<CategoryController>();

  List<String> listMenu = [
    "Deliveries",
    "Support",
    "My Order",
    "Setting",
  ];

  Future<CategoryController> init() async {
    await NotificationService().getDeviceToken();
    var access = await NotificationService().getAccessToken();
    await NotificationService().init();
    return this;
  }
}

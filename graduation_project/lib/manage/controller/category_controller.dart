import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/manage/firebase_service/notification_service.dart';

class CategoryController extends GetxController {
  static CategoryController get to => Get.find<CategoryController>();
  RxInt index = 0.obs;

  List<String> listMenu = [
    "Deliveries",
    "Support",
    "My Order",
    "Setting",
  ];

  List<IconData> listIcon = [
    Icons.home,
    Icons.people,
  ];

  List<String> listTitle = [
    'Home',
    'Profile',
  ];

  Future<CategoryController> init() async {
    await NotificationService().getDeviceToken();
    // await NotificationService().getAccessToken();
    await NotificationService().init();
    return this;
  }

  void changeIndex(int newIndex) {
    index.value = newIndex;
  }
}

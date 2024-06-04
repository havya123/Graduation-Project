import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/app/store/app_store.dart';
import 'package:graduation_project/manage/firebase_service/notification_service.dart';
import 'package:graduation_project/model/request.dart';
import 'package:graduation_project/repository/request_repo.dart';

class CategoryController extends GetxController {
  RxInt index = 0.obs;
  static RxString currentLocation = "".obs;
  Rx<Request?> lastedRequest = Rx<Request?>(null);
  RxInt currentStatus = 3.obs;
  RxBool isLoading = false.obs;
  StreamSubscription<Request?>? _requestSubscription;

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
    isLoading.value = true;
    getLastedRequest();
    await NotificationService().getDeviceToken();
    // await NotificationService().getAccessToken();
    await NotificationService().init();
    // getLastedRequest();
    return this;
  }

  void changeIndex(int newIndex) {
    index.value = newIndex;
  }

  @override
  void onClose() {
    _requestSubscription?.cancel();
    super.onClose();
  }

  void getLastedRequest() {
    isLoading.value = true;
    _requestSubscription = RequestRepo()
        .getLastedRequestStream(AppStore.to.uid.value)
        .listen((request) {
      lastedRequest.value = request;
      if (request != null) {
        switch (request.statusRequest) {
          case "waiting":
            currentStatus.value = 0;
            break;
          case "on taking":
            currentStatus.value = 1;
            break;
          case "on delivery":
            currentStatus.value = 2;
            break;
          case "success":
            currentStatus.value = 3;
            break;
          default:
            currentStatus.value = 0;
        }
      } else {
        currentStatus.value = 0;
      }
      isLoading.value = false;
    });
  }
}

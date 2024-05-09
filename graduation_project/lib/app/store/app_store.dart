import 'dart:convert';
import 'package:get/get.dart';
import 'package:graduation_project/app/store/services.dart';
import 'package:graduation_project/app/util/key.dart';
import 'package:graduation_project/manage/controller/geofire_assistant.dart';
import 'package:graduation_project/manage/firebase_service/notification_service.dart';
import 'package:graduation_project/model/request.dart';
import 'package:graduation_project/model/user.dart';
import 'package:graduation_project/repository/request_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStore extends GetxController {
  static AppStore get to => Get.find();
  bool firstRun = false;
  Rx<User?> user = Rx<User?>(null);
  String userName = "";
  String uid = "";
  String phoneNumber = "";
  String avatar = "";
  bool isExpired = true;
  String newRequest = "";
  Rx<dynamic> lastedRequest = Rx<dynamic>(dynamic);
  RxString deviceToken = "".obs;

  Future<AppStore> init() async {
    //await clearAll();

    String driverSent = AppServices.to.getString(MyKey.driverSent);
    deviceToken.value = AppServices.to.getString(MyKey.deviceToken);
    if (driverSent.isNotEmpty) {
      GeoFireAssistant.driverSent = jsonDecode(driverSent);
    }

    String userSaved = AppServices.to.getString(MyKey.user);
    if (userSaved.isNotEmpty) {
      String decode = jsonDecode(userSaved);
      User user = User.fromJson(decode);
      newRequest = AppServices.to.getString(MyKey.newRequest);
      updateUser(user);
    }
    if (newRequest.isNotEmpty) {
      lastedRequest.value = await RequestRepo().getRequest(newRequest);
    }

    return this;
  }

  void updateUser(User userSaved) {
    user.value = userSaved;
    userName = userSaved.userName;
    uid = userSaved.uid;
    phoneNumber = userSaved.phoneNumber;
    avatar = userSaved.avatar;
  }

  void clearUser() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(MyKey.user);
  }

  Future<void> clearAll() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}

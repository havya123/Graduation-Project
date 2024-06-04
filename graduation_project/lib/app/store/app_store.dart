import 'dart:convert';
import 'package:get/get.dart';
import 'package:graduation_project/app/store/services.dart';
import 'package:graduation_project/app/util/key.dart';
import 'package:graduation_project/manage/controller/geofire_assistant.dart';
import 'package:graduation_project/model/user.dart';
import 'package:graduation_project/repository/login_repo.dart';
import 'package:graduation_project/repository/request_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStore extends GetxController {
  static AppStore get to => Get.find();
  bool firstRun = false;
  Rx<User?> user = Rx<User?>(null);
  RxString userName = "".obs;
  RxString uid = "".obs;
  RxString phoneNumber = "".obs;
  RxString avatar = "".obs;
  RxString email = "".obs;
  RxString address = "".obs;
  bool isExpired = true;
  String newRequest = "";
  Rx<dynamic> lastedRequest = Rx<dynamic>(dynamic);
  RxString deviceToken = "".obs;

  Future<AppStore> init() async {
    //await clearAll();

    String driverSent = AppServices.to.getString(MyKey.driverSent);
    driverSent = "";
    deviceToken.value = AppServices.to.getString(MyKey.deviceToken);
    if (driverSent.isNotEmpty) {
      GeoFireAssistant.driverSent = jsonDecode(driverSent);
    }

    String userSaved = AppServices.to.getString(MyKey.user);
    if (userSaved.isNotEmpty) {
      User user = await LoginRepo().getUser(userSaved);
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
    userName.value = userSaved.userName;
    uid.value = userSaved.uid;
    phoneNumber.value = userSaved.phoneNumber;
    avatar.value = userSaved.avatar;
    email.value = userSaved.email;
    address.value = userSaved.address ?? "";
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

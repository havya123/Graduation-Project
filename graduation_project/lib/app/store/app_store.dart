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

  Future<AppStore> init() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(MyKey.driverSent);
    String tokenSaved = AppServices.to.getString(MyKey.token);
    String driverSent = AppServices.to.getString(MyKey.driverSent);
    if (driverSent.isNotEmpty) {
      GeoFireAssistant.driverSent = jsonDecode(driverSent);
    }

    if (tokenSaved.isNotEmpty) {
      // isExpired = JwtDecoder.isExpired(tokenSaved);
      // if (isExpired) {
      //   clearUser();
      //   return;
      // }
      // isExpired = false;
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
}

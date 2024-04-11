import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_project/app/store/app_store.dart';
import 'package:graduation_project/app/store/services.dart';
import 'package:graduation_project/app/util/key.dart';
import 'package:graduation_project/manage/firebase_service/notification_service.dart';
import 'package:graduation_project/model/device_token.dart';
import 'package:graduation_project/model/device_token_repo.dart';
import 'package:graduation_project/model/driver_active_nearby.dart';
import 'dart:math' show cos, sqrt, asin;

class GeoFireAssistant extends GetxController {
  static List<DriverActiveNearby> activeDriver = [];
  static Map<String, dynamic> driverSent = {};

  void deleteOfflineDriverFromList(String driverId) {
    bool isDriverInList =
        activeDriver.any((element) => element.driverId == driverId);
    if (isDriverInList) {
      int indexNumber =
          activeDriver.indexWhere((element) => element.driverId == driverId);
      activeDriver.removeAt(indexNumber);
    }
  }

  void updateActiveNearbyDriver(DriverActiveNearby driverWhoMove) {
    int indexNumber = activeDriver
        .indexWhere((element) => element.driverId == driverWhoMove.driverId);
    activeDriver[indexNumber].lat = driverWhoMove.lat;
    activeDriver[indexNumber].lng = driverWhoMove.lng;
  }

  void addDriver(DriverActiveNearby driver) {
    bool isDriverInList =
        activeDriver.any((element) => element.driverId == driver.driverId);
    if (!isDriverInList) {
      activeDriver.add(driver);
    }
  }

  Future<void> sendRequestToDriver(LatLng senderAddress) async {
    String requestId = AppStore.to.lastedRequest.value!.requestId;
    LatLng parcelLatlng = const LatLng(10.802962, 106.715098);
    if (activeDriver.length > 1) {
      activeDriver.sort((driver1, driver2) => calculateDistance(
              parcelLatlng.latitude,
              parcelLatlng.longitude,
              driver1.lat,
              driver1.lng)
          .compareTo(calculateDistance(parcelLatlng.latitude,
              parcelLatlng.longitude, driver2.lat, driver2.lng)));
    }

    DriverActiveNearby? driverReceiver;
    if (driverSent[requestId] == null) {
      driverSent[requestId] = [];
    }

    for (var driver in activeDriver) {
      if (!driverSent[requestId]!.contains(driver.driverId)) {
        driverReceiver = driver;
        DeviceTokenModel deviceTokenModel = await DeviceTokenRepo()
            .getDeviceToken(driverReceiver.driverId as String);

        await NotificationService().sendNotification(
            deviceTokenModel.deviceToken, 'A new request coming', requestId);
        driverSent[requestId]!.add(driverReceiver.driverId as String);
        break;
      }
    }
    await AppServices.to.setString(MyKey.driverSent, jsonEncode(driverSent));
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  bool hasDriverReceivedNotification(String requestId, String driverId) {
    if (driverSent.containsKey(requestId)) {
      return driverSent[requestId]!.contains(driverId);
    } else {
      return false;
    }
  }
}

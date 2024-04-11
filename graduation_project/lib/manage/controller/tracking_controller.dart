import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_project/app/store/app_store.dart';
import 'package:graduation_project/extension/snackbar.dart';
import 'package:graduation_project/manage/controller/geofire_assistant.dart';
import 'package:graduation_project/manage/firebase_service/notification_service.dart';
import 'package:graduation_project/model/driver_active_nearby.dart';
import 'package:graduation_project/model/request.dart';
import 'package:graduation_project/repository/request_repo.dart';

class TrackingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  GoogleMapController? myController;
  RxBool waiting = false.obs;
  RxList<Marker> listMarkers = <Marker>[].obs;
  // RxBool activeNearbyDriverKeysLoad = false.obs;
  Rx<Request?> currentRequest = Rx<Request?>(null);
  RxList<Circle> circleSet = <Circle>[].obs;
  RxList<Request> listRequest = <Request>[].obs;
  late Uint8List iconMarker, delivery;
  AnimationController? animationController;
  Animation<double>? radiusAnimation;

  Future<TrackingController> init() async {
    waiting.value = true;
    NotificationService.onRequestAccept = () => stopAnimate();
    await createUserMarker();
    await getRequest();
    if (currentRequest.value!.driverId.isEmpty) {
      initAnimate();
      addCircle(LatLng(currentRequest.value!.senderAddress['lat'],
          currentRequest.value!.senderAddress['lng']));
    }
    initializeGeoFireListener();

    addMarker(LatLng(currentRequest.value!.senderAddress['lat'],
        currentRequest.value!.senderAddress['lng']));

    waiting.value = false;

    return this;
  }

  @override
  // void onInit() async {
  //   await GeoFireAssistant()
  //       .sendRequestToDriver(const LatLng(21412421, 2414124));
  // }

  @override
  void onClose() {
    animationController!.dispose();
    super.onClose();
  }

  void initAnimate() {
    animationController = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: const Duration(milliseconds: 2000),
    );

    animationController!.repeat(reverse: true);
    animationController!.addListener(() {
      updateCircleRadius(radiusAnimation?.value ?? 0);
    });
  }

  void stopAnimate() async {
    await updateCurrentRequest();
    circleSet.clear();
  }

  Future<void> updateCurrentRequest() async {
    currentRequest.value =
        await RequestRepo().getRequest(AppStore.to.newRequest);
  }

  Future<void> createUserMarker() async {
    iconMarker = await getImageFromMarkers("lib/app/assets/parcels.png", 80);
    delivery = await getImageFromMarkers("lib/app/assets/delivery-man.png", 80);
  }

  Future<void> getAllRequest() async {
    List<Request> requests = await RequestRepo().getAllRequest(AppStore.to.uid);
    listRequest.value = requests;
  }

  // void addCircle(LatLng lng) {
  //   bool hasMyPositionCircle =
  //       circleSet.any((circle) => circle.circleId.value == "My Circle");
  //   if (hasMyPositionCircle) {
  //     circleSet.removeWhere((circle) => circle.circleId.value == "My Circle");
  //   }

  //   Circle myCircle = Circle(
  //     circleId: const CircleId("My Circle"),
  //     center: LatLng(lng.latitude, lng.longitude),
  //     radius: radiusAnimation.value,
  //     fillColor: Colors.blue.withOpacity(0.3),
  //     strokeColor: Colors.blue,
  //     strokeWidth: 1,
  //     visible: true,
  //   );

  //   circleSet.add(myCircle);
  // }

  void addCircle(LatLng lng) {
    bool hasMyPositionCircle =
        circleSet.any((circle) => circle.circleId.value == "My Circle");
    if (hasMyPositionCircle) {
      circleSet.removeWhere((circle) => circle.circleId.value == "My Circle");
    }

    // Initialize radius animation
    radiusAnimation =
        Tween<double>(begin: 200, end: 700).animate(animationController!);

    Circle myCircle = Circle(
      circleId: const CircleId("My Circle"),
      center: LatLng(lng.latitude, lng.longitude),
      radius: radiusAnimation?.value ?? 0,
      fillColor: Colors.blue.withOpacity(0.2),
      strokeColor: Colors.blue,
      strokeWidth: 1,
      visible: true,
    );

    circleSet.add(myCircle);
  }

  void updateCircleRadius(double value) {
    // Find the circle with the given ID and update its radius
    Circle? myCircle = circleSet
        .firstWhereOrNull((circle) => circle.circleId.value == "My Circle");
    if (myCircle != null) {
      circleSet.remove(myCircle);
      circleSet.add(myCircle.copyWith(radiusParam: value));
    }
  }

  void addMarker(LatLng lng) {
    bool hasMyPositionMarker =
        listMarkers.any((marker) => marker.markerId.value == "My Parcel");
    if (hasMyPositionMarker) {
      listMarkers.removeWhere((marker) => marker.markerId.value == "My Parcel");
    }

    Marker myMarker = Marker(
        icon: BitmapDescriptor.fromBytes(iconMarker),
        markerId: const MarkerId("My Parcel"),
        position: lng,
        infoWindow: const InfoWindow(title: "My Parcel"));

    listMarkers.add(myMarker);
  }

  Future<Uint8List> getImageFromMarkers(String path, int width) async {
    ByteData byteData = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
        byteData.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return (await frameInfo.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> getRequest() async {
    Request? request = await RequestRepo().getRequest(AppStore.to.newRequest);
    if (request != null) {
      currentRequest.value = request;
      return;
    }
    MyDialogs.error(msg: "Something went wrong. Please try again");
  }

  initializeGeoFireListener() {
    Geofire.initialize("activeDrivers");

    double lat = currentRequest.value!.senderAddress['lat'];
    double lng = currentRequest.value!.senderAddress['lng'];

    try {
      Geofire.queryAtLocation(lat, lng, 2)!.listen((event) async {
        if (event != null) {
          var callBack = event['callBack'];
          switch (callBack) {
            case Geofire.onKeyEntered:
              DriverActiveNearby driver = DriverActiveNearby();
              driver.lat = event['latitude'];
              driver.lng = event['longitude'];
              driver.driverId = event['key'];
              GeoFireAssistant().addDriver(driver);
              disPlayActiveDriver();
              if (currentRequest.value!.driverId.isEmpty) {
                LatLng currentRequest = LatLng(
                    AppStore.to.lastedRequest.value!.senderAddress['lat'],
                    AppStore.to.lastedRequest.value!.senderAddress['lng']);
                await GeoFireAssistant().sendRequestToDriver(currentRequest);
              }
              break;
            case Geofire.onKeyExited:
              GeoFireAssistant().deleteOfflineDriverFromList(event['key']);
              disPlayActiveDriver();
              break;
            case Geofire.onKeyMoved:
              DriverActiveNearby driver = DriverActiveNearby();
              driver.lat = event['latitude'];
              driver.lng = event['longitude'];
              driver.driverId = event['key'];
              GeoFireAssistant().updateActiveNearbyDriver(driver);
              disPlayActiveDriver();
              break;

            case Geofire.onGeoQueryReady:
              // activeNearbyDriverKeysLoad.value = true;
              disPlayActiveDriver();
              break;
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  disPlayActiveDriver() {
    for (int i = listMarkers.length - 1; i > 0; i--) {
      listMarkers.removeAt(i);
    }
    // circleSet.clear();

    for (var driver in GeoFireAssistant.activeDriver) {
      LatLng eachDriverPosition = LatLng(driver.lat ?? 0.0, driver.lng ?? 0.0);
      Marker marker = Marker(
          markerId: MarkerId(driver.driverId ?? ""),
          position: eachDriverPosition,
          icon: BitmapDescriptor.fromBytes(delivery),
          rotation: 360);
      listMarkers.add(marker);
    }
  }
}

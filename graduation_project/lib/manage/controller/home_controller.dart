import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_project/extension/snackbar.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  final Completer<GoogleMapController> myController = Completer();

  LatLng pGooglePlex = const LatLng(10.824240392004183, 106.77339922423332);

  final List<Marker> myMarkers = [];
  final RxList<Marker> listMarkers = <Marker>[].obs;

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

  Future<void> moveCamera(LatLng lng) async {
    GoogleMapController controller = await myController.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: lng, zoom: 15)));
  }

  void addMarker(LatLng lng) async {
    bool hasMyPositionMarker =
        listMarkers.any((marker) => marker.markerId.value == "My Position");
    if (hasMyPositionMarker) {
      listMarkers
          .removeWhere((marker) => marker.markerId.value == "My Position");
    }

    final Uint8List iconMarker =
        await getImageFromMarkers("lib/app/assets/warehouse.png", 40);

    Marker myMarker = Marker(
        icon: BitmapDescriptor.fromBytes(iconMarker),
        markerId: const MarkerId("My Position"),
        position: lng,
        infoWindow: const InfoWindow(title: "My Position"));
    listMarkers.add(myMarker);
    moveCamera(lng);
  }

  Future<void> getCurrentPosition() async {
    bool serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      MyDialogs.error(msg: "Location Permissions are denied ");
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        MyDialogs.error(msg: "Location Permissions are denied ");
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      MyDialogs.error(
          msg:
              'Location permission are permanently denied,we can not request permission');
      return;
    }
    var position = await Geolocator.getCurrentPosition();
    LatLng currentPosition = LatLng(position.latitude, position.longitude);
    addMarker(currentPosition);
  }
}

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_project/app/util/key.dart';
import 'package:graduation_project/manage/firebase_service/notification_service.dart';
import 'package:graduation_project/model/device_token.dart';
import 'package:graduation_project/model/device_token_repo.dart';
import 'package:graduation_project/model/parcel.dart';
import 'package:graduation_project/model/request.dart';
import 'package:graduation_project/model/request_multi.dart';
import 'package:graduation_project/repository/parcel_repo.dart';
import 'package:graduation_project/repository/request_repo.dart';

class DetailTripController extends GetxController {
  var params = Get.arguments['request'];
  dynamic request;
  Rx<GoogleMapController?> ggController = Rx<GoogleMapController?>(null);
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  PolylinePoints polylinePoints = PolylinePoints();
  RxList<Marker> listMarkers = <Marker>[].obs;
  late Uint8List iconMarker;
  late Rx<LatLngBounds> bounds;
  static RxBool notiConfirm = false.obs;
  Rx<Parcel?> parcel = Rx<Parcel?>(null);
  RxBool isLoading = true.obs;
  RxList<Map<String, dynamic>> listReceiver = <Map<String, dynamic>>[].obs;

  Future<DetailTripController> init() async {
    isLoading.value = true;
    request = params;
    if (request is Request) {
      LatLng sender =
          LatLng(request.senderAddress['lat'], request.senderAddress['lng']);
      LatLng receiver = LatLng(
          request.receiverAddress['lat'], request.receiverAddress['lng']);
      parcel.value = await ParcelRepo().getParcelInfor(request.parcelId);

      await createUserMarker();
      addMarker(sender);
      addDestination(receiver);
      await drawPolyline(sender, receiver);
      // calculateBounds();
      isLoading.value = false;
      return this;
    }
    if (request is RequestMulti) {
      LatLng sender =
          LatLng(request.senderAddress['lat'], request.senderAddress['lng']);

      for (var map in request.receiverAddress) {
        listReceiver.add(map);
      }
      // LatLng receiver = LatLng(
      //     request.receiverAddress['lat'], request.receiverAddress['lng']);
      // parcel.value = await ParcelRepo().getParcelInfor(request.parcelId);

      await createUserMarker();
      addMarker(sender);
      for (int i = 0; i < listReceiver.length; i++) {
        addMultiDestination(
            i, LatLng(listReceiver[i]['lat'], listReceiver[i]['lng']));
        await drawPolyline(
            listMarkers[i].position, listMarkers[i + 1].position);
      }

      // await drawPolyline(sender, receiver);

      isLoading.value = false;
      return this;
    }

    return this;
  }

  Future<void> createUserMarker() async {
    iconMarker =
        await getImageFromMarkers("lib/app/assets/userposition.png", 120);
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

  void addMultiDestination(int index, LatLng lng) {
    Marker destinationMarker = Marker(
        markerId: MarkerId("Destination $index"),
        position: lng,
        infoWindow: InfoWindow(title: "Destination $index"));
    listMarkers.add(destinationMarker);
  }

  void addDestination(LatLng lng) {
    bool hasDestinationMarker =
        listMarkers.any((marker) => marker.markerId.value == "Destination");
    if (hasDestinationMarker) {
      listMarkers
          .removeWhere((marker) => marker.markerId.value == "Destination");
    }
    Marker destinationMarker = Marker(
        markerId: const MarkerId("Destination"),
        position: lng,
        infoWindow: const InfoWindow(title: "Destination"));
    listMarkers.add(destinationMarker);
  }

  void addMarker(LatLng lng) {
    bool hasMyPositionMarker =
        listMarkers.any((marker) => marker.markerId.value == "My Position");
    if (hasMyPositionMarker) {
      listMarkers
          .removeWhere((marker) => marker.markerId.value == "My Position");
    }

    Marker myMarker = Marker(
        icon: BitmapDescriptor.fromBytes(iconMarker),
        markerId: const MarkerId("My Position"),
        position: lng,
        infoWindow: const InfoWindow(title: "My Position"));
    listMarkers.add(myMarker);
  }

  Future<void> drawPolyline(LatLng sender, LatLng receiver) async {
    try {
      List<LatLng> polylineCoordinates = [];
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        MyKey.ggApiKey,
        PointLatLng(sender.latitude, sender.longitude),
        PointLatLng(receiver.latitude, receiver.longitude),
        travelMode: TravelMode.driving,
      );
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      }

      Polyline polyline = Polyline(
          polylineId: const PolylineId('nearest_neighbor_polyline'),
          color: Colors.blue,
          points: polylineCoordinates,
          width: 5);

      polylines.add(polyline);
    } catch (e) {
      print(e);
    }
  }

  void calculateBounds() {
    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLong = double.infinity;
    double maxLong = -double.infinity;

    for (final marker in listMarkers) {
      final lat = marker.position.latitude;
      final long = marker.position.longitude;
      minLat = lat < minLat ? lat : minLat;
      maxLat = lat > maxLat ? lat : maxLat;
      minLong = long < minLong ? long : minLong;
      maxLong = long > maxLong ? long : maxLong;
    }

    bounds = LatLngBounds(
      southwest: LatLng(minLat, minLong),
      northeast: LatLng(maxLat, maxLong),
    ).obs;

    _moveCameraToFitBounds();
  }

  void _moveCameraToFitBounds() {
    final CameraUpdate cameraUpdate =
        CameraUpdate.newLatLngBounds(bounds.value, 50);
    ggController.value!.animateCamera(cameraUpdate);
  }

  Future<void> confirmPickupSuccess() async {
    // await RequestRepo().updateStatus(request!.requestId, 'on delivery');
    DeviceTokenModel deviceTokenModel =
        await DeviceTokenRepo().getDeviceToken(request!.driverId);
    await NotificationService().sendNotification(
        deviceTokenModel.deviceToken, 'Confirm success', 'Confirm success', {
      'requestId': request.requestId,
      'requestType': request.type,
    });
  }

  Future<void> confirmPickupSuccessSaving() async {
    // await RequestRepo().updateStatus(request!.requestId, 'on delivery');
    DeviceTokenModel deviceTokenModel =
        await DeviceTokenRepo().getDeviceToken(request!.driverId);
    await NotificationService().sendNotification(
        deviceTokenModel.deviceToken, 'Confirm success', 'Confirm success', {
      'requestId': request.requestId,
      'requestType': request.type,
    });
  }

  Future<void> confirmPickupMultiSuccess() async {
    // await RequestRepo().updateStatusMulti(request.requestId, 'on delivery');
    DeviceTokenModel deviceTokenModel =
        await DeviceTokenRepo().getDeviceToken(request.driverId);
    await NotificationService().sendNotification(
        deviceTokenModel.deviceToken, 'Confirm success', 'Confirm success', {
      'requestId': request.requestId,
      'requestType': 'requestMulti',
    });
  }
}

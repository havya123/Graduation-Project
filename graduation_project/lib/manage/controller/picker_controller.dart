import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_project/extension/snackbar.dart';
import 'package:graduation_project/model/place.dart';

class PickerController extends GetxController {
  // static PickerController get to => Get.find();

  // final Completer<GoogleMapController> myController = Completer();
  // RxBool waiting = true.obs;
  // Rx<Place>? pickPlace;
  // Rx<Place>? destination;

  // Rx<LatLng>? currentPosition;
  // final RxSet<Polyline> polylines = <Polyline>{}.obs;
  // PolylinePoints polylinePoints = PolylinePoints();

  // final List<Marker> myMarkers = [];
  // final RxList<Marker> listMarkers = <Marker>[].obs;

  // @override
  // void onInit() async {

  //   super.onInit();
  // }

  // List<LatLng> listLatLng = [];

  // Future<void> addListMarkers() async {
  //   for (int i = 0; i < listLatLng.length; i++) {
  //     if (i == 0) {
  //       final Uint8List iconMarker =
  //           await getImageFromMarkers("lib/app/assets/warehouse.png", 60);

  //       Marker homeBase = Marker(
  //           icon: BitmapDescriptor.fromBytes(iconMarker),
  //           markerId: const MarkerId("My Position"),
  //           position: listLatLng[i],
  //           infoWindow: const InfoWindow(title: "My Position"));
  //       listMarkers.add(homeBase);
  //     } else {
  //       Marker marker = Marker(
  //           markerId: MarkerId("Position $i"),
  //           position: listLatLng[i],
  //           infoWindow: InfoWindow(title: "Position $i"));

  //       listMarkers.add(marker);
  //     }
  //   }
  // }

  // Future<Uint8List> getImageFromMarkers(String path, int width) async {
  //   ByteData byteData = await rootBundle.load(path);
  //   ui.Codec codec = await ui.instantiateImageCodec(
  //       byteData.buffer.asUint8List(),
  //       targetHeight: width);
  //   ui.FrameInfo frameInfo = await codec.getNextFrame();
  //   return (await frameInfo.image.toByteData(format: ui.ImageByteFormat.png))!
  //       .buffer
  //       .asUint8List();
  // }

  // Future<void> moveCamera(LatLng lng) async {
  //   GoogleMapController controller = await myController.future;
  //   controller.animateCamera(
  //       CameraUpdate.newCameraPosition(CameraPosition(target: lng, zoom: 15)));
  // }

  // Future<void> addMarker(LatLng lng) async {
  //   bool hasMyPositionMarker =
  //       listMarkers.any((marker) => marker.markerId.value == "My Position");
  //   if (hasMyPositionMarker) {
  //     listMarkers
  //         .removeWhere((marker) => marker.markerId.value == "My Position");
  //   }

  //   final Uint8List iconMarker =
  //       await getImageFromMarkers("lib/app/assets/userposition.png", 120);

  //   Marker myMarker = Marker(
  //       icon: BitmapDescriptor.fromBytes(iconMarker),
  //       markerId: const MarkerId("My Position"),
  //       position: lng,
  //       infoWindow: const InfoWindow(title: "My Position"));
  //   listMarkers.add(myMarker);
  //   moveCamera(lng);
  // }

  // Future<void> getCurrentPosition() async {
  //   try {
  //     bool serviceEnable = await Geolocator.isLocationServiceEnabled();
  //     if (!serviceEnable) {
  //       MyDialogs.error(msg: "Location Permissions are denied ");
  //       return;
  //     }
  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         MyDialogs.error(msg: "Location Permissions are denied ");
  //         return;
  //       }
  //     }
  //     if (permission == LocationPermission.deniedForever) {
  //       MyDialogs.error(
  //           msg:
  //               'Location permission are permanently denied,we can not request permission');
  //       return;
  //     }
  //     var position = await Geolocator.getCurrentPosition();
  //     currentPosition = LatLng(position.latitude, position.longitude).obs;
  //     await addMarker(LatLng(
  //         currentPosition!.value.latitude, currentPosition!.value.longitude));
  //   } catch (e) {
  //     return MyDialogs.error(
  //         msg: "Something went wrong. Please try again later");
  //   }
  // }

  //   Future<void> getPlaceByAttitude(String keyword) async {
  //   final String url =
  //       "https://maps.googleapis.com/maps/api/geocode/json?latlng=$keyword&key=AIzaSyCYyiIDdbZMRqbLG0VMfR-go_5sO-JN6Dc";

  //   final uri = Uri.parse(url);
  //   var response = await http.get(uri);
  //   Map<String, dynamic> data = jsonDecode(response.body);
  //   List location = data['results'];
  //   if (location.isEmpty) {
  //     return;
  //   }
  //   Map<String, dynamic> dataLocation = location[0];
  //   pickPlace = Place(
  //           name: dataLocation['address_components'][1]['long_name'],
  //           address: dataLocation['formatted_address'],
  //           lat: dataLocation['geometry']['location']['lat'],
  //           lng: dataLocation['geometry']['location']['lng'])
  //       .obs;
  // }

  // Future<void> drawPolylines(int index) async {
  //   try {
  //     if (index >= listLatLng.length - 1) {
  //       // Stop drawing polylines if all points have been connected
  //       return;
  //     }

  //     LatLng currentPoint = listLatLng[index];
  //     LatLng nextPoint = listLatLng[index + 1];

  //     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //       'Your-API-Key',
  //       PointLatLng(currentPoint.latitude, currentPoint.longitude),
  //       PointLatLng(nextPoint.latitude, nextPoint.longitude),
  //       travelMode: TravelMode.driving,
  //     );

  //     List<LatLng> polylineCoordinates = [];
  //     if (result.points.isNotEmpty) {
  //       for (var point in result.points) {
  //         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //       }
  //     }

  //     Polyline polyline = Polyline(
  //       polylineId: PolylineId('nearest_neighbor_polyline_$index'),
  //       color: Colors.blue,
  //       points: polylineCoordinates,
  //       width: 3,
  //     );

  //     polylines.add(polyline);

  //     await Future.delayed(const Duration(seconds: 1));
  //     drawPolylines(index + 1);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<void> savePickLocation() async {}
}

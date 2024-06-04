import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_project/app/route/route_name.dart';
import 'package:graduation_project/app/store/app_store.dart';
import 'package:graduation_project/app/store/services.dart';
import 'package:graduation_project/extension/snackbar.dart';
import 'package:graduation_project/model/auto_complete_prediction.dart';
import 'package:graduation_project/model/place.dart';
import 'package:graduation_project/model/place_auto_complete_response.dart';
import 'package:graduation_project/repository/parcel_repo.dart';
import 'package:graduation_project/repository/place_repo.dart';
import 'package:graduation_project/repository/request_repo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;
import '../../app/util/key.dart';

class CreateRequestMultiController extends GetxController {
  static CreateRequestMultiController get to =>
      Get.find<CreateRequestMultiController>();
  RxInt activateStep = 0.obs;
  RxList<RxList<XFile?>> listImage = <RxList<XFile?>>[].obs;
  RxInt countImage = 0.obs;
  GoogleMapController? myController;
  RxBool waiting = false.obs;
  Rx<Place?> pickPlace = Rx<Place?>(null);

  RxList<Place> listDestination = <Place>[].obs;
  late Rx<LatLngBounds> bounds;

  RxBool isChoosedExpress = false.obs;
  RxBool isChoosedSaving = false.obs;
  RxBool senderPay = true.obs;
  RxBool cash = false.obs;
  RxBool banking = false.obs;
  RxDouble priceExpress = 0.0.obs;
  RxDouble priceSaving = 0.0.obs;
  RxBool isConfirmRoute = false.obs;
  RxBool isFocusPick = false.obs;

  RxList<AutoCompletePrediction> pickPrediction =
      <AutoCompletePrediction>[].obs;

  RxList<AutoCompletePrediction> destinationPrediction =
      <AutoCompletePrediction>[].obs;
  final formKey = GlobalKey<FormState>();
  // RxDouble cost

  Rx<LatLng>? currentPosition;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  PolylinePoints polylinePoints = PolylinePoints();

  // final List<Marker> myMarkers = [];
  RxList<Marker> listMarkers = <Marker>[].obs;
  late Rx<TextEditingController> pickPlaceSearch;
  List<TextEditingController> listWeightController = [];
  List<TextEditingController> listDimensionController = [];
  late TextEditingController senderName;
  late TextEditingController senderPhone;
  late TextEditingController senderNote;
  List<TextEditingController> listReceiverName = [];
  List<TextEditingController> listReceiverPhone = [];
  List<TextEditingController> listReceiverNote = [];
  late TextEditingController searchPlace;
  late Uint8List iconMarker;

  @override
  void onInit() async {
    waiting.value = true;
    pickPlaceSearch = TextEditingController().obs;
    senderName = TextEditingController();
    senderPhone = TextEditingController();
    senderNote = TextEditingController();
    searchPlace = TextEditingController();
    await createUserMarker();
    if (currentPosition == null) {
      await getCurrentPosition();
      await getPlaceByAttitude(
          "${currentPosition?.value.latitude},${currentPosition?.value.longitude}");
      waiting.value = false;
    }

    waiting.value = false;
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    // Cleanup resources here
    pickPlaceSearch.close();
    senderName.dispose();
    senderPhone.dispose();
    senderNote.dispose();
    searchPlace.dispose();
    for (var controller in listWeightController) {
      controller.dispose();
    }
    for (var controller in listDimensionController) {
      controller.dispose();
    }
    for (var controller in listReceiverName) {
      controller.dispose();
    }
    for (var controller in listReceiverPhone) {
      controller.dispose();
    }
    for (var controller in listReceiverNote) {
      controller.dispose();
    }
    listImage.close(); // Close all RxList<XFile?> streams
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

  void moveCamera(LatLng lng) {
    try {
      myController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: lng, zoom: 15),
        ),
      );
    } catch (e) {
      MyDialogs.error(msg: "Something went wrong");
    }
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
    moveCamera(lng);
  }

  Future<void> getCurrentPosition() async {
    try {
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

      if (currentPosition == null) {
        var position = await Geolocator.getCurrentPosition();
        currentPosition = LatLng(position.latitude, position.longitude).obs;
        addMarker(LatLng(
            currentPosition!.value.latitude, currentPosition!.value.longitude));
        return;
      }
      addMarker(LatLng(
          currentPosition!.value.latitude, currentPosition!.value.longitude));
      await getPlaceByAttitude(
          "${currentPosition?.value.latitude},${currentPosition?.value.longitude}");
    } catch (e) {
      return MyDialogs.error(
          msg: "Something went wrong. Please try again later");
    }
  }

  Future<void> getPlaceByAttitude(String keyword) async {
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$keyword&key=${MyKey.ggApiKey}";

    final uri = Uri.parse(url);
    var response = await http.get(uri);
    Map<String, dynamic> data = jsonDecode(response.body);
    List location = data['results'];
    if (location.isEmpty) {
      return;
    }
    Map<String, dynamic> dataLocation = location[0];
    pickPlace.value = Place(
        name: dataLocation['address_components'][1]['long_name'],
        address: dataLocation['formatted_address'],
        lat: dataLocation['geometry']['location']['lat'],
        lng: dataLocation['geometry']['location']['lng']);
    pickPlaceSearch.value.text = pickPlace.value!.address;
  }

  void onPopDestination() {
    listDestination.value = [];
    bool hasDestinationMarker =
        listMarkers.any((marker) => marker.markerId.value == "Destination");
    if (hasDestinationMarker) {
      listMarkers
          .removeWhere((marker) => marker.markerId.value == "Destination");
    }
  }

  void onPopPickScreen() {
    pickPlace.value = null;
    currentPosition = null;
    bool hasPickPlace =
        listMarkers.any((marker) => marker.markerId.value == "My Position");
    if (hasPickPlace) {
      listMarkers
          .removeWhere((marker) => marker.markerId.value == "My Position");
    }
    listMarkers.clear();
    listDestination.clear();
  }

  Future<void> drawPolyline() async {
    try {
      List<LatLng> polylineCoordinates = [];
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        MyKey.ggApiKey,
        PointLatLng(listMarkers[0].position.latitude,
            listMarkers[0].position.longitude),
        PointLatLng(listMarkers[1].position.latitude,
            listMarkers[1].position.longitude),
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
          width: 3);

      polylines.add(polyline);
    } catch (e) {
      print(e);
    }
  }

  Future<void> pickImageFromGallery(int index) async {
    var status = await Permission.storage.request();
    if (status.isDenied) {
      await Permission.storage.request();
    }
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    listImage[index].add(returnImage);
    // countImage.value = listImageSelect.length;
  }

  Future<void> pickImageFromCamera(int index) async {
    var status = await Permission.camera.request();
    if (status.isDenied) {
      return Future.error("Storage permission is denied");
    }
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    listImage[index].add(returnImage);
    // countImage.value = listImageSelect.length;
  }

  void addListDestinationMarker(LatLng lng, String id) {
    Marker destinationMarker = Marker(
        markerId: MarkerId("Destination $id"),
        position: lng,
        infoWindow: const InfoWindow(title: "Destination"));
    listMarkers.add(destinationMarker);
  }

  void removeMarker(String id) {
    listMarkers.removeWhere(
        (element) => element.markerId == MarkerId("Destination $id"));
  }

  void searchPickAutoComplete(String query) async {
    String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=${MyKey.ggApiKey}';

    String? response = await PlaceRepo().fetchUrl(url);
    if (response != null) {
      PlaceAutoComplete result = PlaceAutoComplete.parseAutoComplete(response);
      if (result.prediction != null) {
        pickPrediction.value = result.prediction!;
      }
    }
  }

  void searchDesAutoComplete(String query) async {
    String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=${MyKey.ggApiKey}';

    String? response = await PlaceRepo().fetchUrl(url);
    if (response != null) {
      PlaceAutoComplete result = PlaceAutoComplete.parseAutoComplete(response);
      if (result.prediction != null) {
        destinationPrediction.value = result.prediction!;
      }
    }
  }

  Future<void> searchByPlaceId(String id) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$id&key=${MyKey.ggApiKey}";
    final uri = Uri.parse(url);
    var response = await http.get(uri);
    Map<String, dynamic> data = jsonDecode(response.body);
    print(data);
    Map<String, dynamic> dataLocation = data['result'];
    if (!checkLocation(dataLocation['formatted_address'])) {
      MyDialogs.error(
          msg: "You can not choose place outside of Ho Chi Minh City");
      return;
    }
    if (dataLocation.isEmpty) {
      return;
    }
    pickPlace.value = Place(
        name: dataLocation['address_components'][1]['long_name'],
        address: dataLocation['formatted_address'],
        lat: dataLocation['geometry']['location']['lat'],
        lng: dataLocation['geometry']['location']['lng']);
    pickPlaceSearch.value.text = pickPlace.value!.address;
    addMarker(LatLng(pickPlace.value!.lat, pickPlace.value!.lng));
  }

  Future<void> onTapPickScreen(LatLng lng) async {
    addMarker(lng);
    await getPlaceByAttitude("${lng.latitude},${lng.longitude}");

    // else {
    //   addDestination(lng);
    //   await getDestinationByAttitude("${lng.latitude},${lng.longitude}");
    // }
  }

  Future<void> onSelectDestination(String id) async {
    if (listDestination.any((place) => place.placeId! == id)) {
      MyDialogs.error(msg: "You have added same address");
      return;
    }
    final String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$id&key=${MyKey.ggApiKey}";
    final uri = Uri.parse(url);
    var response = await http.get(uri);
    Map<String, dynamic> data = jsonDecode(response.body);
    print(data);
    Map<String, dynamic> dataLocation = data['result'];
    if (!checkLocation(dataLocation['formatted_address'])) {
      MyDialogs.error(msg: "Please select area in Ho Chi Minh City");
      return;
    }
    Place? destination;
    destination = Place(
        placeId: id,
        name: dataLocation['address_components'][1]['long_name'],
        address: dataLocation['formatted_address'],
        lat: dataLocation['geometry']['location']['lat'],
        lng: dataLocation['geometry']['location']['lng']);
    listDestination.add(destination);
    addListDestinationMarker(LatLng(destination.lat, destination.lng), id);
  }

  void deleteDestination(int index, String id) {
    listDestination.removeAt(index);
    removeMarker(id);
    print(listMarkers);
  }

  bool checkLocation(String location) {
    if (location.contains("Hồ Chí Minh") || location.contains("Ho Chi Minh")) {
      return true;
    } else {
      return false;
    }
  }

  void addParcelInfor() {
    listReceiverName.clear();
    listReceiverPhone.clear();
    listReceiverNote.clear();
    listDimensionController.clear();
    listWeightController.clear();
    listImage.clear();
    for (int i = 0; i < listDestination.length; i++) {
      listReceiverName.add(TextEditingController());
      listReceiverPhone.add(TextEditingController());
      listReceiverNote.add(TextEditingController());
      listDimensionController.add(TextEditingController());
      listWeightController.add(TextEditingController());
      listImage.add(<XFile?>[].obs);
    }
  }

  void deleteImage(int index, int index1) {
    listImage[index].removeAt(index1);
    // countImage.value = listImageSelect.length;
  }

  bool checkAllFiled() {
    for (int i = 0; i < listDimensionController.length; i++) {
      if (listDimensionController[i].text.isEmpty) {
        return false;
      }
    }
    for (int i = 0; i < listWeightController.length; i++) {
      if (listWeightController[i].text.isEmpty) {
        return false;
      }
    }
    for (int i = 0; i < listImage.length; i++) {
      if (listImage[i].isEmpty) {
        return false;
      }
    }
    return true;
  }

  bool checkDetailInfor() {
    for (int i = 0; i < listReceiverName.length; i++) {
      if (listReceiverName[i].text.isEmpty) {
        return false;
      }
    }
    for (int i = 0; i < listReceiverPhone.length; i++) {
      if (listReceiverPhone[i].text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  Future<void> drawPolylines() async {
    try {
      final stopwatch = Stopwatch()..start();
      List<Place> listTemp = [];
      List<LatLng> polylineCoordinates = [];
      List<Marker> remainingMarkers = List.from(listMarkers); // Create a copy
      Marker startMarker = listMarkers[0];

      while (remainingMarkers.length > 1) {
        remainingMarkers.remove(startMarker);
        Marker nearestMarker =
            _findNearestMarker(startMarker, remainingMarkers);

        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          MyKey.ggApiKey,
          PointLatLng(
              startMarker.position.latitude, startMarker.position.longitude),
          PointLatLng(nearestMarker.position.latitude,
              nearestMarker.position.longitude),
          travelMode: TravelMode.driving,
        );

        if (result.points.isNotEmpty) {
          for (var point in result.points) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          }
        }

        polylineCoordinates
            .add(nearestMarker.position); // Connect to nearest point

        Polyline polyline = Polyline(
          polylineId: PolylineId(
              'nearest_neighbor_polyline_${polylineCoordinates.length}'),
          color: Colors.blue,
          points: polylineCoordinates,
          width: 3,
        );

        polylines.add(polyline);
        startMarker = nearestMarker;

        Place place = findPlace(nearestMarker);
        listTemp.add(place);

        // Remove the current index 0 marker from the copy
      }
      listDestination.clear();
      listDestination.value = listTemp;
      stopwatch.stop();
      print('Function Execution Time : ${stopwatch.elapsed}');
    } catch (e) {
      print(e);
    }
  }

  double _routeDistance(List<Marker> route) {
    double totalDistance = 0;
    for (int i = 0; i < route.length - 1; i++) {
      totalDistance +=
          _calculateDistance(route[i].position, route[i + 1].position);
    }
    return totalDistance;
  }

  Marker _findNearestMarker(Marker currentPoint, List<Marker> markers) {
    double minDistance = double.infinity;
    Marker nearestMarker = currentPoint;

    for (int i = 0; i < markers.length; i++) {
      Marker markerPoint = markers[i];
      double distance =
          _calculateDistance(currentPoint.position, markerPoint.position);
      if (distance < minDistance) {
        minDistance = distance;
        nearestMarker = markerPoint;
      }
    }

    return nearestMarker;
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    const int earthRadius = 6371000; // Bán kính Trái đất tính bằng mét
    double lat1 = math.pi * point1.latitude / 180; // Chuyển đổi độ sang radian
    double lon1 = math.pi * point1.longitude / 180;
    double lat2 = math.pi * point2.latitude / 180;
    double lon2 = math.pi * point2.longitude / 180;

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = math.pow(math.sin(dLat / 2), 2) +
        math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(dLon / 2), 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distance = earthRadius * c;

    return distance; // Khoảng cách tính bằng mét
  }

  Place findPlace(Marker marker) {
    Place place = listDestination.firstWhere(
      (p0) =>
          p0.lat == marker.position.latitude &&
          p0.lng == marker.position.longitude,
    );
    return place;
  }

  void choosePaymentMethod(bool isCheck) {
    if (cash.value) {
      cash.value = false;
      banking.value = true;
      return;
    }
    cash.value = true;
    banking.value = false;
  }

  Future<List<String>> createParcel() async {
    try {
      List<String> listParcelId = [];
      for (int i = 0; i < listDestination.length; i++) {
        String parcelId = await ParcelRepo().createParcel(
            listImage[i],
            int.parse(listDimensionController[i].text),
            double.parse(listWeightController[i].text));
        listParcelId.add(parcelId);
      }

      MyDialogs.success(msg: "Create Parcel Successfully");
      return listParcelId;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createRequestMulti() async {
    try {
      MyDialogs.showProgress();
      List<String> listParcel = await createParcel();
      List<Map<String, dynamic>> listAddress = convertPlacesToMaps();
      String paymentMethod = cash.value ? "cash" : "banking";

      Map<String, dynamic> senderAddress = {
        'senderAddres': pickPlace.value!.address,
        'lat': pickPlace.value!.lat,
        'lng': pickPlace.value!.lng,
      };

      String requestId = await RequestRepo().createRequestMulti(
        AppStore.to.uid.value,
        senderPhone.text,
        senderAddress,
        listAddress,
        listParcel,
        paymentMethod,
        'senderPay',
        0,
        'waiting',
      );
      for (int i = 0; i < listParcel.length; i++) {
        ParcelRepo().updateRequestId(listParcel[i], requestId);
      }
      AppStore.to.newRequest = requestId;
      AppServices.to.setString(MyKey.newRequest, requestId);
      MyDialogs.success(msg: "You have created request successfully");
      Get.offAllNamed(
        RouteName.trackingRoute,
        parameters: {'type': 'multi'},
      );
    } catch (e) {
      MyDialogs.error(msg: "Something went wrong. Please try again");
      Get.back();
    }
  }

  List<Map<String, dynamic>> convertPlacesToMaps() {
    List<Map<String, dynamic>> listAddress = [];
    for (int i = 0; i < listDestination.length; i++) {
      listAddress.add({
        'receiverName': listReceiverName[i].text,
        'receiverPhone': listReceiverPhone[i].text,
        'receiverNote': listReceiverNote[i].text,
        'receiverAddress': listDestination[i].address,
        'lat': listDestination[i].lat,
        'lng': listDestination[i].lng,
      });
    }

    return listAddress;
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
    if (myController != null) {
      final CameraUpdate cameraUpdate =
          CameraUpdate.newLatLngBounds(bounds.value, 50);
      myController!.animateCamera(cameraUpdate);
    }
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_project/app/route/route_name.dart';
import 'package:graduation_project/app/store/app_store.dart';
import 'package:graduation_project/app/store/services.dart';
import 'package:graduation_project/app/util/key.dart';
import 'package:graduation_project/extension/snackbar.dart';
import 'package:graduation_project/model/auto_complete_prediction.dart';
import 'package:graduation_project/model/place.dart';
import 'package:graduation_project/model/place_auto_complete_response.dart';
import 'package:graduation_project/repository/parcel_repo.dart';
import 'package:graduation_project/repository/place_repo.dart';
import 'package:graduation_project/repository/request_repo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'dart:math' show cos, sqrt, asin;

class RequestController extends GetxController {
  static RequestController get to => Get.find<RequestController>();
  RxInt activateStep = 0.obs;
  RxList<XFile?> listImageSelect = <XFile>[].obs;
  RxInt countImage = 0.obs;
  GoogleMapController? myController;
  RxBool waiting = true.obs;
  Rx<Place?> pickPlace = Rx<Place?>(null);
  Rx<Place?> destination = Rx<Place?>(null);
  RxBool isChoosedExpress = false.obs;
  RxBool isChoosedSaving = false.obs;
  RxBool senderPay = false.obs;
  RxBool receiverPay = false.obs;
  RxBool cash = false.obs;
  RxBool banking = false.obs;
  RxDouble priceExpress = 0.0.obs;
  RxDouble priceSaving = 0.0.obs;
  RxBool isFocusPick = false.obs;
  RxBool isFocusDes = false.obs;
  RxBool isConfirmRoute = false.obs;
  late Rx<LatLngBounds> bounds;

  final formKey = GlobalKey<FormState>();
  // RxDouble cost

  Rx<LatLng>? currentPosition;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  PolylinePoints polylinePoints = PolylinePoints();

  RxList<AutoCompletePrediction> pickPrediction =
      <AutoCompletePrediction>[].obs;

  RxList<AutoCompletePrediction> destinationPrediction =
      <AutoCompletePrediction>[].obs;

  // final List<Marker> myMarkers = [];
  RxList<Marker> listMarkers = <Marker>[].obs;
  late Rx<TextEditingController> pickPlaceSearch;
  late Rx<TextEditingController> destinationSearch;
  late TextEditingController dimensionController;
  late TextEditingController weightController;
  late TextEditingController senderName;
  late TextEditingController senderPhone;
  late TextEditingController senderNote;
  late TextEditingController receiverName;
  late TextEditingController receiverPhone;
  late TextEditingController receiverNote;
  late Uint8List iconMarker;

  @override
  void onInit() async {
    dimensionController = TextEditingController();
    weightController = TextEditingController();
    senderName = TextEditingController();
    senderPhone = TextEditingController();
    senderNote = TextEditingController();
    receiverName = TextEditingController();
    receiverPhone = TextEditingController();
    receiverNote = TextEditingController();
    pickPlaceSearch = TextEditingController().obs;
    destinationSearch = TextEditingController().obs;
    await createUserMarker();

    if (currentPosition == null) {
      await getCurrentPosition();
      await getPlaceByAttitude(
          "${currentPosition?.value.latitude},${currentPosition?.value.longitude}");
      waiting.value = false;
    } else {
      waiting.value = false;
    }

    super.onInit();
  }

  bool isValidate() {
    if (dimensionController.text.isEmpty || weightController.text.isEmpty) {
      return false;
    }
    if (isChoosedExpress.value == false && isChoosedSaving.value == false) {
      return false;
    }

    if (destination.value == null || pickPlace.value == null) {
      return false;
    }
    return true;
  }

  void chooseOption(bool isCheck) {
    if (isChoosedExpress.value) {
      isChoosedExpress.value = false;
      isChoosedSaving.value = true;
      return;
    }
    isChoosedExpress.value = true;
    isChoosedSaving.value = false;
  }

  void choosePayer(bool isCheck) {
    if (senderPay.value) {
      senderPay.value = false;
      receiverPay.value = true;
      return;
    }
    senderPay.value = true;
    receiverPay.value = false;
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

  void searchPickAutoComplete(String query) async {
    pickPrediction.clear();
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
    destinationPrediction.clear();
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

  Future<void> createUserMarker() async {
    iconMarker =
        await getImageFromMarkers("lib/app/assets/userposition.png", 120);
  }

  Future<void> pickImageHouseFromGallery() async {
    var status = await Permission.storage.request();
    if (status.isDenied) {
      await Permission.storage.request();
    }
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    listImageSelect.add(returnImage);
    countImage.value = listImageSelect.length;
  }

  Future<void> pickImageHouseFromCamera() async {
    var status = await Permission.camera.request();
    if (status.isDenied) {
      return Future.error("Storage permission is denied");
    }
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    listImageSelect.add(returnImage);
    countImage.value = listImageSelect.length;
  }

  void deleteImage(int index) {
    listImageSelect.removeAt(index);
    countImage.value = listImageSelect.length;
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
        // await getPlaceByAttitude(
        //     "${currentPosition?.value.latitude},${currentPosition?.value.longitude}");
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

  Future<void> getDestinationByAttitude(String keyword) async {
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
    destination.value = Place(
        name: dataLocation['address_components'][1]['long_name'],
        address: dataLocation['formatted_address'],
        lat: dataLocation['geometry']['location']['lat'],
        lng: dataLocation['geometry']['location']['lng']);
    destinationSearch.value.text = destination.value!.address;
  }

  void onPopPickScreen() {
    pickPlace.value = null;
    isConfirmRoute.value = false;
    bool hasPickPlace =
        listMarkers.any((marker) => marker.markerId.value == "My Position");
    if (hasPickPlace) {
      listMarkers
          .removeWhere((marker) => marker.markerId.value == "My Position");
    }
    destination.value = null;
    bool hasDestinationMarker =
        listMarkers.any((marker) => marker.markerId.value == "Destination");
    if (hasDestinationMarker) {
      listMarkers
          .removeWhere((marker) => marker.markerId.value == "Destination");
    }
    pickPlaceSearch.value.clear();
    destinationSearch.value.clear();
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

  Future<String> createParcel() async {
    try {
      String parcelId = await ParcelRepo().createParcel(
          listImageSelect,
          int.parse(dimensionController.text),
          double.parse(weightController.text));

      MyDialogs.success(msg: "Create Parcel Successfully");
      return parcelId;
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<void> createRequest() async {
    try {
      String parcelId = await createParcel();
      String type = isChoosedExpress.value ? "express" : "saving";
      String paymentMethod = cash.value ? "cash" : "banking";
      String payer = senderPay.value ? "senderPay" : "receiverPay";
      Map<String, dynamic> senderAddress = {
        'senderAddres': pickPlace.value!.address,
        'lat': pickPlace.value!.lat,
        'lng': pickPlace.value!.lng,
      };

      Map<String, dynamic> receiverAddress = {
        'receiverAddress': destination.value!.address,
        'lat': destination.value!.lat,
        'lng': destination.value!.lng,
      };

      String requestId = await RequestRepo().createRequest(
          AppStore.to.uid,
          senderPhone.text,
          receiverPhone.text,
          senderAddress,
          receiverAddress,
          type,
          parcelId,
          paymentMethod,
          payer,
          isChoosedExpress.value ? priceExpress.value : priceSaving.value,
          "waiting");
      await ParcelRepo().updateRequestId(parcelId, requestId);
      AppStore.to.newRequest = requestId;
      AppServices.to.setString(MyKey.newRequest, requestId);
      MyDialogs.success(msg: "You have created request successfully");
      Get.offNamed(RouteName.trackingRoute);
    } catch (e) {
      MyDialogs.error(msg: "Something went wrong. Please try again");
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double calculatePriceExpress(double distanceInKm) {
    const double initialDistance = 3.0; // First 3 km
    const double initialPrice = 26000; // Price for the first 3 km
    const double pricePerKm = 4000; // Price for each additional km

    double price = initialPrice; // Initialize with the price for the first 3 km

    if (distanceInKm > initialDistance) {
      double additionalKm = distanceInKm - initialDistance;
      price += additionalKm * pricePerKm; // Add the price for additional km
    }

    return price.ceilToDouble();
  }

  double calculatePriceSaving(double distanceInKm) {
    const double initialDistance = 2.0; // First 3 km
    const double initialPrice = 12000; // Price for the first 3 km
    const double pricePerKm = 4000; // Price for each additional km

    double price = initialPrice; // Initialize with the price for the first 3 km

    if (distanceInKm > initialDistance) {
      double additionalKm = distanceInKm - initialDistance;
      price += additionalKm * pricePerKm; // Add the price for additional km
    }

    return price.ceilToDouble();
  }

  void checkDistanceExpress() {
    double distance = calculateDistance(
      pickPlace.value!.lat,
      pickPlace.value!.lng,
      destination.value!.lat,
      destination.value!.lng,
    );

    priceExpress.value = calculatePriceExpress(distance);
    print('Price: ${priceExpress.value} VND');
  }

  void checkDistanceSaving() {
    double distance = calculateDistance(
      pickPlace.value!.lat,
      pickPlace.value!.lng,
      destination.value!.lat,
      destination.value!.lng,
    );

    priceSaving.value = calculatePriceSaving(distance);
    print('Price: ${priceSaving.value} VND');
  }

  Future<void> onTapPickScreen(LatLng lng) async {
    if (pickPlace.value == null) {
      addMarker(lng);
      await getPlaceByAttitude("${lng.latitude},${lng.longitude}");
    } else {
      addDestination(lng);
      await getDestinationByAttitude("${lng.latitude},${lng.longitude}");
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

  Future<void> searchByPlaceDesId(String id) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$id&key=${MyKey.ggApiKey}";
    final uri = Uri.parse(url);
    var response = await http.get(uri);
    Map<String, dynamic> data = jsonDecode(response.body);
    print(data);
    Map<String, dynamic> dataLocation = data['result'];
    if (dataLocation.isEmpty) {
      return;
    }
    destination.value = Place(
        name: dataLocation['address_components'][1]['long_name'],
        address: dataLocation['formatted_address'],
        lat: dataLocation['geometry']['location']['lat'],
        lng: dataLocation['geometry']['location']['lng']);
    destinationSearch.value.text = destination.value!.address;
    addDestination(LatLng(destination.value!.lat, destination.value!.lng));
    isConfirmRoute.value = false;
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

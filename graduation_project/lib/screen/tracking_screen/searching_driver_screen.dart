import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_project/manage/controller/tracking_controller.dart';

class TrackingScreen extends GetView<TrackingController> {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.waiting.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Obx(
          () {
            LatLng requestPosition = LatLng(
                controller.currentRequest.value!.senderAddress['lat'],
                controller.currentRequest.value!.senderAddress['lng']);
            return GoogleMap(
              markers: Set<Marker>.of(controller.listMarkers),
              mapType: MapType.normal,
              circles: Set<Circle>.of(controller.circleSet),
              initialCameraPosition:
                  CameraPosition(target: requestPosition, zoom: 15),
              onMapCreated: (GoogleMapController clr) {
                controller.myController = clr;
              },
            );
          },
        );
      }),
    );
  }
}

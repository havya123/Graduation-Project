import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_project/app/util/const.dart';
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
            LatLng requestPosition;
            if (controller.currentRequest.value == null) {
              requestPosition = LatLng(
                  controller.currentRequestMulti.value!.senderAddress['lat'],
                  controller.currentRequestMulti.value!.senderAddress['lng']);
            } else {
              requestPosition = LatLng(
                  controller.currentRequest.value!.senderAddress['lat'],
                  controller.currentRequest.value!.senderAddress['lng']);
            }
            return Stack(
              children: [
                GoogleMap(
                  markers: Set<Marker>.of(controller.listMarkers),
                  mapType: MapType.normal,
                  circles: Set<Circle>.of(controller.circleSet),
                  initialCameraPosition:
                      CameraPosition(target: requestPosition, zoom: 15),
                  onMapCreated: (GoogleMapController clr) {
                    controller.myController = clr;
                  },
                ),
                Positioned(
                    left: getWidth(context, width: 0.02),
                    bottom: getHeight(context),
                    child: GestureDetector(
                      onTap: () async {
                        await controller.cancelRequest();
                      },
                      child: Container(
                        width: getWidth(context, width: 0.8),
                        height: getHeight(context, height: 0.07),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            "Cancle",
                            style: mediumTextStyle(context),
                          ),
                        ),
                      ),
                    ))
              ],
            );
          },
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_project/app/util/const.dart';
import 'package:graduation_project/manage/controller/create_request_controller.dart';
import 'package:graduation_project/widgets/button.dart';

class DestinationScreen extends StatelessWidget {
  const DestinationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<RequestController>();
    bool isConfirmRoute = false;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Obx(() {
          if (controller.waiting.isTrue) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Stack(
            children: [
              Obx(
                () {
                  return GoogleMap(
                    onTap: (argument) {
                      // controller.listLatLng.add(argument);
                      controller.polylines.clear();
                      controller.addDestination(argument);
                      controller.getDestinationByAttitude(
                          "${argument.latitude},${argument.longitude}");
                    },
                    polylines: Set<Polyline>.of(controller.polylines),
                    markers: Set<Marker>.of(controller.listMarkers),
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                        target: controller.currentPosition?.value ??
                            LatLng(controller.pickPlace.value!.lat,
                                controller.pickPlace.value!.lng),
                        zoom: 15),
                    onMapCreated: (GoogleMapController clr) {
                      controller.myController = clr;
                    },
                  );
                },
              ),
              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                  onPressed: () {
                    controller.polylines.clear();
                    //controller.onPopDestination();
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: getHeight(context, height: 0.25),
                  width: getWidth(context, width: 1),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 10, right: 10, bottom: 5),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            width: getWidth(context, width: 0.9),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color.fromARGB(255, 217, 217, 217),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_pin,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                  spaceWidth(context),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          controller.destination.value?.name ??
                                              "",
                                          style:
                                              largeTextStyle(context, size: 15),
                                        ),
                                        Text(
                                          controller
                                                  .destination.value?.address ??
                                              "",
                                          style:
                                              smallTextStyle(context, size: 12),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        spaceHeight(context, height: 0.02),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ButtonWidget(
                              borderRadius: 5,
                              function: () {
                                if (isConfirmRoute == true) {
                                  return;
                                }
                                controller.drawPolyline();
                                isConfirmRoute = true;
                              },
                              textButton: "Destination Confirm",
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

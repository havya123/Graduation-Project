import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_project/app/route/route_name.dart';
import 'package:graduation_project/app/util/const.dart';
import 'package:graduation_project/manage/controller/create_request_controller.dart';
import 'package:graduation_project/widgets/button.dart';

class PickerScreen extends StatelessWidget {
  const PickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<RequestController>();
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
                  print(controller.listMarkers);
                  print(controller.currentPosition);
                  return GoogleMap(
                    onTap: (argument) {
                      // controller.listLatLng.add(argument);
                      controller.addMarker(argument);
                      controller.getPlaceByAttitude(
                          "${argument.latitude},${argument.longitude}");
                    },
                    polylines: Set<Polyline>.of(controller.polylines),
                    markers: Set<Marker>.of(controller.listMarkers),
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                        target: controller.currentPosition?.value ??
                            const LatLng(10.82411061294854, 106.62992475965073),
                        zoom: 15),
                    onMapCreated: (GoogleMapController clr) {
                      controller.myController = clr;
                    },
                  );
                },
              ),
              Positioned(
                  right: 0,
                  bottom: getHeight(context, height: 0.23),
                  child: IconButton(
                    icon: const Icon(Icons.location_searching),
                    onPressed: () {
                      controller.getCurrentPosition();
                    },
                  )),
              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                  onPressed: () {
                    controller.onPopPickScreen();
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
                                          controller.pickPlace.value?.name ??
                                              "",
                                          style:
                                              largeTextStyle(context, size: 15),
                                        ),
                                        Text(
                                          controller.pickPlace.value?.address ??
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
                              function: () =>
                                  Get.toNamed(RouteName.destinationRoute),
                              textButton: "Pick Location",
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

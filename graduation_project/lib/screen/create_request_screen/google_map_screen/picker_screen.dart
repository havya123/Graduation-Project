import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_project/app/route/route_name.dart';
import 'package:graduation_project/app/util/const.dart';
import 'package:graduation_project/manage/controller/create_request_controller.dart';
import 'package:graduation_project/widgets/button.dart';
import 'package:graduation_project/widgets/input_widget.dart';

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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(
              kToolbarHeight + 10), // Adjust the height as needed
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: AppBar(
              leading: Padding(
                padding: EdgeInsets.only(
                  left: getWidth(context, width: 0.01),
                ),
                child: IconButton(
                  onPressed: () {
                    Get.back();
                    controller.onPopPickScreen();
                  },
                  icon: Icon(
                    Icons.arrow_back_outlined,
                    size: getWidth(context, width: 0.08),
                    color: Colors.black,
                  ),
                ),
              ),
              title: Text(
                "Pickup",
                style: smallTextStyle(context,
                    fontWeight: FontWeight.bold, size: 18),
              ),
              elevation: 0, // Remove default elevation
            ),
          ),
        ),
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
                    onTap: (argument) async {
                      await controller.onTapPickScreen(argument);
                      // // controller.listLatLng.add(argument);
                      // controller.addMarker(argument);
                      // controller.getPlaceByAttitude(
                      //     "${argument.latitude},${argument.longitude}");
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
                  bottom: getHeight(context, height: 0.25),
                  child: IconButton(
                    icon: const Icon(Icons.location_searching),
                    onPressed: () {
                      controller.getCurrentPosition();
                    },
                  )),
              Positioned(
                top: 0,
                child: SizedBox(
                  width: getWidth(context, width: 1),
                  child: Column(
                    children: [
                      Obx(() {
                        return TextFieldWidget(
                          isFocus: controller.isFocusPick,
                          icon: Image.asset(
                            "lib/app/assets/userposition.png",
                            scale: 15,
                          ),
                          hint: "",
                          hintText: "Enter pick location",
                          controller: controller.pickPlaceSearch.value,
                          removeBorder: true,
                          borderRadius: 0,
                          textColor: Colors.black,
                          function: (p0) =>
                              controller.searchPickAutoComplete(p0!),
                        );
                      }),
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        color: grey,
                      ),
                      Obx(() {
                        return TextFieldWidget(
                          isFocus: controller.isFocusDes,
                          hint: "",
                          hintText: "Enter destination",
                          icon: Image.asset(
                            "lib/app/assets/placeholder.png",
                            scale: 15,
                          ),
                          controller: controller.destinationSearch.value,
                          removeBorder: true,
                          borderRadius: 0,
                          function: (p0) =>
                              controller.searchDesAutoComplete(p0!),
                        );
                      }),
                      Obx(() {
                        if (controller.isFocusPick.value ||
                            controller.isFocusDes.value) {
                          return Container(
                            height: getHeight(context, height: 0.5),
                            width: getWidth(context, width: 1),
                            color: Colors.white,
                            child: Obx(() {
                              if (controller.isFocusPick.value) {
                                return ListView.separated(
                                    itemBuilder: (context, index) {
                                      return LocationListTitle(
                                          location: controller
                                              .pickPrediction[index]
                                              .description!,
                                          press: () async {
                                            controller.searchByPlaceId(
                                                controller.pickPrediction[index]
                                                    .placeId!);
                                            controller.isFocusPick.value =
                                                false;
                                          });
                                    },
                                    separatorBuilder: (context, index) =>
                                        spaceHeight(context, height: 0.01),
                                    itemCount:
                                        controller.pickPrediction.length);
                              }
                              if (controller.isFocusDes.value) {
                                return ListView.separated(
                                    itemBuilder: (context, index) {
                                      return LocationListTitle(
                                          location: controller
                                              .destinationPrediction[index]
                                              .description!,
                                          press: () {
                                            controller.searchByPlaceDesId(
                                                controller
                                                    .destinationPrediction[
                                                        index]
                                                    .placeId!);
                                            controller.isFocusDes.value = false;
                                          });
                                    },
                                    separatorBuilder: (context, index) =>
                                        spaceHeight(context, height: 0.01),
                                    itemCount: controller
                                        .destinationPrediction.length);
                              }
                              return const SizedBox();
                            }),
                          );
                        }
                        return const SizedBox();
                      })
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Obx(() {
                  if (controller.pickPlace.value == null ||
                      controller.destination.value == null) {
                    return const SizedBox();
                  }
                  return Container(
                    height: getHeight(context, height: 0.1),
                    width: getWidth(context, width: 1),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 10, right: 10, bottom: 5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ButtonWidget(
                          borderRadius: 5,
                          function: () {
                            if (controller.isConfirmRoute.isFalse) {
                              controller.drawPolyline();
                              controller.calculateBounds();
                              controller.isConfirmRoute.value = true;
                              return;
                            }
                            Get.back();
                            controller.checkDistanceExpress();
                            controller.checkDistanceSaving();
                          },
                          textButton: controller.isConfirmRoute.value
                              ? "Confirm Route"
                              : "Check Route",
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class LocationListTitle extends StatelessWidget {
  LocationListTitle({super.key, required this.location, required this.press});
  String location;
  VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: press,
          horizontalTitleGap: 0,
          leading: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              FontAwesomeIcons.locationArrow,
              size: getWidth(context, width: 0.06),
              color: Colors.black,
            ),
          ),
          title: Text(
            location,
            style: smallTextStyle(context),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

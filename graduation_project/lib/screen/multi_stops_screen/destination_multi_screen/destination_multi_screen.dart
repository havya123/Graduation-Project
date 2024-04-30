import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_project/app/route/route_name.dart';
import 'package:graduation_project/app/util/const.dart';
import 'package:graduation_project/manage/controller/create_multi_request_controller.dart';
import 'package:graduation_project/model/place.dart';
import 'package:graduation_project/widgets/button.dart';

class DestinationMultiScreen extends StatelessWidget {
  const DestinationMultiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CreateRequestMultiController>();
    bool isConfirmRoute = false;
    return Scaffold(
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
                    // controller.polylines.clear();
                    // controller.addDestination(argument);
                    // controller.getDestinationByAttitude(
                    //     "${argument.latitude},${argument.longitude}", 0);
                    // print(controller.polylines);
                  },
                  polylines: Set<Polyline>.of(controller.polylines),
                  markers: Set<Marker>.of(controller.listMarkers),
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(controller.pickPlace.value!.lat,
                          controller.pickPlace.value!.lng),
                      zoom: 15),
                  onMapCreated: (GoogleMapController clr) {
                    controller.myController = clr;
                  },
                );
              },
            ),
            Positioned(
              top: getHeight(context, height: 0.05),
              left: getWidth(context),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ),
              // IconButton(
              //   onPressed: () {
              //     controller.polylines.clear();
              //     controller.onPopDestination();
              //     Get.back();
              //   },
              //   icon: const Icon(Icons.arrow_back_ios),
              // ),
            ),
            Positioned(
                bottom: getHeight(context, height: 0.3),
                right: getWidth(context),
                child: GestureDetector(
                  onTap: () {
                    controller.polylines.clear();
                    // controller.moveCamera(LatLng(
                    //     controller.pickPlace.value!.lat,
                    //     controller.pickPlace.value!.lng));
                  },
                  child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.white,
                      child:
                          const Center(child: Icon(Icons.location_searching))),
                )),
            DraggableScrollableSheet(
              initialChildSize: 0.2,
              minChildSize: 0.2,
              maxChildSize: 0.5,
              builder: (context, scrollController) {
                return Obx(() {
                  return Container(
                    color: Colors.white,
                    child: ListView.separated(
                        controller: scrollController,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Column(
                              children: [
                                Divider(
                                  color: Colors.grey,
                                  height: 1,
                                  thickness: 4,
                                  endIndent: getWidth(context, width: 0.4),
                                  indent: getWidth(context, width: 0.4),
                                ),
                                const Center(
                                  child: Text("Scroll up to see more"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: ButtonWidget(
                                    borderRadius: 5,
                                    function: () async {
                                      controller.addParcelInfor();
                                      Get.toNamed(RouteName.multiRoute);
                                    },
                                    textButton: "Confirm Destination",
                                  ),
                                ),
                              ],
                            );
                          }
                          return LocationListTitle(
                              location:
                                  controller.listDestination[index - 1].address,
                              press: () {
                                controller.moveCamera(LatLng(
                                    controller.listDestination[index - 1].lat,
                                    controller.listDestination[index - 1].lng));
                              });
                        },
                        separatorBuilder: (context, index) =>
                            spaceHeight(context),
                        itemCount: controller.listDestination.length + 1),
                  );
                });
              },
            ),
          ],
        );
      }),
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
        spaceHeight(context, height: 0.02),
      ],
    );
  }
}

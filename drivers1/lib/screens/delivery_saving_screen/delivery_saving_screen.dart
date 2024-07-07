import 'package:drivers/app/util/const.dart';
import 'package:drivers/controller/delivery_saving_controller.dart';
import 'package:drivers/screens/delivery_saving_screen/destination_widget/destination_widget.dart';
import 'package:drivers/screens/delivery_saving_screen/pickup_widget/pickup_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliverySavingScreen extends GetView<DeliverySavingController> {
  const DeliverySavingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton:
      //     FloatingActionButton(onPressed: () => controller.optimizeRoute()),
      body: SafeArea(child: Obx(() {
        if (controller.waiting.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return SizedBox(
            width: getWidth(context, width: 1),
            height: getHeight(context, height: 1),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 4,
                      child: Container(
                        width: getWidth(context, width: 1),
                        color: const Color(0xff363A45),
                        child: Column(
                          children: [
                            Obx(() {
                              return Text(
                                controller.isPick.value
                                    ? "1. Pickup Goods"
                                    : "2. Destination",
                                style: mediumTextStyle(context,
                                    color: Colors.green.shade400),
                              );
                            }),
                            Obx(() {
                              return TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                        title: const Center(
                                            child: Text('Destination')),
                                        content: SizedBox(
                                          height:
                                              getHeight(context, height: 0.5),
                                          width: getWidth(context, width: 0.5),
                                          child: ListView.separated(
                                              itemBuilder: (context, index) {
                                                return TextButton(
                                                  onPressed: () async {
                                                    // controller.onSelectDestination(
                                                    //     controller.listDestination[
                                                    //             index]
                                                    //         ['receiverAddress'],
                                                    //     index);
                                                    // controller.checkDistance();
                                                    // Get.back();
                                                  },
                                                  child: Text(controller
                                                      .listDestination[index]),
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) {
                                                return spaceHeight(context);
                                              },
                                              itemCount: controller
                                                  .listDestination.length),
                                        )),
                                  );
                                },
                                child: Text(
                                  controller.nameLocation.value,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                  style: mediumTextStyle(context,
                                      color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                  onTap: () =>
                                      controller.openGoogleMapsDirections(),
                                  child: SizedBox(
                                    width: 35,
                                    height: 35,
                                    child:
                                        Image.asset("lib/app/assets/map.png"),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  Obx(() {
                    return Expanded(
                        flex: 8,
                        child: Stack(
                          children: [
                            Container(
                              color: Colors.black38,
                              child: GoogleMap(
                                polylines:
                                    Set<Polyline>.of(controller.polylines),
                                markers: Set<Marker>.of(controller.listMarkers),
                                mapType: MapType.normal,
                                initialCameraPosition: CameraPosition(
                                    target: controller.currentPosition?.value ??
                                        const LatLng(10.82411061294854,
                                            106.62992475965073),
                                    zoom: controller.zoom.value),
                                onMapCreated: (clr) {
                                  controller.myController = clr;
                                },
                                onCameraMove: (position) {
                                  controller.zoom.value = position.zoom;
                                },
                              ),
                            ),
                            Positioned(
                              bottom: getHeight(context, height: 0.15),
                              right: getWidth(context, width: 0.02),
                              child: IconButton(
                                onPressed: () =>
                                    controller.getCurrentPosition(),
                                icon: const Icon(Icons.location_searching),
                              ),
                            ),
                          ],
                        ));
                  }),
                  Obx(() {
                    if (controller.currentRequest.value!
                            .senderAddress['senderAddres'] ==
                        controller.nameLocation.value) {
                      return const PickUpWidget();
                    }
                    if (controller.currentRequest.value!
                            .receiverAddress['receiverAddress'] ==
                        controller.nameLocation.value) {
                      return const DestinationWidget();
                    }
                    return const SizedBox();
                  })
                ]));
      })),
    );
  }
}

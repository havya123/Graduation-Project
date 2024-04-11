import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_project/app/util/const.dart';
import 'package:graduation_project/manage/controller/detail_trip_controller.dart';
import 'package:graduation_project/widgets/button.dart';
import 'package:transparent_image/transparent_image.dart';

class DetailTripScreen extends GetView<DetailTripController> {
  const DetailTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            controller.request!.created,
            style: mediumTextStyle(context, fontWeight: FontWeight.bold),
          ),
          elevation: 5,
          backgroundColor: Colors.white,
          shadowColor: Colors.grey.shade500,
          clipBehavior: Clip.hardEdge,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: getHeight(context, height: 0.95),
                  width: getWidth(context, width: 1),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
                              style: mediumTextStyle(context),
                            ),
                            Text(
                              "${controller.request!.cost}VND",
                              style: mediumTextStyle(context,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(controller.request!.paymentMethod),
                        ),
                      ),
                      spaceHeight(context),
                      Obx(() {
                        return SizedBox(
                            width: getWidth(context, width: 1),
                            height: getHeight(context, height: 0.4),
                            child: GoogleMap(
                              zoomControlsEnabled: false,
                              polylines: Set<Polyline>.of(controller.polylines),
                              markers: Set<Marker>.of(controller.listMarkers),
                              mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      controller.request!.senderAddress['lat'],
                                      controller.request!.senderAddress['lng']),
                                  zoom: 15),
                              onMapCreated: (GoogleMapController clr) {
                                controller.ggController = clr;
                              },
                            ));
                      }),
                      spaceHeight(context),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      Image.asset("lib/app/assets/parcels.png"),
                                ),
                                spaceWidth(context),
                                Text(
                                  "${controller.request!.senderAddress['senderAddres'].split(',').take(2).join(',')}",
                                  style: mediumTextStyle(context, size: 16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: Column(
                                children: [
                                  for (int i = 0; i < 5; i++) ...<Widget>[
                                    spaceHeight(context, height: 0.01),
                                    Icon(
                                      Icons.rectangle,
                                      size: 5,
                                      color: Colors.grey.shade300,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            spaceHeight(context, height: 0.01),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      Image.asset("lib/app/assets/parcels.png"),
                                ),
                                spaceWidth(context),
                                Text(
                                  "${controller.request!.receiverAddress['receiverAddress'].split(',').take(2).join(',')}",
                                  style: mediumTextStyle(context, size: 16),
                                )
                              ],
                            ),
                            spaceHeight(context),
                            if (controller.request!.statusRequest ==
                                "on taking") ...<Widget>[
                              ButtonWidget(
                                function: () async {
                                  await controller.confirmPickupSuccess();
                                },
                                textButton: "Confirm successful pickup",
                              )
                            ]
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                spaceHeight(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Parcel Information",
                    style:
                        mediumTextStyle(context, fontWeight: FontWeight.w600),
                  ),
                ),
                spaceHeight(context, height: 0.02),
                Container(
                  width: getWidth(context, width: 1),
                  height: getHeight(context,
                      height: controller.parcel.value!.imageConfirm.isEmpty
                          ? 0.6
                          : 0.9),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      spaceHeight(context, height: 0.02),
                      SizedBox(
                        height: getHeight(context, height: 0.3),
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                  width: getWidth(context, width: 0.5),
                                  height: getHeight(context, height: 0.3),
                                  clipBehavior: Clip.hardEdge,
                                  decoration: const BoxDecoration(),
                                  child: FadeInImage.memoryNetwork(
                                      fit: BoxFit.contain,
                                      placeholder: kTransparentImage,
                                      image: controller
                                          .parcel.value!.listImage[index]));
                            },
                            separatorBuilder: (context, index) =>
                                spaceWidth(context),
                            itemCount:
                                controller.parcel.value!.listImage.length),
                      ),
                      spaceHeight(context, height: 0.02),
                      Text(
                        "Dimension: ${controller.parcel.value!.dimension} cm",
                        style: mediumTextStyle(context),
                      ),
                      Text(
                        "Dimension: ${controller.parcel.value!.weight} kg",
                        style: mediumTextStyle(context),
                      ),
                      spaceHeight(context),
                      Text("Image Confirm", style: mediumTextStyle(context)),
                      spaceHeight(context),
                      Obx(() {
                        if (controller.parcel.value!.imageConfirm.isEmpty) {
                          return const SizedBox();
                        }
                        return SizedBox(
                          width: getWidth(context, width: 1),
                          height: getHeight(context, height: 0.3),
                          child: FadeInImage.memoryNetwork(
                              fit: BoxFit.contain,
                              placeholder: kTransparentImage,
                              image: controller.parcel.value!.imageConfirm),
                        );
                      })
                    ],
                  ),
                ),
                spaceHeight(context),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Error Report",
                        style: mediumTextStyle(context,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade600),
                      )),
                ),
                spaceHeight(context),
              ],
            ),
          );
        }));
  }
}

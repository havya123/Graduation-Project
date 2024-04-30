import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graduation_project/app/route/route_name.dart';
import 'package:graduation_project/app/util/const.dart';
import 'package:graduation_project/extension/snackbar.dart';
import 'package:graduation_project/manage/controller/create_multi_request_controller.dart';
import 'package:graduation_project/widgets/button.dart';
import 'package:graduation_project/widgets/input_widget.dart';
import 'package:line_icons/line_icons.dart';

class SelectDestination extends StatelessWidget {
  const SelectDestination({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CreateRequestMultiController>();
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(
            left: getWidth(context, width: 0.01),
          ),
          child: CircleAvatar(
            backgroundColor: const Color(0xffEDECED),
            child: Icon(
              FontAwesomeIcons.locationArrow,
              size: getWidth(context, width: 0.06),
              color: Colors.black,
            ),
          ),
        ),
        title: Text(
          "Set Destination Location",
          style: mediumTextStyle(context),
        ),
      ),
      body: Column(
        children: [
          Form(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: TextFieldWidget(
                controller: controller.searchPlace,
                hint: "",
                function: (p0) => controller.searchDesAutoComplete(p0!),
                hintText: "Search Your Location",
                borderRadius: 8,
                removeBorder: true,
                icon: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Icon(
                    LineIcons.searchLocation,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          spaceHeight(context, height: 0.02),
          Divider(
            height: 1,
            thickness: 1,
            color: grey,
          ),
          Obx(() {
            if (controller.listDestination.isEmpty) {
              return const SizedBox();
            }
            return Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        LocationListTitle(
                            location: controller.listDestination[index].address,
                            press: () async {}),
                        Positioned(
                            top: 10,
                            right: 0,
                            child: IconButton(
                                onPressed: () {
                                  controller.polylines.clear();
                                  controller.deleteDestination(
                                      index,
                                      controller
                                          .listDestination[index].placeId!);
                                },
                                icon: const Icon(Icons.remove)))
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return spaceHeight(context, height: 0.02);
                  },
                  itemCount: controller.listDestination.length),
            );
          }),
          Obx(() {
            if (controller.listDestination.isEmpty) {
              return const SizedBox();
            } else {
              return Divider(
                height: 1,
                thickness: 1,
                color: grey,
              );
            }
          }),
          Expanded(
            child: Obx(() {
              if (controller.destinationPrediction.isEmpty) {
                return const SizedBox();
              }
              return ListView.separated(
                  itemBuilder: (context, index) {
                    return LocationListTitle(
                        location: controller
                            .destinationPrediction[index].description!,
                        press: () async {
                          controller.onSelectDestination(
                              controller.destinationPrediction[index].placeId!);
                        });
                  },
                  separatorBuilder: (context, index) {
                    return spaceHeight(context, height: 0.02);
                  },
                  itemCount: controller.destinationPrediction.length);
            }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ButtonWidget(
              function: () async {
                if (controller.listDestination.isEmpty) {
                  MyDialogs.error(msg: "Please add some destinations");
                  return;
                }
                await controller.drawPolylines();
                Get.toNamed(RouteName.destinationMultiRoute);
                return;
              },
              textButton: "Next",
              borderRadius: 8,
            ),
          )
        ],
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
          leading: Icon(
            FontAwesomeIcons.locationArrow,
            size: getWidth(context, width: 0.06),
            color: Colors.black,
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

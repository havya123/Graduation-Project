import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graduation_project/app/route/route_name.dart';
import 'package:graduation_project/app/util/const.dart';
import 'package:graduation_project/extension/snackbar.dart';
import 'package:graduation_project/manage/controller/create_multi_request_controller.dart';
import 'package:graduation_project/manage/controller/custom_stepper_multi_controller.dart';
import 'package:graduation_project/widgets/button.dart';
import 'package:graduation_project/widgets/select_image.dart';

import '../../../widgets/input_widget.dart';

class BasicInforMultiScreen extends StatelessWidget {
  const BasicInforMultiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CreateRequestMultiController>();
    var stepperController = Get.find<CustomStepperMultiController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spaceHeight(context),
          Text(
            "Select location",
            style: mediumTextStyle(context, color: Colors.white),
          ),
          spaceHeight(context, height: 0.02),
          Container(
            width: double.infinity,
            height: controller.listDestination.length < 2
                ? getHeight(context, height: 0.3)
                : controller.listDestination.length < 3
                    ? getHeight(context, height: 0.45)
                    : controller.listDestination.length < 6
                        ? getHeight(context, height: 0.6)
                        : getHeight(context, height: 0.8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xff202020),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                children: [
                  Column(
                    children: [
                      Icon(
                        FontAwesomeIcons.locationDot,
                        color: green,
                      ),
                      if (controller.listDestination.isEmpty)
                        ...List.generate(
                            6,
                            (index) => Icon(
                                  Icons.arrow_drop_down,
                                  size: 14,
                                  color: green,
                                )),
                      if (controller.listDestination.isNotEmpty)
                        ...List.generate(
                            7,
                            (index) => Icon(
                                  Icons.arrow_drop_down,
                                  size: 14,
                                  color: green,
                                )),
                      Icon(
                        FontAwesomeIcons.locationDot,
                        color: green,
                      ),
                    ],
                  ),
                  spaceWidth(context, width: 0.02),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Collect from",
                          style: smallTextStyle(context, color: Colors.white),
                        ),
                        Obx(() {
                          return Text(
                            controller.pickPlace.value?.address ??
                                "Sender address",
                            maxLines: 2,
                            style: mediumTextStyle(context,
                                size: 14, color: Colors.white),
                          );
                        }),
                        spaceHeight(context, height: 0.06),
                        Text(
                          "Receiver address",
                          style: smallTextStyle(context, color: Colors.white),
                        ),
                        Obx(() {
                          return ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Text(
                                  controller.listDestination[index].address,
                                  style: smallTextStyle(context,
                                      color: Colors.white, size: 14),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  spaceHeight(context, height: 0.02),
                              itemCount: controller.listDestination.length);
                        }),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {
                          Get.toNamed(RouteName.pickupMultiRoute);

                          // controller.polylines.clear();
                        },
                        icon: const Icon(
                          FontAwesomeIcons.pencil,
                          size: 16,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
          ),
          spaceHeight(context),
          TextButton(
              onPressed: () => Get.toNamed(RouteName.fillPacelInforRoute),
              child: Text(
                "Fill Parcel Information >>",
                style: mediumTextStyle(context, color: Colors.white),
              )),
          spaceHeight(context, height: 0.1),
          Row(
            children: [
              Expanded(
                child: ButtonWidget(
                  function: () => Get.back(),
                  textButton: "Cancel",
                ),
              ),
              spaceWidth(context),
              Expanded(
                child: ButtonWidget(
                  function: () {
                    // if (controller.isValidate()) {
                    if (controller.listDestination.isEmpty) {
                      MyDialogs.error(msg: "Please select destinations");
                      return;
                    }
                    if (controller.checkAllFiled()) {
                      stepperController.nextStep();
                      return;
                    }
                    MyDialogs.error(msg: "Please fill all fields of parcels");
                    return;

                    // } else {
                    //   MyDialogs.error(msg: "Please fill all information");
                    //   return;
                    // }
                  },
                  textButton: "Continue",
                ),
              ),
            ],
          ),
          spaceHeight(context),
        ],
      ),
    );
  }
}

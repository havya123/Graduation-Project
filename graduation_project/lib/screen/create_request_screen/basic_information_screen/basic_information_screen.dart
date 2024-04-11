import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graduation_project/app/route/route_name.dart';
import 'package:graduation_project/app/util/const.dart';
import 'package:graduation_project/extension/snackbar.dart';
import 'package:graduation_project/manage/controller/custom_stepper_controller.dart';
import 'package:graduation_project/screen/create_request_screen/basic_information_screen/collect_type_widget/collect_widget.dart';
import 'package:graduation_project/widgets/button.dart';
import 'package:graduation_project/widgets/input_widget.dart';
import 'package:graduation_project/widgets/select_image.dart';

import '../../../manage/controller/create_request_controller.dart';

class BasicInformationScreen extends StatelessWidget {
  const BasicInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controllerStepper = Get.find<CustomStepperController>();
    var controllerRequest = Get.find<RequestController>();
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
            height: getHeight(context, height: 0.32),
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
                      for (int i = 0; i < 5; i++) ...[
                        Icon(
                          Icons.arrow_drop_down,
                          size: 14,
                          color: green,
                        ),
                      ],
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
                            controllerRequest.pickPlace.value?.address ??
                                "Sender address",
                            style: mediumTextStyle(context,
                                size: 14, color: Colors.white),
                          );
                        }),
                        spaceHeight(context, height: 0.06),
                        Text(
                          "Delivery to",
                          style: smallTextStyle(context, color: Colors.white),
                        ),
                        Obx(() {
                          return Text(
                            controllerRequest.destination.value?.address ??
                                "Receive address",
                            style: smallTextStyle(context,
                                color: Colors.white, size: 12),
                          );
                        }),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {
                          Get.toNamed(RouteName.pickerRoute);

                          controllerRequest.polylines.clear();
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
          Text(
            "Collect time",
            style: mediumTextStyle(context, color: Colors.white),
          ),
          spaceHeight(context, height: 0.02),
          SizedBox(
            height: getHeight(context, height: 0.2),
            width: double.infinity,
            child: Row(
              children: [
                CollectWidget(
                  title: "Express",
                  collectTime: "Collect time 10-20 min",
                  timeReceive: "15-30mins",
                  isChecked: (p0) {
                    controllerRequest.chooseOption(p0!);
                  },
                  isChoosed: controllerRequest.isChoosedExpress,
                  price: controllerRequest.priceExpress,
                ),
                spaceWidth(context),
                CollectWidget(
                  title: "Saving",
                  collectTime: "Collect time 30-40min",
                  timeReceive: "1-2 hour",
                  isChecked: (p0) {
                    controllerRequest.chooseOption(p0!);
                  },
                  isChoosed: controllerRequest.isChoosedSaving,
                  price: controllerRequest.priceSaving,
                ),
              ],
            ),
          ),
          spaceHeight(context, height: 0.04),
          Text(
            "Upload your package image",
            style: mediumTextStyle(context, color: Colors.white),
          ),
          spaceHeight(context),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const ImageSelected();
                      });
                },
                child: Container(
                  width: getWidth(context, width: 0.4),
                  height: getHeight(context, height: 0.15),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      SizedBox(
                          width: getWidth(context, width: 0.3),
                          height: getHeight(context, height: 0.08),
                          child: const Center(
                            child: Icon(
                              FontAwesomeIcons.camera,
                              size: 20,
                              color: Colors.white,
                            ),
                          )),
                      Text(
                        "Thêm ảnh",
                        style: mediumTextStyle(context,
                            color: Colors.white, size: 18),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          spaceHeight(context),
          Obx(() {
            if (controllerRequest.listImageSelect.isEmpty) {
              return const SizedBox();
            }
            return SizedBox(
              height: getHeight(context, height: 0.2),
              child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          width: getWidth(context, width: 0.5),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Image.file(
                            File(
                                controllerRequest.listImageSelect[index]!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            onPressed: () {
                              controllerRequest.deleteImage(index);
                            },
                            icon: const Icon(FontAwesomeIcons.xmark),
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => spaceWidth(context),
                  itemCount: controllerRequest.listImageSelect.length),
            );
          }),
          spaceHeight(context),
          Text(
            "Good Details",
            style: smallTextStyle(context, color: Colors.white, size: 14),
          ),
          spaceHeight(context, height: 0.02),
          Container(
            width: double.infinity,
            height: getHeight(context, height: 0.28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xff202020),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFieldWidget(
                    type: TextInputType.number,
                    borderRadius: 20,
                    color: lightGrey,
                    hintText: 'Enter dimension *cm',
                    hint: '',
                    maxline: 1,
                    controller: controllerRequest.dimensionController,
                  ),
                  spaceHeight(context, height: 0.02),
                  TextFieldWidget(
                    type: TextInputType.number,
                    borderRadius: 20,
                    color: lightGrey,
                    hintText: 'Enter weight *Kg',
                    hint: '',
                    maxline: 1,
                    controller: controllerRequest.weightController,
                  ),
                ],
              ),
            ),
          ),
          spaceHeight(context),
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
                    if (controllerRequest.isValidate()) {
                      controllerStepper.nextStep();
                    } else {
                      MyDialogs.error(msg: "Please fill all information");
                      return;
                    }
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

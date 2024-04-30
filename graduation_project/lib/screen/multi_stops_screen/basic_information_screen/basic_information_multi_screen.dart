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
            height: controller.listDestination.isEmpty
                ? getHeight(context, height: 0.3)
                : getHeight(context, height: 0.45),
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
                            5,
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
          // spaceHeight(context),
          // Text(
          //   "Collect time",
          //   style: mediumTextStyle(context, color: Colors.white),
          // ),
          // spaceHeight(context, height: 0.02),
          // SizedBox(
          //   height: getHeight(context, height: 0.2),
          //   width: double.infinity,
          //   child: const Row(
          //     children: [],
          //   ),
          // ),
          // spaceHeight(context, height: 0.04),
          // Text(
          //   "Upload your package image",
          //   style: mediumTextStyle(context, color: Colors.white),
          // ),
          // spaceHeight(context),
          // Row(
          //   children: [
          //     GestureDetector(
          //       onTap: () {
          //         showModalBottomSheet(
          //             context: context,
          //             builder: (context) {
          //               return const ImageSelected();
          //             });
          //       },
          //       child: Container(
          //         width: getWidth(context, width: 0.4),
          //         height: getHeight(context, height: 0.15),
          //         decoration: BoxDecoration(
          //             color: Colors.transparent,
          //             border: Border.all(color: Colors.white),
          //             borderRadius: BorderRadius.circular(20)),
          //         child: Column(
          //           children: [
          //             SizedBox(
          //                 width: getWidth(context, width: 0.3),
          //                 height: getHeight(context, height: 0.08),
          //                 child: const Center(
          //                   child: Icon(
          //                     FontAwesomeIcons.camera,
          //                     size: 20,
          //                     color: Colors.white,
          //                   ),
          //                 )),
          //             Text(
          //               "Thêm ảnh",
          //               style: mediumTextStyle(context,
          //                   color: Colors.white, size: 18),
          //             )
          //           ],
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // spaceHeight(context),
          // Obx(() {
          //   if (controller.listImageSelect.isEmpty) {
          //     return const SizedBox();
          //   }
          //   return SizedBox(
          //     height: getHeight(context, height: 0.2),
          //     child: ListView.separated(
          //         shrinkWrap: true,
          //         scrollDirection: Axis.horizontal,
          //         itemBuilder: (context, index) {
          //           return Stack(
          //             children: [
          //               Container(
          //                 width: getWidth(context, width: 0.5),
          //                 clipBehavior: Clip.hardEdge,
          //                 decoration: BoxDecoration(
          //                     borderRadius: BorderRadius.circular(20)),
          //                 child: Image.file(
          //                   File(controller.listImageSelect[index]!.path),
          //                   fit: BoxFit.cover,
          //                 ),
          //               ),
          //               Positioned(
          //                 right: 0,
          //                 top: 0,
          //                 child: IconButton(
          //                   onPressed: () {
          //                     // controller.deleteImage(index);
          //                   },
          //                   icon: const Icon(FontAwesomeIcons.xmark),
          //                 ),
          //               ),
          //             ],
          //           );
          //         },
          //         separatorBuilder: (context, index) => spaceWidth(context),
          //         itemCount: controller.listImageSelect.length),
          //   );
          // }),
          // spaceHeight(context),
          // Text(
          //   "Good Details",
          //   style: smallTextStyle(context, color: Colors.white, size: 14),
          // ),
          // spaceHeight(context, height: 0.02),
          // Container(
          //   width: double.infinity,
          //   height: getHeight(context, height: 0.28),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(15),
          //     color: const Color(0xff202020),
          //   ),
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         TextFieldWidget(
          //           type: TextInputType.number,
          //           borderRadius: 20,
          //           color: lightGrey,
          //           hintText: 'Enter dimension *cm',
          //           hint: '',
          //           maxline: 1,
          //           // controller: controller.dimensionController,
          //         ),
          //         spaceHeight(context, height: 0.02),
          //         TextFieldWidget(
          //           type: TextInputType.number,
          //           borderRadius: 20,
          //           color: lightGrey,
          //           hintText: 'Enter weight *Kg',
          //           hint: '',
          //           maxline: 1,
          //           // controller: controller.weightController,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
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

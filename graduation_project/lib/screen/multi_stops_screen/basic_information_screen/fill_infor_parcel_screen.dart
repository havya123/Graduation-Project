import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graduation_project/app/route/route_name.dart';
import 'package:graduation_project/app/util/const.dart';
import 'package:graduation_project/manage/controller/create_multi_request_controller.dart';
import 'package:graduation_project/widgets/button.dart';
import 'package:graduation_project/widgets/input_widget.dart';
import 'package:graduation_project/widgets/select_image_multi..dart';

class FillInforPacelScreen extends StatelessWidget {
  const FillInforPacelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CreateRequestMultiController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Padding(
          padding: EdgeInsets.only(
            left: getWidth(context, width: 0.01),
          ),
          child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back,
                size: getWidth(context, width: 0.06),
                color: Colors.white,
              )),
        ),
        title: Text(
          "Set Destination Location",
          style: mediumTextStyle(context, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: ListView.separated(
            shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.listDestination[index].address,
                    style: smallTextStyle(context, color: Colors.white),
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
                                return ImageMultiSelected(
                                  index: index,
                                );
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
                    if (controller.listImage[index].isEmpty) {
                      return const SizedBox();
                    }
                    return SizedBox(
                      height: getHeight(context, height: 0.2),
                      child: Obx(() {
                        return ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index1) {
                              return Stack(
                                children: [
                                  Container(
                                    width: getWidth(context, width: 0.5),
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Image.file(
                                      File(controller
                                          .listImage[index][index1]!.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: IconButton(
                                      onPressed: () {
                                        controller.deleteImage(index, index1);
                                      },
                                      icon: const Icon(FontAwesomeIcons.xmark),
                                    ),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                spaceWidth(context),
                            itemCount: controller.listImage[index].length);
                      }),
                    );
                  }),
                  spaceHeight(context),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFieldWidget(
                        type: TextInputType.number,
                        borderRadius: 12,
                        hintText: 'Enter dimension *cm',
                        hint: '',
                        maxline: 1,
                        controller: controller.listDimensionController[index],
                        // controller: controller.dimensionController,
                      ),
                      spaceHeight(context, height: 0.02),
                      TextFieldWidget(
                          type: TextInputType.number,
                          borderRadius: 12,
                          hintText: 'Enter weight *g',
                          hint: '',
                          maxline: 1,
                          controller: controller.listWeightController[index]
                          // controller: controller.weightController,
                          ),
                    ],
                  ),
                  spaceHeight(context),
                  if (controller.listDestination.length - 1 ==
                      index) ...<Widget>[
                    ButtonWidget(
                      function: () => Get.toNamed(RouteName.multiRoute),
                      textButton: "Continue",
                    )
                  ]
                ],
              );
            },
            separatorBuilder: (context, index) =>
                spaceHeight(context, height: 0.02),
            itemCount: controller.listDestination.length),
      ),
    );
  }
}

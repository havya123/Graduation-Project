import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/app/util/const.dart';
import 'package:graduation_project/extension/snackbar.dart';
import 'package:graduation_project/manage/controller/create_multi_request_controller.dart';
import 'package:graduation_project/manage/controller/custom_stepper_multi_controller.dart';
import 'package:graduation_project/widgets/button.dart';
import 'package:graduation_project/widgets/input_widget.dart';

class DetailInforMultiScreen extends StatelessWidget {
  const DetailInforMultiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CreateRequestMultiController>();
    var stepController = Get.find<CustomStepperMultiController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sender Details",
            style: mediumTextStyle(context, color: Colors.white),
          ),
          spaceHeight(context),
          Container(
            width: double.infinity,
            height: getHeight(context, height: 0.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xff202020),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFieldWidget(
                    borderRadius: 12,
                    hintText: 'Enter sender name',
                    hint: '',
                    controller: controller.senderName,
                  ),
                  spaceHeight(context, height: 0.02),
                  TextFieldWidget(
                    borderRadius: 12,
                    hintText: 'Enter sender phone',
                    hint: '',
                    controller: controller.senderPhone,
                  ),
                  spaceHeight(context, height: 0.02),
                  TextFieldWidget(
                    maxline: 5,
                    borderRadius: 12,
                    hintText: 'Note',
                    hint: '',
                    controller: controller.senderNote,
                  ),
                ],
              ),
            ),
          ),
          spaceHeight(context, height: 0.1),
          ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.listDestination[index].address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: mediumTextStyle(context, color: Colors.white),
                    ),
                    spaceHeight(context, height: 0.02),
                    Container(
                      width: double.infinity,
                      height: getHeight(context, height: 0.5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xff202020),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          children: [
                            TextFieldWidget(
                              borderRadius: 12,
                              hintText: 'Enter receiver name',
                              hint: '',
                              controller: controller.listReceiverName[index],
                            ),
                            spaceHeight(context, height: 0.02),
                            TextFieldWidget(
                              borderRadius: 12,
                              hintText: 'Enter receiver phone',
                              hint: '',
                              controller: controller.listReceiverPhone[index],
                            ),
                            spaceHeight(context, height: 0.02),
                            TextFieldWidget(
                              maxline: 5,
                              borderRadius: 12,
                              hintText: 'Note',
                              hint: '',
                              controller: controller.listReceiverNote[index],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // controller.listDestination.length == index + 1
                    //     ? ButtonWidget(function: () {})
                    //     : const SizedBox()
                  ],
                );
              },
              separatorBuilder: ((context, index) => spaceHeight(context)),
              itemCount: controller.listDestination.length),
          spaceHeight(context),
          Row(
            children: [
              Expanded(
                child: ButtonWidget(
                  function: () => stepController.returnStep(),
                  textButton: "Cancel",
                ),
              ),
              spaceWidth(context),
              Expanded(
                child: ButtonWidget(
                  function: () {
                    if (controller.checkDetailInfor()) {
                      stepController.nextStep();
                      return;
                    }
                    MyDialogs.error(msg: "Please fill all fields");
                    return;
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
          // Container(
          //   width: double.infinity,
          //   height: getHeight(context, height: 0.5),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(15),
          //     color: const Color(0xff202020),
          //   ),
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          //     child: Column(
          //       children: [
          //         TextFieldWidget(
          //           borderRadius: 20,
          //           color: lightGrey,
          //           hintText: 'Enter receiver name',
          //           hint: '',
          //           controller: requestController.receiverName,
          //         ),
          //         spaceHeight(context, height: 0.02),
          //         TextFieldWidget(
          //           borderRadius: 20,
          //           color: lightGrey,
          //           hintText: 'Enter receiver phone',
          //           hint: '',
          //           controller: requestController.receiverPhone,
          //         ),
          //         spaceHeight(context, height: 0.02),
          //         TextFieldWidget(
          //           maxline: 5,
          //           borderRadius: 20,
          //           color: lightGrey,
          //           hintText: 'Note',
          //           hint: '',
          //           controller: requestController.receiverNote,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // spaceHeight(context, height: 0.06),
          // Row(
          //   children: [
          //     Expanded(
          //       child: ButtonWidget(
          //         function: () => stepController.returnStep(),
          //         textButton: "Cancel",
          //       ),
          //     ),
          //     spaceWidth(context),
          //     Expanded(
          //       child: ButtonWidget(
          //         function: () => stepController.nextStep(),
          //         textButton: "Continue",
          //       ),
          //     ),
          //   ],
          // ),
          // spaceHeight(context),
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/app/util/const.dart';
import 'package:graduation_project/manage/controller/create_request_controller.dart';
import 'package:graduation_project/manage/controller/custom_stepper_controller.dart';
import 'package:graduation_project/widgets/button.dart';
import 'package:graduation_project/widgets/input_widget.dart';

class DetailInformationScreen extends StatelessWidget {
  const DetailInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var requestController = Get.find<RequestController>();
    var stepController = Get.find<CustomStepperController>();
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
                children: [
                  TextFieldWidget(
                    borderRadius: 20,
                    color: lightGrey,
                    hintText: 'Enter sender name',
                    hint: '',
                    controller: requestController.senderName,
                  ),
                  spaceHeight(context, height: 0.02),
                  TextFieldWidget(
                    borderRadius: 20,
                    color: lightGrey,
                    hintText: 'Enter sender phone',
                    hint: '',
                    controller: requestController.senderPhone,
                  ),
                  spaceHeight(context, height: 0.02),
                  TextFieldWidget(
                    maxline: 5,
                    borderRadius: 20,
                    color: lightGrey,
                    hintText: 'Note',
                    hint: '',
                    controller: requestController.senderNote,
                  ),
                ],
              ),
            ),
          ),
          spaceHeight(context),
          Text(
            "Receiver Details",
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
                children: [
                  TextFieldWidget(
                    borderRadius: 20,
                    color: lightGrey,
                    hintText: 'Enter receiver name',
                    hint: '',
                    controller: requestController.receiverName,
                  ),
                  spaceHeight(context, height: 0.02),
                  TextFieldWidget(
                    borderRadius: 20,
                    color: lightGrey,
                    hintText: 'Enter receiver phone',
                    hint: '',
                    controller: requestController.receiverPhone,
                  ),
                  spaceHeight(context, height: 0.02),
                  TextFieldWidget(
                    maxline: 5,
                    borderRadius: 20,
                    color: lightGrey,
                    hintText: 'Note',
                    hint: '',
                    controller: requestController.receiverNote,
                  ),
                ],
              ),
            ),
          ),
          spaceHeight(context, height: 0.06),
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
                  function: () => stepController.nextStep(),
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

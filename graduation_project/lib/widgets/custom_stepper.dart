import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/manage/controller/custom_stepper_controller.dart';
import 'package:graduation_project/screen/create_request_screen/basic_information_screen/basic_information_screen.dart';
import 'package:graduation_project/screen/create_request_screen/confirmation_screen/confirmation_screen.dart';
import 'package:graduation_project/screen/create_request_screen/detail_information/detail_information_screen.dart';

class CustomStepper extends GetView<CustomStepperController> {
  const CustomStepper({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.black,
          elevation: 2,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: controller.children(context),
            ),
          ),
        ),
        Obx(() {
          if (controller.activateStep.value == 0) {
            return const BasicInformationScreen();
          }
          if (controller.activateStep.value == 1) {
            return const DetailInformationScreen();
          }

          return const ConfirmationScreen();
        })
        // const BasicInformationScreen(),
        // const DetailInformationScreen(),
        //const ConfirmationScreen(),
        // Row(
        //   children: [
        //     ElevatedButton(
        //         onPressed: () => controller.nextStep(), child: const Text("+")),
        //     ElevatedButton(
        //         onPressed: () => controller.returnStep(),
        //         child: const Text("-")),
        //   ],
        // )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/manage/controller/custom_stepper_multi_controller.dart';
import 'package:graduation_project/screen/multi_stops_screen/basic_information_screen/basic_information_multi_screen.dart';
import 'package:graduation_project/screen/multi_stops_screen/confirm_multi_screen/confirm_multi_screen.dart';
import 'package:graduation_project/screen/multi_stops_screen/detail_information_multi_screen/detail_information_multi_screen.dart';

class CustomStepperMultiWidget extends GetView<CustomStepperMultiController> {
  const CustomStepperMultiWidget({super.key});

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
            return const BasicInforMultiScreen();
          }
          if (controller.activateStep.value == 1) {
            return PopScope(
                canPop: false,
                onPopInvoked: (didPop) {
                  controller.activateStep.value--;
                },
                child: const DetailInforMultiScreen());
          }

          return PopScope(
            canPop: false,
            onPopInvoked: (didPop) => controller.activateStep.value--,
            child: const ConfirmMultiScreen(),
          );
        })
      ],
    );
  }
}

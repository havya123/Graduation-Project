import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graduation_project/app/util/const.dart';
import 'package:graduation_project/screen/create_request_screen/basic_information_screen/basic_information_screen.dart';
import 'package:graduation_project/screen/create_request_screen/confirmation_screen/confirmation_screen.dart';
import 'package:graduation_project/screen/create_request_screen/detail_information/detail_information_screen.dart';

class CustomStepperController extends GetxController {
  RxInt activateStep = 0.obs;

  List<Widget> listWidget = [
    const BasicInformationScreen(),
    const DetailInformationScreen(),
    const ConfirmationScreen(),
  ];

  final List<Widget> icons = [
    const Icon(
      FontAwesomeIcons.list,
      color: Colors.black,
    ),
    Image.asset(
      scale: 20,
      "lib/app/assets/story.png",
    ),
    Image.asset(
      scale: 20,
      "lib/app/assets/check.png",
    ),
  ];

  final List<String> title = [
    "Basic Details",
    "Information",
    "Confirmation",
  ];

  List<Widget> children(context) => <Widget>[
        for (int i = 0; i < 3; i++) ...<Widget>[
          Row(
            children: [
              SizedBox(
                height: getHeight(context, height: 0.15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 24.0,
                    ),
                    Center(
                      child: Obx(() {
                        return GestureDetector(
                          onTap: () => changeIndex(i),
                          child: Container(
                              width: 35,
                              height: 35,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: (i < activateStep.value)
                                    ? const Color(0xff9BFE03)
                                    : Colors.white,
                              ),
                              child: (i >= activateStep.value)
                                  ? icons[i]
                                  : const Icon(
                                      FontAwesomeIcons.check,
                                      color: Colors.black,
                                    )),
                        );
                      }),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          spaceHeight(context, height: 0.01),
                          Text(
                            "STEP ${i + 1}",
                            style: smallTextStyle(context,
                                size: 12, color: const Color(0xff909090)),
                          ),
                          Text(
                            title[i],
                            style: smallTextStyle(context,
                                size: 12, color: const Color(0xff909090)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          if (i < 2)
            Expanded(
              child: Obx(() {
                return Container(
                  key: Key('line$i'),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  height: 2.0,
                  color: (i <= activateStep.value - 1)
                      ? const Color(0xff9BFE03)
                      : Colors.white,
                );
              }),
            ),
        ]
      ];

  void nextStep() {
    final isLastStep = activateStep.value == 3;
    if (isLastStep) {
      return;
    }
    activateStep.value++;
  }

  void returnStep() {
    if (activateStep.value == 0) {
      return;
    }
    activateStep.value--;
  }

  void changeIndex(int index) {
    if (activateStep.value == 1) {
      if (index == 2) {
        return;
      }
    }
    if (activateStep.value == 0) {
      if (index >= 1 && index <= 2) {
        return;
      }
    }
    activateStep.value = index;
  }
}

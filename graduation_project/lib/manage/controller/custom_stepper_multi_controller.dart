import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graduation_project/app/util/const.dart';
import 'package:graduation_project/screen/multi_stops_screen/basic_information_screen/basic_information_multi_screen.dart';
import 'package:graduation_project/screen/multi_stops_screen/detail_information_multi_screen/detail_information_multi_screen.dart';

class CustomStepperMultiController extends GetxController {
  RxInt activateStep = 0.obs;

  List<Widget> listWidget = [
    BasicInforMultiScreen(),
    DetailInforMultiScreen(),
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
                        return Container(
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
                                  ));
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
}

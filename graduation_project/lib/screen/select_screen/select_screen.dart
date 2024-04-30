import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/app/util/const.dart';
import 'package:graduation_project/manage/controller/select_controller.dart';

class SelectScreen extends GetView<SelectController> {
  const SelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: AnimatedBuilder(
                  animation: controller.animationController!,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, controller.animation1!.value * 100),
                      child: Container(
                        height: getHeight(context, height: 0.25),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    );
                  },
                ),
              ),
              spaceWidth(context),
              Expanded(
                child: AnimatedBuilder(
                  animation: controller.animationController!,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, controller.animation2!.value * 100),
                      child: Container(
                        height: getHeight(context, height: 0.25),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

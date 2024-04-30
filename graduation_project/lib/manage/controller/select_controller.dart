import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectController extends GetxController
    with GetSingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation1;
  Animation<double>? animation2;

  @override
  void onInit() {
    initAnimate();
    super.onInit();
  }

  void initAnimate() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    animation1 = Tween<double>(begin: -5, end: 0).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: Curves.easeInOut,
      ),
    );
    animation2 = Tween<double>(begin: -5, end: 0).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: Curves.easeInOut,
      ),
    );

    animationController!.forward();
  }

  @override
  void onClose() {
    animationController!.dispose();
    super.onClose();
  }
}

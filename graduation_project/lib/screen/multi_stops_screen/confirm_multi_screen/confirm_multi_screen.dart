import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/app/util/const.dart';
import 'package:graduation_project/manage/controller/create_multi_request_controller.dart';
import 'package:graduation_project/manage/controller/custom_stepper_multi_controller.dart';
import 'package:graduation_project/widgets/button.dart';
import 'package:graduation_project/widgets/check_box.dart';

class ConfirmMultiScreen extends StatelessWidget {
  const ConfirmMultiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CreateRequestMultiController>();
    var steperController = Get.find<CustomStepperMultiController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spaceHeight(context),
          Text(
            "Payer Identification",
            style: mediumTextStyle(context, color: Colors.white),
          ),
          spaceHeight(context, height: 0.02),
          Container(
            width: double.infinity,
            height: getHeight(context, height: 0.12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xff202020),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.senderName.text,
                        style: mediumTextStyle(context,
                            color: Colors.white, size: 18),
                      ),
                      CheckboxExample(
                        isChecked: controller.senderPay,
                        onChanged: (p0) {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          spaceHeight(context),
          Text(
            "Payment Method",
            style: mediumTextStyle(context, color: Colors.white),
          ),
          spaceHeight(context, height: 0.02),
          Container(
            width: double.infinity,
            height: getHeight(context, height: 0.25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xff202020),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: const Color(0xff3B3F34)),
                            child: Center(
                              child: Image.asset(
                                "lib/app/assets/wallet.png",
                                fit: BoxFit.cover,
                                scale: 20,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Cash on Delivery",
                            style: mediumTextStyle(context,
                                color: Colors.white, size: 18),
                          ),
                        ),
                        CheckboxExample(
                          isChecked: controller.cash,
                          onChanged: (p0) {
                            controller.choosePaymentMethod(p0!);
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: const Color(0xff3B3F34)),
                            child: Center(
                              child: Image.asset(
                                "lib/app/assets/bank.png",
                                fit: BoxFit.cover,
                                scale: 20,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Banking",
                            style: mediumTextStyle(context,
                                color: Colors.white, size: 18),
                          ),
                        ),
                        CheckboxExample(
                          isChecked: controller.banking,
                          onChanged: (p0) {
                            // requestController.choosePaymentMethod(p0!);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          spaceHeight(context),
          spaceHeight(context, height: 0.06),
          Row(
            children: [
              Expanded(
                child: ButtonWidget(
                  function: () => steperController.returnStep(),
                  textButton: "Back",
                ),
              ),
              spaceWidth(context),
              Expanded(
                child: ButtonWidget(
                  function: () async {
                    await controller.createRequestMulti();

                    // requestController.createRequest();
                  },
                  textButton: "Submit",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

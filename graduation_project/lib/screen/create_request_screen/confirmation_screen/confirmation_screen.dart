import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graduation_project/app/util/const.dart';
import 'package:graduation_project/manage/controller/create_request_controller.dart';
import 'package:graduation_project/manage/controller/custom_stepper_controller.dart';
import 'package:graduation_project/widgets/button.dart';
import 'package:graduation_project/widgets/check_box.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var stepController = Get.find<CustomStepperController>();
    var requestController = Get.find<RequestController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Payer Identification",
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
                        Text(
                          requestController.senderName.text,
                          style: mediumTextStyle(context,
                              color: Colors.white, size: 18),
                        ),
                        CheckboxExample(
                          isChecked: requestController.senderPay,
                          onChanged: (p0) {
                            requestController.choosePayer(p0!);
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          requestController.receiverName.text,
                          style: mediumTextStyle(context,
                              color: Colors.white, size: 18),
                        ),
                        CheckboxExample(
                          isChecked: requestController.receiverPay,
                          onChanged: (p0) {
                            requestController.choosePayer(p0!);
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
                          isChecked: requestController.cash,
                          onChanged: (p0) {
                            requestController.choosePaymentMethod(p0!);
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
                          isChecked: requestController.banking,
                          onChanged: (p0) {
                            requestController.choosePaymentMethod(p0!);
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
          Text(
            "Order summary",
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Dimension",
                          style: smallTextStyle(context, color: Colors.white),
                        ),
                        Text(
                          "${requestController.dimensionController.text}cm",
                          style: smallTextStyle(context, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weight",
                          style: smallTextStyle(context, color: Colors.white),
                        ),
                        Text(
                          "${requestController.weightController.text}kg",
                          style: smallTextStyle(context, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Collect type",
                          style: smallTextStyle(context, color: Colors.white),
                        ),
                        Text(
                          requestController.isChoosedExpress.value
                              ? "Express"
                              : "Saving",
                          style: smallTextStyle(context, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Delivery",
                          style: smallTextStyle(context, color: Colors.white),
                        ),
                        Text(
                          requestController.isChoosedExpress.value
                              ? "${requestController.priceExpress.value} VND"
                              : "${requestController.priceSaving.value} VND",
                          style: smallTextStyle(context, color: Colors.white),
                        ),
                      ],
                    ),
                  )
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
                  textButton: "Back",
                ),
              ),
              spaceWidth(context),
              Expanded(
                child: ButtonWidget(
                  function: () {
                    requestController.createRequest();
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

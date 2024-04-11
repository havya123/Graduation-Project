import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/app/util/const.dart';
import 'package:graduation_project/manage/controller/login_controller.dart';
import 'package:graduation_project/widgets/button.dart';
import 'package:graduation_project/widgets/input_widget.dart';

class PhoneRegisterScreen extends StatelessWidget {
  const PhoneRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<LoginController>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: const Color(0xffD8DADC)),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  spaceHeight(context),
                  Container(
                    width: getWidth(context, width: 0.7),
                    height: getHeight(context, height: 0.3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.yellow),
                  ),
                  spaceHeight(context),
                  const Text(
                    "Create Account",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  spaceHeight(context, height: 0.1),
                  TextFieldWidget(
                    hint: "+84 | 000 000 000 ",
                    controller: controller.phoneNumber,
                    numberOfLetter: 10,
                    type: TextInputType.phone,
                    borderRadius: 15,
                  ),
                  spaceHeight(context),
                  ButtonWidget(
                    function: () async {
                      if (controller.phoneNumber.value.text.isNotEmpty) {
                        await controller.sentOtp(context);
                      }
                    },
                    textButton: "Send OTP",
                  )
                ]),
          ),
        ),
      ),
    );
  }
}

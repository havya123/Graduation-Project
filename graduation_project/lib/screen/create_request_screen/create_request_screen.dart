import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/manage/controller/create_request_controller.dart';
import 'package:graduation_project/widgets/custom_stepper.dart';

class CreateRequestScreen extends GetView<RequestController> {
  const CreateRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: CustomStepper(),
        ),
      ),
    );
  }
}

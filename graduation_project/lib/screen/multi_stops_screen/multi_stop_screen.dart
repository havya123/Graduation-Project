import 'package:flutter/material.dart';
import 'package:graduation_project/widgets/custom_stepper_multi_widget.dart';

class MultiStopScreen extends StatelessWidget {
  const MultiStopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: CustomStepperMultiWidget(),
        ),
      ),
    );
  }
}

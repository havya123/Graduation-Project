import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../manage/controller/create_multi_request_controller.dart';

class ImageMultiSelected extends StatelessWidget {
  ImageMultiSelected({super.key, required this.index});
  int index;
  var controller = Get.find<CreateRequestMultiController>();
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 0.3,
      child: Column(
        children: [
          TextButton(
            onPressed: () async {
              controller.pickImageFromGallery(index);
            },
            child: const Text('Lấy ảnh từ thư viện'),
          ),
          TextButton(
            onPressed: () {
              controller.pickImageFromCamera(index);
            },
            child: const Text('Lấy ảnh từ camera'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/manage/controller/create_request_controller.dart';

class ImageSelected extends StatelessWidget {
  const ImageSelected({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<RequestController>();
    return FractionallySizedBox(
      heightFactor: 0.3,
      child: Column(
        children: [
          TextButton(
            onPressed: () async {
              controller.pickImageHouseFromGallery();
            },
            child: const Text('Lấy ảnh từ thư viện'),
          ),
          TextButton(
            onPressed: () {
              controller.pickImageHouseFromCamera();
            },
            child: const Text('Lấy ảnh từ camera'),
          ),
        ],
      ),
    );
  }
}

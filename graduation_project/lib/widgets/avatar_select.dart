import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/manage/controller/profile_controller.dart';

class AvatarSelected extends StatelessWidget {
  const AvatarSelected({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 0.3,
      child: Column(
        children: [
          TextButton(
            onPressed: () async {
              controller.pickImageFromGallery();
            },
            child: const Text('Lấy ảnh từ thư viện'),
          ),
          TextButton(
            onPressed: () {
              controller.pickImageFromCamera();
            },
            child: const Text('Lấy ảnh từ camera'),
          ),
        ],
      ),
    );
  }
}

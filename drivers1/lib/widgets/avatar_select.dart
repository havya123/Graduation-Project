import 'dart:io';

import 'package:drivers/app/util/const.dart';
import 'package:drivers/controller/profile_controller.dart';
import 'package:drivers/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvatarSelected extends StatelessWidget {
  const AvatarSelected({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();
    return Obx(() {
      return FractionallySizedBox(
        widthFactor: 1,
        heightFactor: controller.avatar.value != null ? 0.8 : 0.3,
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
            Obx(() {
              if (controller.avatar.value != null) {
                return Column(
                  children: [
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.black),
                        child: Image.file(
                          File(controller.avatar.value!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    spaceHeight(context, height: 0.02),
                    SizedBox(
                        width: getWidth(context, width: 0.6),
                        child: ButtonWidget(
                          function: () async {
                            await controller.updateAvatar();
                          },
                          textColor: Colors.white,
                          textButton: "Update",
                          borderRadius: 8,
                        ))
                  ],
                );
              }
              return const SizedBox();
            })
          ],
        ),
      );
    });
  }
}

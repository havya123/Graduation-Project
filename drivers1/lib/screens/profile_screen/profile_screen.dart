import 'package:drivers/app/store/app_store.dart';
import 'package:drivers/app/util/const.dart';
import 'package:drivers/controller/profile_controller.dart';
import 'package:drivers/widgets/avatar_select.dart';
import 'package:drivers/widgets/button.dart';
import 'package:drivers/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../app/route/route_name.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    spaceHeight(context, height: 0.02),
                    Container(
                      width: 100,
                      height: 100,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Obx(() {
                              return Container(
                                width: 100,
                                height: 100,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                ),
                                child: FadeInImage.memoryNetwork(
                                  // width: double.infinity,
                                  // height: double.infinity,
                                  placeholder: kTransparentImage,
                                  image: AppStore.to.avatar.value,
                                  fit: BoxFit.cover,
                                ),
                              );
                            }),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: () async {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return const AvatarSelected();
                                    });
                              },
                              icon: const Icon(
                                FontAwesomeIcons.pencil,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    spaceHeight(context, height: 0.02),
                    Text(
                      AppStore.to.userName.value,
                      style: mediumTextStyle(
                        context,
                      ),
                    ),
                    spaceHeight(context, height: 0.04),
                    TextFieldWidget(
                      controller: controller.nameController,
                      hint: "",
                      borderRadius: 10,
                      color: Colors.white,
                      hintText: "Username",
                      textColor: Colors.black,
                    ),
                    spaceHeight(context, height: 0.02),
                    TextFieldWidget(
                      controller: controller.phoneController,
                      hint: "",
                      borderRadius: 10,
                      color: Colors.white,
                      hintText: "Phone Number",
                      textColor: Colors.black,
                      type: TextInputType.phone,
                      numberOfLetter: 10,
                    ),
                    spaceHeight(context, height: 0.02),
                    TextFieldWidget(
                      controller: controller.emailController,
                      hint: "",
                      color: Colors.white,
                      borderRadius: 10,
                      hintText: "Email",
                      type: TextInputType.emailAddress,
                      textColor: Colors.black,
                    ),
                    spaceHeight(context, height: 0.02),
                    TextFieldWidget(
                      controller: controller.addressController,
                      color: Colors.white,
                      hint: "",
                      borderRadius: 10,
                      hintText: "Address",
                      textColor: Colors.black,
                    ),
                    spaceHeight(context, height: 0.02),
                    spaceHeight(context),
                    ButtonWidget(
                      function: () async {
                        await controller.updateProfile();
                      },
                      textButton: "Save Profile",
                    ),
                    spaceHeight(context),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Logout"),
                              content:
                                  const Text("Press OK to continue logout"),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await controller.logout();
                                    Get.offAllNamed(RouteName.loginRoute);
                                  },
                                  child: const Text("Ok"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: getHeight(context, height: 0.08),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.logout,
                                color: Colors.black,
                                size: 30,
                              ),
                              spaceWidth(context),
                              Text(
                                "Logout",
                                style: mediumTextStyle(context,
                                    size: 18, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    spaceHeight(context, height: 0.06),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OverviewItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final BuildContext context;

  const OverviewItem({
    super.key,
    required this.icon,
    required this.title,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
          spaceWidth(context),
          Text(
            title,
            style: mediumTextStyle(context, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }
}

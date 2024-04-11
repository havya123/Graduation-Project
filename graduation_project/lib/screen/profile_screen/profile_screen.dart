import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graduation_project/app/store/app_store.dart';
import 'package:graduation_project/app/util/const.dart';
import 'package:graduation_project/manage/controller/profile_controller.dart';
import 'package:transparent_image/transparent_image.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print(AppStore.to.avatar);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Back",
                        style: mediumTextStyle(context, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                spaceHeight(context, height: 0.1),
                Container(
                  width: 100,
                  height: 100,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color(0xff9Fdd41),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          width: 90,
                          height: 90,
                          child: FadeInImage.memoryNetwork(
                            width: double.infinity,
                            height: double.infinity,
                            placeholder: kTransparentImage,
                            image: AppStore.to.avatar,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: () {},
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
                  AppStore.to.userName,
                  style: mediumTextStyle(context, color: Colors.white),
                ),
                spaceHeight(context),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: getHeight(context, height: 0.12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xffE9FAC8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "0 Progress",
                              style: largeTextStyle(context, size: 16),
                            ),
                            Text(
                              "delivery",
                              style: smallTextStyle(context, size: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    spaceWidth(context),
                    Expanded(
                      child: Container(
                        height: getHeight(context, height: 0.12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xff3B3F34),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "0 Parcels",
                              style: mediumTextStyle(context,
                                  color: Colors.white, size: 16),
                            ),
                            Text(
                              "send",
                              style: smallTextStyle(context,
                                  color: Colors.white, size: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    spaceWidth(context),
                    Expanded(
                      child: Container(
                        height: getHeight(context, height: 0.12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xff202020),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "30 Parcels",
                              style: mediumTextStyle(context,
                                  color: Colors.white, size: 16),
                            ),
                            Text(
                              "completed",
                              style: smallTextStyle(context,
                                  color: Colors.white, size: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                spaceHeight(context, height: 0.04),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Overviews",
                    style: mediumTextStyle(context, color: Colors.white),
                  ),
                ),
                spaceHeight(context, height: 0.02),
                Container(
                  width: double.infinity,
                  height: getHeight(context, height: 0.45),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xff202020),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    child: Column(
                      children: [
                        OverviewItem(
                          icon: Icons.people,
                          title: "Account",
                          context: context,
                        ),
                        OverviewItem(
                          icon: FontAwesomeIcons.locationDot,
                          title: "Address",
                          context: context,
                        ),
                        OverviewItem(
                          icon: Icons.headphones,
                          title: "Contact Us",
                          context: context,
                        ),
                        OverviewItem(
                          icon: Icons.question_mark,
                          title: "About Us",
                          context: context,
                        ),
                        OverviewItem(
                          icon: Icons.settings,
                          title: "Setting",
                          context: context,
                        ),
                      ],
                    ),
                  ),
                ),
                spaceHeight(context, height: 0.02),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Logout"),
                          content: const Text("Press OK to continue logout"),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => controller.logout(),
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
                      color: const Color(0xff202020),
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
                            color: Colors.white,
                            size: 30,
                          ),
                          spaceWidth(context),
                          Text(
                            "Logout",
                            style: mediumTextStyle(context,
                                color: Colors.white, size: 18),
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

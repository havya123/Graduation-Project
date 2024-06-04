import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/app/route/route_name.dart';
import 'package:graduation_project/app/store/app_store.dart';
import 'package:graduation_project/app/util/const.dart';
import 'package:graduation_project/manage/controller/category_controller.dart';
import 'package:graduation_project/screen/profile_screen/profile_screen.dart';
import 'package:transparent_image/transparent_image.dart';

class CategoryScreen extends GetView<CategoryController> {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Obx(() {
              return controller.index.value == 0
                  ? Column(
                      children: [
                        SizedBox(
                          width: getWidth(context, width: 1),
                          height: getHeight(context, height: 0.26),
                          child: Stack(
                            children: [
                              Container(
                                height: getHeight(context, height: 0.2),
                                width: getWidth(context, width: 1),
                                decoration: const BoxDecoration(
                                  color: Color(0xff1B1B1B),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: Colors.white),
                                        child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: AppStore.to.avatar.value,
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Text(
                                            "Express Delivery App",
                                            style: mediumTextStyle(context,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: getWidth(context),
                                right: getWidth(context),
                                bottom: 10,
                                child: Container(
                                  width: getWidth(context, width: 0.8),
                                  height: getHeight(context, height: 0.12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: const Color(0xff272727)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () => Get.toNamed(
                                                  RouteName.requestRoute),
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                clipBehavior: Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: Colors.transparent),
                                                child: Image.asset(
                                                    "lib/app/assets/express-delivery.png"),
                                              ),
                                            ),
                                            spaceHeight(context, height: 0.01),
                                            Text(
                                              "Default Express",
                                              style: smallTextStyle(context,
                                                  size: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () => Get.toNamed(
                                                  RouteName.multiRoute),
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                clipBehavior: Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: Colors.transparent),
                                                child: Image.asset(
                                                  "lib/app/assets/destination.png",
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            spaceHeight(context, height: 0.01),
                                            Text(
                                              "MultiStop Express",
                                              style: smallTextStyle(context,
                                                  size: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () => Get.toNamed(
                                                  RouteName.historyRoute),
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                clipBehavior: Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: Colors.transparent),
                                                child: Image.asset(
                                                  "lib/app/assets/history.png",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            spaceHeight(context, height: 0.01),
                                            Text(
                                              "History Express",
                                              style: smallTextStyle(context,
                                                  size: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        spaceHeight(context, height: 0.1),
                        Obx(() {
                          if (controller.isLoading.value &&
                              controller.lastedRequest.value == null) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (!controller.isLoading.value &&
                                  controller.lastedRequest.value == null ||
                              controller.lastedRequest.value!.statusRequest ==
                                  "cancel") {
                            return Center(
                                child: Text(
                              "You have no any booking yet. Booking now",
                              textAlign: TextAlign.center,
                              style: largeTextStyle(
                                context,
                                color: Colors.white,
                              ),
                            ));
                          }

                          return GestureDetector(
                            onTap: () {
                              if (controller
                                      .lastedRequest.value!.statusRequest ==
                                  'waiting') {
                                Get.toNamed(RouteName.trackingRoute,
                                    parameters: {
                                      'requestId': controller
                                          .lastedRequest.value!.requestId
                                    });
                                return;
                              }
                              Get.toNamed(RouteName.detailTripRoute,
                                  arguments: {
                                    'request': controller.lastedRequest.value,
                                  });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Container(
                                width: getWidth(context, width: 1),
                                height: getHeight(context, height: 0.35),
                                decoration: BoxDecoration(
                                  color: const Color(0xff272727),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Current Request",
                                            style: smallTextStyle(context,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white),
                                          ),
                                          Container(
                                            width:
                                                getWidth(context, width: 0.25),
                                            height: getHeight(context,
                                                height: 0.06),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: const Color(0xff3A86FF),
                                            ),
                                            child: Center(
                                              child: Text(
                                                controller.lastedRequest.value
                                                        ?.statusRequest ??
                                                    "",
                                                style: smallTextStyle(context,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      spaceHeight(context),
                                      Text(
                                        controller.lastedRequest.value
                                                    ?.senderAddress[
                                                'senderAddres'] ??
                                            "",
                                        style: smallTextStyle(context,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      spaceHeight(context),
                                      Obx(() {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // Loop to create circles and lines
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: controller.currentStatus
                                                            .value <=
                                                        4
                                                    ? Colors.blue
                                                    : Colors.white,
                                              ),
                                            ),

                                            Expanded(
                                              child: Container(
                                                height: 2,
                                                color: controller.currentStatus
                                                            .value >=
                                                        1
                                                    ? Colors.blue
                                                    : Colors.white,
                                              ),
                                            ),
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: controller.currentStatus
                                                                .value <=
                                                            4 &&
                                                        controller.currentStatus
                                                                .value >=
                                                            1
                                                    ? Colors.blue
                                                    : Colors.white,
                                              ),
                                            ),

                                            Expanded(
                                              child: Container(
                                                height: 2,
                                                color: controller.currentStatus
                                                            .value >=
                                                        2
                                                    ? Colors.blue
                                                    : Colors.white,
                                              ),
                                            ),
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: controller.currentStatus
                                                                .value <=
                                                            4 &&
                                                        controller.currentStatus
                                                                .value >=
                                                            2
                                                    ? Colors.blue
                                                    : Colors.white,
                                              ),
                                            ),

                                            Expanded(
                                              child: Container(
                                                  height: 2,
                                                  color: controller
                                                              .currentStatus
                                                              .value >=
                                                          3
                                                      ? Colors.blue
                                                      : Colors.white),
                                            ),
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: controller.currentStatus
                                                            .value ==
                                                        3
                                                    ? Colors.blue
                                                    : Colors.white,
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                      spaceHeight(context, height: 0.02),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            controller
                                                .lastedRequest.value!.created,
                                            style: smallTextStyle(context,
                                                size: 12, color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      spaceHeight(context, height: 0.02),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            controller.lastedRequest.value!
                                                .senderAddress['senderAddres']
                                                .split(',')
                                                .first,
                                            style: smallTextStyle(context,
                                                size: 13,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            controller
                                                .lastedRequest
                                                .value!
                                                .receiverAddress[
                                                    'receiverAddress']
                                                .split(',')
                                                .first,
                                            style: smallTextStyle(context,
                                                size: 13,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                      ],
                    )
                  : const ProfileScreen();
            }),
          ),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.white,
        //   shape: const CircleBorder(),
        //   child: Center(
        //     child: Container(
        //       clipBehavior: Clip.hardEdge,
        //       decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(100),
        //           color: const Color(0xff00C27C)),
        //       child: const Center(
        //         child: Icon(
        //           Icons.add,
        //           size: 30,
        //           color: Colors.white,
        //         ),
        //       ),
        //     ),
        //   ),
        //   onPressed: () => Get.toNamed(RouteName.requestRoute),
        // ),
        bottomNavigationBar: Obx(() {
          return AnimatedBottomNavigationBar.builder(
            gapLocation: GapLocation.center,
            backgroundColor: const Color(0xff272727),
            itemCount: controller.listIcon.length,
            tabBuilder: (index, isActive) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(controller.listIcon[index],
                      size: 24, color: isActive ? Colors.white : Colors.black),
                  Text(
                    controller.listTitle[index],
                    style: smallTextStyle(context,
                        size: 16,
                        color: isActive ? Colors.white : Colors.black),
                  )
                ],
              );
            },
            activeIndex: controller.index.value,
            onTap: (p0) {
              controller.changeIndex(p0);
            },
          );
        }));
  }
}

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graduation_project/app/route/route_name.dart';
import 'package:graduation_project/app/store/app_store.dart';
import 'package:graduation_project/app/util/const.dart';
import 'package:graduation_project/manage/controller/category_controller.dart';
import 'package:graduation_project/manage/controller/create_request_controller.dart';
import 'package:graduation_project/manage/firebase_service/notification_service.dart';
import 'package:graduation_project/widgets/search_box.dart';
import 'package:transparent_image/transparent_image.dart';

class CategoryScreen extends GetView<CategoryController> {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
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
                          color: Color(0xff00C27C),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: AppStore.to.avatar,
                                ),
                              ),
                              Obx(() {
                                if (RequestController.to.pickPlace.value !=
                                    null) {
                                  return SizedBox(
                                    width: getWidth(context, width: 0.8),
                                    child: Text(
                                      RequestController
                                          .to.pickPlace.value!.address,
                                      style: smallTextStyle(context,
                                          color: Colors.white),
                                      maxLines: 3,
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                } else {
                                  return Row(
                                    children: [
                                      Text(
                                        "Searching your location",
                                        style: mediumTextStyle(context,
                                            size: 18, color: Colors.white),
                                      ),
                                      AnimatedTextKit(
                                        animatedTexts: [
                                          WavyAnimatedText(
                                            "......",
                                            speed: const Duration(
                                              milliseconds: 200,
                                            ),
                                            textStyle: mediumTextStyle(context,
                                                color: Colors.white),
                                          ),
                                        ],
                                        stopPauseOnTap: false,
                                        repeatForever: true,
                                        isRepeatingAnimation: true,
                                      ),
                                    ],
                                  );
                                }
                              })
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: getWidth(context),
                        right: getWidth(context),
                        bottom: 0,
                        child: Container(
                          width: getWidth(context, width: 0.8),
                          height: getHeight(context, height: 0.12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            border: Border.all(width: 0.2, color: Colors.black),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          Get.toNamed(RouteName.requestRoute),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: Colors.green),
                                      ),
                                    ),
                                    spaceHeight(context, height: 0.01),
                                    Text(
                                      "Default Express",
                                      style: smallTextStyle(context,
                                          size: 12,
                                          fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          Get.toNamed(RouteName.multiRoute),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: Colors.green),
                                      ),
                                    ),
                                    spaceHeight(context, height: 0.01),
                                    Text(
                                      "MultiStop Express",
                                      style: smallTextStyle(context,
                                          size: 12,
                                          fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          Get.toNamed(RouteName.historyRoute),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: Colors.green),
                                      ),
                                    ),
                                    spaceHeight(context, height: 0.01),
                                    Text(
                                      "History Express",
                                      style: smallTextStyle(context,
                                          size: 12,
                                          fontWeight: FontWeight.w700),
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

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Row(
                //       children: [
                //         Icon(
                //           Icons.bike_scooter,
                //           color: green,
                //         ),
                //         spaceWidth(context),
                //         Text(
                //           "Delivery App",
                //           style: smallTextStyle(context, color: green),
                //         ),
                //       ],
                //     ),
                //     Row(
                //       children: [
                //         Icon(FontAwesomeIcons.question, color: green),
                //         spaceWidth(context),
                //         Icon(FontAwesomeIcons.bell, color: green),
                //       ],
                //     )
                //   ],
                // ),
                // spaceHeight(context, height: 0.1),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 15),
                //         child: Text(
                //           "Search parcel",
                //           style: mediumTextStyle(context, color: grey),
                //         )),
                //     SearchBoxWidget(
                //         borderRadius: 30,
                //         width: double.infinity,
                //         height: getHeight(context, height: 0.08),
                //         color: Colors.white,
                //         suffixIcon: const Icon(FontAwesomeIcons.magnifyingGlass),
                //         textBox: "Your Parcel Code..",
                //         textStyle: smallTextStyle(context, color: grey),
                //         controller: TextEditingController())
                //   ],
                // ),
                // spaceHeight(context),
                // Container(
                //   width: double.infinity,
                //   height: getHeight(context, height: 0.23),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(15),
                //     color: grey,
                //   ),
                // ),
                // spaceHeight(context, height: 0.1),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 15),
                //       child: Text(
                //         "Menu",
                //         style: smallTextStyle(context,
                //             color: Colors.white, size: 21),
                //       ),
                //     ),
                //     Container(
                //       width: double.infinity,
                //       height: getHeight(context, height: 0.23),
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(15),
                //         color: grey,
                //       ),
                //       child: Padding(
                //         padding: const EdgeInsets.symmetric(
                //             horizontal: 10, vertical: 10),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Expanded(
                //               flex: 1,
                //               child: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.center,
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   const CircleAvatar(
                //                     radius: 20,
                //                     backgroundColor: Colors.black,
                //                   ),
                //                   Text(
                //                     "Chuon Raksa",
                //                     style: smallTextStyle(context,
                //                         color: Colors.white),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //             spaceWidth(context, width: 0.02),
                //             Expanded(
                //                 flex: 2,
                //                 child: Row(
                //                   mainAxisAlignment: MainAxisAlignment.center,
                //                   children: [
                //                     Expanded(
                //                       child: Column(
                //                         crossAxisAlignment:
                //                             CrossAxisAlignment.center,
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.center,
                //                         children: [
                //                           GestureDetector(
                //                             onTap: () async {
                //                               Get.toNamed(RouteName.historyRoute);
                //                               // Get.toNamed(
                //                               //     RouteName.trackingRoute);
                //                               // await NotificationService()
                //                               //     .sendNotification(
                //                               //         "", AppStore.to.newRequest);
                //                               // var access =
                //                               //     await NotificationService()
                //                               //         .getAccessToken();
                //                               // print(access);
                //                             },
                //                             child: Container(
                //                               height: 50,
                //                               decoration: BoxDecoration(
                //                                 borderRadius:
                //                                     BorderRadius.circular(15),
                //                                 color: const Color(0xff322708),
                //                               ),
                //                               child: Padding(
                //                                 padding:
                //                                     const EdgeInsets.symmetric(
                //                                         horizontal: 5,
                //                                         vertical: 5),
                //                                 child: Row(
                //                                   children: [
                //                                     const Icon(Icons.motorcycle,
                //                                         color: Color(0xffFCD053)),
                //                                     Text(
                //                                       "Deliveries",
                //                                       style: largeTextStyle(
                //                                           context,
                //                                           color: const Color(
                //                                               0xffFCD053),
                //                                           size: 10),
                //                                     )
                //                                   ],
                //                                 ),
                //                               ),
                //                             ),
                //                           ),
                //                           spaceHeight(context, height: 0.02),
                //                           GestureDetector(
                //                             onTap: () => Get.toNamed(
                //                                 RouteName.selectRoute),
                //                             child: Container(
                //                               height: 50,
                //                               decoration: BoxDecoration(
                //                                 borderRadius:
                //                                     BorderRadius.circular(15),
                //                                 color: const Color(0xff124966),
                //                               ),
                //                               child: Padding(
                //                                 padding:
                //                                     const EdgeInsets.symmetric(
                //                                         horizontal: 5,
                //                                         vertical: 5),
                //                                 child: Row(
                //                                   children: [
                //                                     const Icon(Icons.list_alt,
                //                                         color: Color(0xff2EB4FC)),
                //                                     Text(
                //                                       "My Order",
                //                                       style: largeTextStyle(
                //                                           context,
                //                                           color: const Color(
                //                                               0xff2EB4FC),
                //                                           size: 10),
                //                                     )
                //                                   ],
                //                                 ),
                //                               ),
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //                     spaceWidth(context),
                //                     Expanded(
                //                       child: GestureDetector(
                //                         onTap: () =>
                //                             Get.toNamed(RouteName.profileRoute),
                //                         child: Container(
                //                           height: 100,
                //                           decoration: BoxDecoration(
                //                             borderRadius:
                //                                 BorderRadius.circular(15),
                //                             color: const Color(0xff3B3F34),
                //                           ),
                //                           child: Center(
                //                             child: Row(
                //                               mainAxisAlignment:
                //                                   MainAxisAlignment.center,
                //                               children: [
                //                                 Icon(
                //                                   Icons.person_pin_circle_sharp,
                //                                   color: green,
                //                                 ),
                //                                 Text(
                //                                   "Setting",
                //                                   style: smallTextStyle(context,
                //                                       size: 16,
                //                                       color: const Color(
                //                                           0xff909090)),
                //                                 )
                //                               ],
                //                             ),
                //                           ),
                //                         ),
                //                       ),
                //                     )
                //                   ],
                //                 )),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // spaceHeight(context, height: 0.1),
                // // Container(
                // //   width: double.infinity,
                // //   height: getHeight(context, height: 0.3),
                // //   clipBehavior: Clip.hardEdge,
                // //   decoration: BoxDecoration(
                // //     borderRadius: BorderRadius.circular(20),
                // //     color: Colors.red,
                // //   ),
                // //   child: Row(
                // //     children: [
                // //       Expanded(
                // //           child: Padding(
                // //         padding: const EdgeInsets.all(10.0),
                // //         child: Column(
                // //           crossAxisAlignment: CrossAxisAlignment.start,
                // //           children: [
                // //             const Padding(
                // //               padding: EdgeInsets.only(left: 15),
                // //               child: Text("Tracking ID"),
                // //             ),
                // //             const Padding(
                // //               padding: EdgeInsets.only(left: 15),
                // //               child: Text("#ASFSAFGSA-SAFSAF"),
                // //             ),
                // //             spaceHeight(context),
                // //             const Padding(
                // //               padding: EdgeInsets.only(left: 15),
                // //               child: Text("From"),
                // //             ),
                // //             const Row(
                // //               children: [],
                // //             )
                // //           ],
                // //         ),
                // //       )),
                // //       Expanded(
                // //           child: Container(
                // //         color: Colors.blue,
                // //       ))
                // //     ],
                // //   ),
                // // )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          shape: const CircleBorder(),
          child: Center(
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color(0xff00C27C)),
              child: const Center(
                child: Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          onPressed: () => Get.toNamed(RouteName.requestRoute),
        ),
        bottomNavigationBar: Obx(() {
          return AnimatedBottomNavigationBar.builder(
            gapLocation: GapLocation.center,
            backgroundColor: Colors.white,
            itemCount: controller.listIcon.length,
            tabBuilder: (index, isActive) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(controller.listIcon[index],
                      size: 24,
                      color: isActive ? const Color(0xff00C27C) : Colors.black),
                  Text(
                    controller.listTitle[index],
                    style: smallTextStyle(context,
                        size: 16,
                        color:
                            isActive ? const Color(0xff00C27C) : Colors.black),
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

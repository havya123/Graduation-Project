import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graduation_project/app/route/route_name.dart';
import 'package:graduation_project/app/store/app_store.dart';
import 'package:graduation_project/app/util/const.dart';
import 'package:graduation_project/manage/controller/category_controller.dart';
import 'package:graduation_project/manage/firebase_service/notification_service.dart';
import 'package:graduation_project/widgets/search_box.dart';

class CategoryScreen extends GetView<CategoryController> {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.bike_scooter,
                        color: green,
                      ),
                      spaceWidth(context),
                      Text(
                        "Delivery App",
                        style: smallTextStyle(context, color: green),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(FontAwesomeIcons.question, color: green),
                      spaceWidth(context),
                      Icon(FontAwesomeIcons.bell, color: green),
                    ],
                  )
                ],
              ),
              spaceHeight(context, height: 0.1),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Search parcel",
                        style: mediumTextStyle(context, color: grey),
                      )),
                  SearchBoxWidget(
                      borderRadius: 30,
                      width: double.infinity,
                      height: getHeight(context, height: 0.08),
                      color: Colors.white,
                      suffixIcon: const Icon(FontAwesomeIcons.magnifyingGlass),
                      textBox: "Your Parcel Code..",
                      textStyle: smallTextStyle(context, color: grey),
                      controller: TextEditingController())
                ],
              ),
              spaceHeight(context),
              Container(
                width: double.infinity,
                height: getHeight(context, height: 0.23),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: grey,
                ),
              ),
              spaceHeight(context, height: 0.1),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Menu",
                      style: smallTextStyle(context,
                          color: Colors.white, size: 21),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: getHeight(context, height: 0.23),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: grey,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.black,
                                ),
                                Text(
                                  "Chuon Raksa",
                                  style: smallTextStyle(context,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          spaceWidth(context, width: 0.02),
                          Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            Get.toNamed(RouteName.historyRoute);
                                            // Get.toNamed(
                                            //     RouteName.trackingRoute);
                                            // await NotificationService()
                                            //     .sendNotification(
                                            //         "", AppStore.to.newRequest);
                                            // var access =
                                            //     await NotificationService()
                                            //         .getAccessToken();
                                            // print(access);
                                          },
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: const Color(0xff322708),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.motorcycle,
                                                      color: Color(0xffFCD053)),
                                                  Text(
                                                    "Deliveries",
                                                    style: largeTextStyle(
                                                        context,
                                                        color: const Color(
                                                            0xffFCD053),
                                                        size: 10),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        spaceHeight(context, height: 0.02),
                                        GestureDetector(
                                          onTap: () => Get.toNamed(
                                              RouteName.requestRoute),
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: const Color(0xff124966),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.list_alt,
                                                      color: Color(0xff2EB4FC)),
                                                  Text(
                                                    "My Order",
                                                    style: largeTextStyle(
                                                        context,
                                                        color: const Color(
                                                            0xff2EB4FC),
                                                        size: 10),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  spaceWidth(context),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          Get.toNamed(RouteName.profileRoute),
                                      child: Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: const Color(0xff3B3F34),
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.person_pin_circle_sharp,
                                                color: green,
                                              ),
                                              Text(
                                                "Setting",
                                                style: smallTextStyle(context,
                                                    size: 16,
                                                    color: const Color(
                                                        0xff909090)),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              spaceHeight(context, height: 0.1),
              // Container(
              //   width: double.infinity,
              //   height: getHeight(context, height: 0.3),
              //   clipBehavior: Clip.hardEdge,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(20),
              //     color: Colors.red,
              //   ),
              //   child: Row(
              //     children: [
              //       Expanded(
              //           child: Padding(
              //         padding: const EdgeInsets.all(10.0),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             const Padding(
              //               padding: EdgeInsets.only(left: 15),
              //               child: Text("Tracking ID"),
              //             ),
              //             const Padding(
              //               padding: EdgeInsets.only(left: 15),
              //               child: Text("#ASFSAFGSA-SAFSAF"),
              //             ),
              //             spaceHeight(context),
              //             const Padding(
              //               padding: EdgeInsets.only(left: 15),
              //               child: Text("From"),
              //             ),
              //             const Row(
              //               children: [],
              //             )
              //           ],
              //         ),
              //       )),
              //       Expanded(
              //           child: Container(
              //         color: Colors.blue,
              //       ))
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      )),
    );
  }
}

import 'package:drivers/app/util/const.dart';
import 'package:drivers/controller/delivery_saving_controller.dart';
import 'package:drivers/model/parcel.dart';
import 'package:drivers/repository/parcel_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transparent_image/transparent_image.dart';

class DetailRouteSaving extends StatelessWidget {
  const DetailRouteSaving({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<DeliverySavingController>();
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Price: ${controller.listRequest[index].cost} VND",
                          style: mediumTextStyle(context),
                        ),
                        spaceHeight(context),
                        Text(
                          "Sender Address",
                          style: largeTextStyle(context, size: 24),
                        ),
                        spaceHeight(context, height: 0.02),
                        Text(
                          controller
                              .listRequest[index].senderAddress['senderAddres'],
                          style: smallTextStyle(context),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.arrow_drop_down,
                            size: 100,
                            color: green,
                          ),
                        ),
                        spaceHeight(context, height: 0.02),
                        Text(
                          "Receiver Address",
                          style: largeTextStyle(context, size: 24),
                        ),
                        spaceHeight(context, height: 0.02),
                        Text(
                          controller.listRequest[index]
                              .receiverAddress['receiverAddress'],
                          style: smallTextStyle(context),
                        ),
                        spaceHeight(context),
                        Text(
                          "Parcel's image",
                          style: smallTextStyle(context,
                              fontWeight: FontWeight.w700),
                        ),
                        FutureBuilder(
                            future: ParcelRepo().getParcelInfor(
                                controller.listRequest[index].parcelId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              Parcel parcel = snapshot.data as Parcel;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  spaceHeight(context, height: 0.02),
                                  SizedBox(
                                    height: getHeight(context, height: 0.15),
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index1) {
                                          return Container(
                                            clipBehavior: Clip.hardEdge,
                                            width: getHeight(context,
                                                height: 0.15),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: FadeInImage.memoryNetwork(
                                              placeholder: kTransparentImage,
                                              image: parcel.listImage[index1],
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            spaceWidth(context),
                                        itemCount: parcel.listImage.length),
                                  ),
                                  spaceHeight(context),
                                  Text(
                                    "Confirmation Image",
                                    style: smallTextStyle(context,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  spaceHeight(context, height: 0.02),
                                  parcel.imageConfirm.isEmpty
                                      ? const SizedBox()
                                      : Container(
                                          width:
                                              getHeight(context, height: 0.15),
                                          height:
                                              getHeight(context, height: 0.15),
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: FadeInImage.memoryNetwork(
                                              placeholder: kTransparentImage,
                                              image: parcel.imageConfirm),
                                        )
                                ],
                              );
                            })
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => spaceHeight(context),
                  itemCount: controller.listRequest.length))),
    );
  }
}

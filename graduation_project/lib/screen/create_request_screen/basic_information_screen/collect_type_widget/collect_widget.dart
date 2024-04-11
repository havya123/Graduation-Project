import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/app/util/const.dart';
import 'package:graduation_project/widgets/check_box.dart';

class CollectWidget extends StatelessWidget {
  CollectWidget({
    super.key,
    required this.title,
    required this.collectTime,
    required this.timeReceive,
    required this.isChecked,
    required this.isChoosed,
    required this.price,
  });
  String title, collectTime, timeReceive;
  Function(bool?) isChecked;
  RxBool isChoosed;
  RxDouble price;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xff202020),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        smallTextStyle(context, color: Colors.white, size: 16),
                  ),
                  Text(
                    collectTime,
                    style:
                        smallTextStyle(context, color: Colors.white, size: 12),
                  ),
                  spaceHeight(context, height: 0.02),
                  Text(
                    "Delivery to receiver",
                    style:
                        smallTextStyle(context, color: Colors.white, size: 12),
                  ),
                  Text(
                    timeReceive,
                    style:
                        smallTextStyle(context, color: Colors.white, size: 12),
                  ),
                  spaceHeight(context, height: 0.02),
                  Obx(() {
                    return Text(
                      "Price: ${price.value} VND",
                      style: smallTextStyle(context,
                          color: Colors.white, size: 12),
                    );
                  })
                ],
              ),
              Positioned(
                  top: -12,
                  right: 0,
                  child: CheckboxExample(
                    isChecked: isChoosed,
                    onChanged: isChecked,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:graduation_project/app/store/app_store.dart';
// import 'package:graduation_project/app/util/const.dart';
// import 'package:graduation_project/extension/snackbar.dart';
// import 'package:graduation_project/manage/controller/fill_profile_controller.dart';
// import 'package:graduation_project/widgets/button.dart';
// import 'package:transparent_image/transparent_image.dart';

// class FillProfileScreen extends GetView<FillProfileController> {
//   const FillProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 spaceHeight(context, height: 0.1),
//                 Container(
//                   width: 120,
//                   height: 120,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(100),
//                   ),
//                   child: Stack(
//                     children: [
//                       Center(
//                         child: Container(
//                             width: 110,
//                             height: 110,
//                             clipBehavior: Clip.hardEdge,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(100),
//                             ),
//                             child: FadeInImage.memoryNetwork(
//                                 placeholder: kTransparentImage,
//                                 image: AppStore.to.avatar)),
//                       ),
//                       Positioned(
//                           bottom: 0,
//                           right: 0,
//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: Center(
//                               child: SvgPicture.asset(ImageCustom.edit),
//                             ),
//                           ))
//                     ],
//                   ),
//                 ),
//                 spaceHeight(context),
//                 Column(
//                   children: [
//                     for (int i = 0;
//                         i < controller.listTitle.length;
//                         i++) ...<Widget>[
//                       InputWidget(
//                         controller: controller.listText[i],
//                         width: getWidth(context, width: 1),
//                         height: getHeight(context, height: 0.07),
//                         hint: controller.listTitle[i],
//                         borderRadius: 15,
//                         color: gray1,
//                       ),
//                       if (i < controller.listTitle.length - 1) ...<Widget>[
//                         spaceHeight(context, height: 0.02)
//                       ]
//                     ]
//                   ],
//                 ),
//                 spaceHeight(context, height: 0.02),
//                 Container(
//                   width: getWidth(context, width: 1),
//                   height: getHeight(context, height: 0.07),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                     color: gray1,
//                   ),
//                   child: DropdownButtonHideUnderline(
//                     child: Obx(() {
//                       return DropdownButton2(
//                         value: controller.selectedGender.value == ""
//                             ? null
//                             : controller.selectedGender.value,
//                         onChanged: (value) {
//                           controller.selectedGender.value = value!;
//                         },
//                         hint: const Text("Select Gender"),
//                         items: controller.listGender
//                             .map((String item) => DropdownMenuItem<String>(
//                                   value: item,
//                                   child: Text(
//                                     item,
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                 ))
//                             .toList(),
//                       );
//                     }),
//                   ),
//                 ),
//                 spaceHeight(context, height: 0.02),
//                 Container(
//                   width: getWidth(context, width: 1),
//                   height: getHeight(context, height: 0.07),
//                   decoration: BoxDecoration(
//                       color: gray1, borderRadius: BorderRadius.circular(15)),
//                   child: TimePickerSpinnerPopUp(
//                     mode: CupertinoDatePickerMode.date,
//                     initTime: DateTime.now(),
//                     maxTime: DateTime.now(),
//                     timeFormat: 'dd/MM/yyyy',
//                     cancelText: 'Cancel',
//                     confirmText: 'Ok',
//                     onChange: (p0) {},
//                     isCancelTextLeft: true,
//                   ),
//                 ),
//                 spaceHeight(context),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ButtonWidget(
//                         height: getHeight(context, height: 0.06),
//                         borderRadius: 8,
//                         function: () {
//                           Get.toNamed(RouteName.categoryRoute);
//                         },
//                         textButton: "Skip",
//                         buttonColor: gray1,
//                       ),
//                     ),
//                     spaceWidth(context),
//                     Expanded(
//                       child: ButtonWidget(
//                         borderRadius: 8,
//                         height: getHeight(context, height: 0.06),
//                         function: () async {
//                           MyDialogs.showProgress();
//                           await controller.updateProfile();
//                           Get.back();
//                           Get.offNamed(RouteName.categoryRoute);
//                         },
//                         textButton: "Continue",
//                         buttonColor: buttonBlue,
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

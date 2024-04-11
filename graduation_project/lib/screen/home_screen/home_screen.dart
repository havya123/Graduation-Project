// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:graduation_project/manage/controller/home_controller1.dart';

// class HomeScreen extends GetView<HomeController> {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() {
//         return GoogleMap(
//           polylines: Set<Polyline>.of(controller.polylines),
//           markers: Set<Marker>.of(controller.listMarkers),
//           mapType: MapType.normal,
//           initialCameraPosition:
//               CameraPosition(target: controller.pGooglePlex, zoom: 15),
//           onMapCreated: (GoogleMapController clr) {
//             controller.myController.complete(clr);
//           },
//         );
//       }),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           // controller.getCurrentPosition();
//           controller.drawPolylines(0);
//         },
//         child: const Icon(Icons.location_searching),
//       ),
//     );
//   }
// }

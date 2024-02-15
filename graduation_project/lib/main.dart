import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:graduation_project/app/route/route_custom.dart';
import 'package:graduation_project/app/route/route_name.dart';
import 'package:graduation_project/manage/bindings/home_binding.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: HomeBindings(),
      initialRoute: RouteName.homeRoute,
      getPages: RouteCustom.getPage,
    );
  }
}

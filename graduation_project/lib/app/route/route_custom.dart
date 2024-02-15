import 'package:get/get.dart';
import 'package:graduation_project/app/route/route_name.dart';
import 'package:graduation_project/screen/home_screen/home_screen.dart';

class RouteCustom {
  static final getPage = [
    GetPage(name: RouteName.homeRoute, page: () => const HomeScreen())
  ];
}

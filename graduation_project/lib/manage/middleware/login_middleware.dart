import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/app/route/route_name.dart';
import 'package:graduation_project/app/store/app_store.dart';

class LoginMiddleWare extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return AppStore.to.user.value != null
        ? RouteSettings(name: RouteName.categoryRoute)
        : null;
  }
}

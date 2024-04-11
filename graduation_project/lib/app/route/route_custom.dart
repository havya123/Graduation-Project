import 'package:get/get.dart';
import 'package:graduation_project/app/route/route_name.dart';
import 'package:graduation_project/manage/bindings/category_binding.dart';
import 'package:graduation_project/manage/bindings/detail_trip_binding.dart';
import 'package:graduation_project/manage/bindings/history_binding.dart';
import 'package:graduation_project/manage/bindings/login_binding.dart';
import 'package:graduation_project/manage/bindings/profile_binding.dart';
import 'package:graduation_project/manage/bindings/request_binding.dart';
import 'package:graduation_project/manage/bindings/tracking_binding.dart';
import 'package:graduation_project/manage/middleware/login_middleware.dart';
import 'package:graduation_project/screen/categoty_screen/category_screen.dart';
import 'package:graduation_project/screen/create_request_screen/create_request_screen.dart';
// import 'package:graduation_project/screen/create_request_screen/create_request_screen.dart';
import 'package:graduation_project/screen/create_request_screen/google_map_screen/destination_screen.dart';
import 'package:graduation_project/screen/create_request_screen/google_map_screen/picker_screen.dart';
import 'package:graduation_project/screen/detail_trip_screen/detail_trip_scren.dart';
import 'package:graduation_project/screen/history_screen.dart/history_screen.dart';
import 'package:graduation_project/screen/login_screen/login_screen.dart';
import 'package:graduation_project/screen/login_screen/otp_screen/otp_screen.dart';
import 'package:graduation_project/screen/login_screen/phone_registration/phone_register_screen.dart';
import 'package:graduation_project/screen/profile_screen/profile_screen.dart';
import 'package:graduation_project/screen/tracking_screen/searching_driver_screen.dart';

class RouteCustom {
  static final getPage = [
    GetPage(
      name: RouteName.pickerRoute,
      page: () => const PickerScreen(),
    ),
    GetPage(
      name: RouteName.loginRoute,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
      middlewares: [LoginMiddleWare()],
    ),
    GetPage(
      name: RouteName.phoneRegisterRoute,
      page: () => const PhoneRegisterScreen(),
    ),
    GetPage(
      name: RouteName.otpRoute,
      page: () => const OTPScreen(),
    ),
    GetPage(
      name: RouteName.categoryRoute,
      page: () => const CategoryScreen(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: RouteName.requestRoute,
      page: () => const CreateRequestScreen(),
      binding: RequestBinding(),
    ),
    GetPage(
      name: RouteName.profileRoute,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: RouteName.destinationRoute,
      page: () => const DestinationScreen(),
    ),
    GetPage(
      name: RouteName.trackingRoute,
      page: () => const TrackingScreen(),
      binding: TrackingBinding(),
    ),
    GetPage(
      name: RouteName.historyRoute,
      page: () => const HistoryScreen(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: RouteName.detailTripRoute,
      page: () => const DetailTripScreen(),
      binding: DetailTripBinding(),
    )
  ];
}

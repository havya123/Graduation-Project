import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:graduation_project/app/route/route_custom.dart';
import 'package:graduation_project/app/route/route_name.dart';
import 'package:graduation_project/app/store/app_store.dart';
import 'package:graduation_project/app/store/services.dart';
import 'package:graduation_project/app/util/key.dart';
import 'package:graduation_project/firebase_options.dart';
import 'package:graduation_project/manage/bindings/login_binding.dart';
import 'package:graduation_project/manage/firebase_service/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseService.firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //clearData();
  await Get.putAsync(
    () => AppServices().init(),
  );

  await Get.putAsync(() => AppStore().init());
  await dotenv.load(fileName: ".env");
  runApp(
    DevicePreview(
      enabled: kReleaseMode,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

Future<void> clearData() async {
  var prefs = await SharedPreferences.getInstance();
  prefs.remove(MyKey.driverSent);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: LoginBinding(),
      initialRoute: RouteName.loginRoute,
      getPages: RouteCustom.getPage,
    );
  }
}

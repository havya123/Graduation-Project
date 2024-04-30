import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:graduation_project/app/store/app_store.dart';
import 'package:graduation_project/app/store/services.dart';
import 'package:graduation_project/app/util/key.dart';
import 'package:graduation_project/manage/controller/geofire_assistant.dart';
import 'package:graduation_project/manage/controller/tracking_controller.dart';
import 'package:graduation_project/model/device_token_repo.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static Function? onRequestAccept;
  static final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    initialize();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await messaging.subscribeToTopic("Test");
    messaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        if (message.notification!.body == "Request Declined") {
          LatLng currentRequest = LatLng(
              AppStore.to.lastedRequest.value!.senderAddress['lat'],
              AppStore.to.lastedRequest.value!.senderAddress['lng']);

          GeoFireAssistant().sendRequestToDriver(currentRequest);
          return;
        }
        if (message.notification!.title == "Request Accept") {
          TrackingController.requestAccepted = true;
          showNotification(message);
          if (onRequestAccept == null) {
            return;
          } else {
            onRequestAccept!();
            return;
          }
        }
        if (message.notification!.body ==
            "Delivery man has picked up your order. Please comfirm to start delivery") {
          showNotification(message);
          return;
        }
      }
    });
  }

  static String firebaseMessagingScope =
      "https://www.googleapis.com/auth/firebase.messaging";

  Future<void> sendNotification(
      String receiverDeviceToken, dynamic title, dynamic body) async {
    String accessToken = dotenv.get('messageToken');
    const String fcmUrl =
        'https://fcm.googleapis.com/v1/projects/delivery-5f21b/messages:send';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken ',
    };

    final Map<String, dynamic> data = {
      'message': {
        'token': receiverDeviceToken,
        'notification': {
          'title': title,
          'body': body is String ? body : jsonEncode(body),
        },
      },
    };

    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: headers,
      body: jsonEncode(data),
    );

    print(response);

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification');
    }
  }

  Future<void> getDeviceToken() async {
    var mess = FirebaseMessaging.instance;
    String deviceToken = await mess.getToken() ?? "";
    await DeviceTokenRepo().createDeviceToken(AppStore.to.uid, deviceToken);
    AppServices.to.setString(MyKey.deviceToken, deviceToken);
  }

  void initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings(
          '@mipmap/ic_launcher'), // Corrected typo here
    );
    localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  void showNotification(RemoteMessage message) {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
          "com.example.graduation_project", "push_notification",
          importance: Importance.max, priority: Priority.high),
    );
    localNotificationsPlugin.show(
        DateTime.now().microsecond,
        message.notification?.title ?? "",
        message.notification?.body ?? "",
        notificationDetails,
        payload: message.data.toString());
  }
}

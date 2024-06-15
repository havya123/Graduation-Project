import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
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
      if (message.notification != null) {
        if (message.notification!.title == "Request Declined") {
          GeoFireAssistant.isSent = false;
          LatLng currentRequest = LatLng(
              AppStore.to.lastedRequest.value!.senderAddress['lat'],
              AppStore.to.lastedRequest.value!.senderAddress['lng']);
          GeoFireAssistant().sendRequestToDriver(currentRequest);
          return;
        }
        if (message.notification!.title == "Request Accept") {
          GeoFireAssistant.isSent = false;
          TrackingController.requestAccepted = true;
          GeoFireAssistant.driverSent.clear();
          AppServices.to.removeString(MyKey.driverSent);
          showNotification(message);
          var controller = Get.find<TrackingController>();
          controller.driverAccept.value = message.notification?.body ?? "";
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

  Future<String> getAccessToken() async {
    final accountCredentials = ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": "delivery-5f21b",
      "private_key_id": "e33b9e3194ec0ede2f53f81b9225de0d49458fce",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDNaASbNoiipIbE\n27+IeeAjZ8VZYrZzGCtoDQQ+PUGcMRCUJlLaNmtoA/nmE+JROQC9yBgNd32axzHU\nnF7S6vmeOD1e6rPhKEI5XfFcmqmccVOMUfh+VIWwWRaSYz/wvb6COuskiEF48QvQ\ndIH1mW6ZsxjtGE3/vZEpOsKUYreAXM3X9DMGkArzOM8kbJzyLyz8v4HlJelbd22B\nhVV+aJRTVYPTJMjYk/gVt64yzYln5F28OaGbtI/rFROFpj8emlEIY1+3e/3RLK81\nooCnL8bxa2kM1B5KuANw6UhlenxxNVWEoJUVXPLEb7eMSp328fVg105kAzC69oFN\nNFfuG11zAgMBAAECggEAR60VdmgIM+D/mjAoXOJSgWhTqEZW7kCv3OY15dYQUAWb\nCGd7H+Q/hJNmn4+uuLMQfCkXo5NfxCPgUpWiTS1rn3d2iumRjW8z9LrAX5UkvI+b\nHOr5sHOkFw5vXvO9Oy+rC9ytcxkM57wNaFdPhjldK8sgVpPVm/k1b1Ku1YLBD8wy\nZdc0qLcyuyv2YqZ5f4IuWe6Vtbf2sLjmDf87/5ecj9A6rCdYTdVcM35cQNpEkyxj\nfVxNLUsKdtg/s7zj+EMGpsfKXDjOmXL6Wc/nt8X/WP/kDk8PhrwfkBh6KX9spj9j\nPo3VfctVcNavezVLwVgkfEJdNO/Ok05EAFFpz2H9UQKBgQDvNPVszTzSTkUjpCWa\ncrNM4ykVqra3Pzl+WlHswCQ7xuvNkMPnZZ803psWAn9FwxTcDEQ0FO++P4mIYTRc\nao/yefQX6vovfXTJ8t+NPTuMiqtGWg7T/JFmxhTvJHvYrmTBcl0oG7AWnZLnalyI\nSDQCbP429OhMJK0ZXcCm/kSfqQKBgQDb05f48hkYlH0VZwk6M1J7F+569Nf9v1Ww\n1hLBeGiL0wc7L6DCw4ZDqLn5+pFYo5/YcfTW+BXPzUx94JzUavQjf3xJWs5GhwPO\nPJc1jYKMvBTJEG5hYPjhX/N6EHj0/V8E3VvW91CyD0lCP1E4i5rEgNoMjMT+gBcm\n3kDEcH71uwKBgCJi3Yj3c+/TepLmDNXH+UhrO0O3F6798rjcKPy8njjNnqYdUlwY\nOqux+F9QmpUftwbu6HsIK3KQ1ad6ObmzQ+AaceFiUPa0tS42sLYwADhy0q45Ufpd\nS1WX0fiSqQ77+tXoJ8YVPNnzauPDYWvh3UAgBOdHi4EuoIeN95zJ3nmJAoGBAK8W\ndloTQkfgpUwxuBjCHfTrF8iZUZvLFM53g5LTe7m6yGysv8fBAiTLs+1WVQQbt0on\nYdMC4CSWKVGtYFyUH4ZSmUS37cog6bgPbIR8BLphZ9DJpJEtMq4XxY64pg7D7DWs\nteSfMYfRQxFf6yo1j3zqAEK0sIbgsRAFP+L2kzjXAoGBAN+gbSErledu+ZGdnZ4T\nauWad4PnWQdUzXI81YUcN7ZSAPpNMcH9haJIlm3RqSjFtZ2yD3EiMX2FiGGq8+YX\n79O9LEM/ClslcD5Vt0sAsPWK5bh/e98mcvXBDoJywqbhTLSYhNnLSNmQe4YukCEj\nrnf4Y5A3BUhNLk7FJoYGiJ5w\n-----END PRIVATE KEY-----\n",
      "client_email": "delivery-5f21b@appspot.gserviceaccount.com",
      "client_id": "106494490895015421787",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/delivery-5f21b%40appspot.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    });
    final client = await clientViaServiceAccount(
        accountCredentials, [firebaseMessagingScope]);
    final accessToken = client.credentials.accessToken.data;
    return accessToken;
  }

  Future<void> sendNotification(String receiverDeviceToken, String title,
      String body, Map<String, dynamic> dataNoti) async {
    String accessToken = await getAccessToken();
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
          'body': body,
        },
        'data': {
          'body': jsonEncode(dataNoti),
        }
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
    await DeviceTokenRepo()
        .createDeviceToken(AppStore.to.uid.value, deviceToken);
    AppServices.to.setString(MyKey.deviceToken, deviceToken);
    AppStore.to.deviceToken.value = deviceToken;
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

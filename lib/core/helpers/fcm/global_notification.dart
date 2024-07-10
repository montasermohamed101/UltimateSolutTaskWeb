import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

class GlobalNotification {
  static StreamController<Map<String, dynamic>> _onMessageStreamController =
  StreamController.broadcast();

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  static late BuildContext context;
  static GlobalNotification instance = GlobalNotification._();
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  GlobalNotification._();

  setupNotification(BuildContext cxt) async {
    context = cxt;
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings("@mipmap/launcher_icon");
    var ios = IOSInitializationSettings();
    var initSettings = InitializationSettings(android: android, iOS: ios);
    _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onSelectNotification: flutterNotificationClick,
    );
    NotificationSettings settings =
    await messaging.requestPermission(provisional: true);
    print('User granted permission: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      messaging.getToken().then((token) {
        log("======== >>> fcmToken $token");
      });
      messaging.setForegroundNotificationPresentationOptions(
          alert: false, badge: false, sound: false);
      messaging
          .getInitialMessage()
          .then((message) => _showLocalNotification(message));
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("_____________________Message data:${message.data}");
        _showLocalNotification(message);
        _onMessageStreamController.add(message.data);
        // var count =context.read<NotifyCubit>().state.count;
        // print(count);
        // context.read<NotifyCubit>().onUpdateNotifyData(count+1);
      });
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('A new onMessageOpenedApp event was published!');
        flutterNotificationClick(json.encode(message.data));
      });
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
    print("Title: ${message.notification?.title}");
    print("Body: ${message.notification?.body}");
    print("Payload: ${message.data}");
    flutterNotificationClick(json.encode(message.data));
  }

  StreamController<Map<String, dynamic>> get notificationSubject {
    return _onMessageStreamController;
  }

  _showLocalNotification(RemoteMessage? message) async {
    if (message == null) return;
    String? path;
    BigPictureStyleInformation? bigPictureStyleInformation;
    if (message.notification?.android?.imageUrl != null) {
      path = await _downloadAndSaveFile("${message.notification?.title}");
      bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(path),
        largeIcon: FilePathAndroidBitmap(path),
        contentTitle: "${message.notification?.title}",
        summaryText: "${message.notification?.body}",
      );
    }

    var android = AndroidNotificationDetails(
      "${DateTime.now()}",
      "DEFAULT",
      priority: Priority.high,
      importance: Importance.max,
      playSound: true,
      largeIcon: path != null ? FilePathAndroidBitmap(path) : null,
      shortcutId: DateTime.now().toIso8601String(),
      styleInformation: bigPictureStyleInformation,
    );
    var ios = IOSNotificationDetails();
    var _platform = NotificationDetails(android: android, iOS: ios);
    _flutterLocalNotificationsPlugin.show(
        DateTime.now().microsecond,
        "${message.notification?.title}",
        "${message.notification?.body}",
        _platform,
        payload: json.encode(message.data));
  }

  Future<String> _downloadAndSaveFile(String url) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath =
        '${directory.path}/${directory.path.split("/").last}';
    await Dio().download(url, filePath);
    return filePath;
  }

  static Future flutterNotificationClick(String? payload) async {
    // BuildContext con =GlobalState.instance.get("context");
    print("tttttttttt $payload");
    var data = json.decode("${payload}");
    print("payload print ${data["body"]}");
    var body = json.decode(data["body"]);
    print("order_id${body["order_id"]}");
    // int orderId = body["order_id"];
    // Navigator.of(con).push(
    //   MaterialPageRoute(
    //     builder: (_) => OrderDetails(
    //       id: orderId,
    //     ),
    //   ),
    // );
    // AutoRouter.of(context).push(OrderDetailsRoute(id: 8));
  }
}
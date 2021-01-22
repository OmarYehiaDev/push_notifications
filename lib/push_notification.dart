import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;
  final FlutterLocalNotificationsPlugin fLNP =
      FlutterLocalNotificationsPlugin();

  PushNotificationService(this._fcm);
  Future initialize(BuildContext context) async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(
        IosNotificationSettings(),
      );
    }
    String token = await _fcm.getToken();
    print(token);
    _fcm.configure(
      // ignore: missing_return
      onMessage: (Map<String, dynamic> message) {
        NotificationMsg msg = NotificationMsg(
          title: message["notification"]["title"],
          body: message["notification"]["body"],
        );
        showSimpleNotification(
          Text(
            msg.title,
          ),
          subtitle: Text(
            msg.body,
          ),
          duration: Duration(seconds: 3),
        );
      },
      onBackgroundMessage: backgroundMsgHandler,
    );
  }

  static Future<dynamic> backgroundMsgHandler(
      Map<String, dynamic> message) async {
    NotificationMsg msg = NotificationMsg(
      title: message["notification"]["title"],
      body: message["notification"]["body"],
    );
    AndroidNotificationDetails androidPlatformChannel =
        AndroidNotificationDetails(
      "0",
      "basic",
      "Test Channel",
      importance: Importance.max,
      priority: Priority.high,
      icon: "app_icon",
      largeIcon: DrawableResourceAndroidBitmap("app_icon"),
    );
    NotificationDetails platformChannel = NotificationDetails(
      android: androidPlatformChannel,
    );
    await FlutterLocalNotificationsPlugin().show(
      0,
      msg.title,
      msg.body,
      platformChannel,
    );
  }
}

class NotificationMsg {
  final String title;
  final String body;
  NotificationMsg({
    @required this.title,
    @required this.body,
  });
}

import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqflite_database/02SeptemberFirebasePushNotification/notification_badge.dart';
import 'package:flutter_sqflite_database/02SeptemberFirebasePushNotification/push_notification_model.dart';
import 'package:overlay_support/overlay_support.dart';

class MyFirebaseMessaging extends StatefulWidget {
  const MyFirebaseMessaging({Key? key}) : super(key: key);

  @override
  State<MyFirebaseMessaging> createState() => _MyFirebaseMessagingState();
}

class _MyFirebaseMessagingState extends State<MyFirebaseMessaging> {
  late int _totalNotification;
  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;

  void requestAndRegisterNotification() async {
    // Initialize the Firebase app
    await Firebase.initializeApp();

    // instantiate firebase messaging
    _messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // on IOS help to take userPermission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('user granted permision');

      String? token = await _messaging.getToken();
      log('token : $token');

      // for handling receive notification
      

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // parse massage received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        setState(() {
          _notificationInfo = notification;
          _totalNotification++;
        });

        if (_notificationInfo != null) {
          // for display notification in overlay
          // this come from overlay_support: ^2.0.1
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            leading: NotificationBadge(totalNotification: _totalNotification),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.cyan.shade700,
            duration: const Duration(seconds: 2),
          );
        }
      });
    } else {
      log('==> decline or not permission');
    }
  }

  @override
  void initState() {
    _totalNotification = 0;
    requestAndRegisterNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Notification App',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black.withOpacity(0.52),
          ),
        ),
        const SizedBox(height: 20),
        NotificationBadge(totalNotification: _totalNotification),
        const SizedBox(height: 20),
        _notificationInfo != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title : ${_notificationInfo!.title}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'body : ${_notificationInfo!.body}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w200,
                      color: Colors.black26,
                    ),
                  ),
                ],
              )
            : Container()
      ],
    );
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('handling background message : ${message.messageId}');
}

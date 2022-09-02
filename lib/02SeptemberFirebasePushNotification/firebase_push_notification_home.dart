import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_messaging.dart';

class FirebasePushNotificationHome extends StatelessWidget {
  const FirebasePushNotificationHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Firebase Notification',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.cyanAccent,
        elevation: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
      ),
      body: FirebaseMessaging(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
class FirebaseMessaging extends StatefulWidget {
  const FirebaseMessaging({Key? key}) : super(key: key);

  @override
  State<FirebaseMessaging> createState() => _FirebaseMessagingState();
}

class _FirebaseMessagingState extends State<FirebaseMessaging> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

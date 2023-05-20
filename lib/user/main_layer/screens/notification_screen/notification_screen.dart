import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    configureCallBak();
    super.initState();
  }

  configureCallBak() {
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('coming soon '),
      ),
    );
  }
}

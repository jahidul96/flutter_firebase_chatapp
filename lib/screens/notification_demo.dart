// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import '../features/push_notification.dart';

class NotificationDemoScreen extends StatefulWidget {
  const NotificationDemoScreen({super.key});

  @override
  State<NotificationDemoScreen> createState() => _NotificationDemoScreenState();
}

class _NotificationDemoScreenState extends State<NotificationDemoScreen> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    notificationServices.requestPermissonNotification();
    notificationServices.getToken().then((value) {
      print(value);
    });
    notificationServices.firebaseInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Push Notification"),
      ),
    );
  }
}

import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_management/model/notificationData.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// class NotificationService {
//   // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   Future<String?> getUserDeviceToken(String userId) async {
//     try {
//       final userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();
//
//       final deviceToken = userDoc.get('fcmToken');
//       print('User Device Token: $deviceToken');
//
//       return deviceToken;
//     } catch (error) {
//       print('Failed to get user device token. Error: $error');
//       return null;
//     }
//   }
//
//   Future<void> sendNotification(String deviceToken, String title,
//       String notificationBody) async {
//     final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
//     print('send 00');
//
//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization':
//       'key=AAAAjvYbOdU:APA91bGtSsmPqBONIbhHZosII6W00FZy3hi-aRVNQBVK9jhs2ZQ0EsN3Ozz63KQzYmMUcUY5OXnQ1VAimp6I50yisI5uOImHFJ6B7FmUoDgADRvVq3IfvYfywNthh_tgeoa7BFPJ403-',
//     };
//
//     print('send 1 ');
//     final requestBody = {
//       'notification': {
//         'title': title,
//         'body': notificationBody,
//         'priority': 'high',
//       },
//       'to': deviceToken,
//     };
//     print('send 2 ');
//
//     final response = await http.post(
//       url,
//       headers: headers,
//       body: json.encode(requestBody),
//     );
//     print('send 3 ');
//
//     if (response.statusCode == 200) {
//       print('send 4 ');
//
//       print('Notification sent successfully');
//       await FirebaseFirestore.instance.collection('notifications').add({
//         'title': title,
//         'body': notificationBody,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//     } else {
//       print('Failed to send notification. Error: ${response.body}');
//     }
//   }
//
//   static Future<void> sendLocalNotification({
//     required String title,
//     required String message,
//   }) async {
//     try {
//       final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//       const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//         'task_channel',
//         'Task Channel',
//         importance: Importance.high,
//         priority: Priority.high,
//         playSound: true,
//         enableVibration: true,
//       );
//       const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);
//
//       await flutterLocalNotificationsPlugin.show(
//         0,
//         title,
//         message,
//         platformChannelSpecifics,
//       );
//     } catch (error) {
//       print('Error sending local notification: $error');
//     }
//   }
//
//   static clearNotifications() async {
//     try {
//       final collection = FirebaseFirestore.instance.collection('notifications');
//       final snapshot = await collection.get();
//       for (DocumentSnapshot doc in snapshot.docs) {
//         await doc.reference.delete();
//       }
//       // notifications.clear();
//
//       print('Notifications collection cleared');
//     } catch (error) {
//       print('Error clearing notifications: $error');
//     }
//   }
//
// }

class NotificationsService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings( 'mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message while the app is in the foreground!');
      showNotification(
        title: message.notification?.title ?? 'New Notification',
        message: message.notification?.body ?? 'You have a new notification',
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification opened from terminated state!');
      // Handle navigation to a specific screen
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Handling a background message!');
    showNotification(
      title: message.notification?.title ?? 'New Notification',
      message: message.notification?.body ?? 'You have a new notification',
    );
  }

  void showNotification({
    required String title,
    required String message,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'task_channel',
      'Task Channel',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      message,
      platformChannelSpecifics,
    );
  }

  Future<void> sendTaskNotificationToUser({
    required String userId,
    required String title,
    required String description,
  }) async {
    try {
      final deviceToken = await _getDeviceToken(userId);

      if (deviceToken != null) {
        final notificationData = NotificationData(
          title: title,
          description: description,
          isLocalNotification: false,
          createdAt: DateTime.now(),
          isSeen: false,
        );

        await FirebaseFirestore.instance
            .collection('notifications')
            .add(notificationData.toMap());

        await sendNotification(
          deviceToken: deviceToken,
          title: title,
          notificationBody: description,
        );

        print('Notification sent to user: $userId');
      } else {
        print('User device token not available for user: $userId');
      }
    } catch (error) {
      print('Error sending notification: $error');
    }
  }

  Future<String?> _getDeviceToken(String userId) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    final userSnapshot = await userDoc.get();

    if (userSnapshot.exists) {
      return userSnapshot.get('fcmToken');
    }

    return null;
  }

  Future<void> sendNotification({
    required String deviceToken,
    required String title,
    required String notificationBody,
  }) async {
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=AAAAjvYbOdU:APA91bGtSsmPqBONIbhHZosII6W00FZy3hi-aRVNQBVK9jhs2ZQ0EsN3Ozz63KQzYmMUcUY5OXnQ1VAimp6I50yisI5uOImHFJ6B7FmUoDgADRvVq3IfvYfywNthh_tgeoa7BFPJ403-',
    };

    final requestBody = {
      'notification': {
        'title': title,
        'body': notificationBody,
        'priority': 'high',
      },
      'to': deviceToken,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification. Error: ${response.body}');
    }
  }

  Future<String?> getUserDeviceToken(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      final deviceToken = userDoc.get('fcmToken');
      print('User Device Token: $deviceToken');
      return deviceToken;
    } catch (error) {
      print('Failed to get user device token. Error: $error');
      return null;
    }
  }

  initAwesome() {
    AwesomeNotifications().initialize(
      'resource://mipmap/ic_launcher',
      [
        NotificationChannel(
          playSound: true,
          enableVibration: true,
          channelKey: 'task_channel',
          channelName: 'Task Channel',
          defaultColor: Colors.blue,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          channelDescription: "Channel for task notifications",
        ),
      ],
    );
  }

  Future<void> firebaseBackgroundMessage(RemoteMessage message) async {
    initAwesome();
  }

  static void handleNotification(RemoteMessage message) {
    final notification = message.notification;
    final title = notification?.title ?? '';
    final body = notification?.body ?? '';

    sendLocalNotification(title: title, message: body);
  }

  // for local notification
  static Future<void> sendLocalNotification({
    required String title,
    required String message,
  }) async {
    try {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'task_channel',
        'Task Channel',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
        0,
        title,
        message,
        platformChannelSpecifics,
      );
    } catch (error) {
      print('Error sending local notification: $error');
    }
  }

  clearNotifications() async {
    try {
      final collection = FirebaseFirestore.instance.collection('notifications');
      final snapshot = await collection.get();
      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
      print('Notifications collection cleared');
    } catch (error) {
      print('Error clearing notifications: $error');
    }
  }
}

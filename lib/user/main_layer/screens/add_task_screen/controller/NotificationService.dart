// import 'dart:math';
//
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
// import 'package:flutter/material.dart';
//
// class NotificationService {
//   static Future<void> sendNotificationToUser(
//       String userToken, String title, String body) async {
//     try {
//       AwesomeNotificationsFirebase().initialize(
//         null,
//         [
//           NotificationChannel(
//             channelKey: 'task_management',
//             channelName: 'Task Management',
//             channelDescription: 'Channel for task management notifications',
//             defaultColor: Colors.blue,
//             ledColor: Colors.blue,
//           ),
//         ],
//       );
//
//       await AwesomeNotificationsFirebase().createNotification(
//         content: NotificationContent(
//           id: generateUniqueId(),
//           channelKey: 'task_management',
//           title: title,
//           body: body,
//         ),
//         actionButtons: [
//           NotificationActionButton(
//             key: 'mark_as_read',
//             label: 'Mark as Read',
//           ),
//         ],
//       );
//     } catch (error) {
//       print('Error sending notification: $error');
//       // Handle the error
//     }
//   }
//
//   static Future<String> getUserFCMToken() async {
//     String firebaseAppToken = '';
//     if (await AwesomeNotificationsFirebase().isFirebaseAvailable) {
//       try {
//         firebaseAppToken =
//             await AwesomeNotificationsFirebase().requestFirebaseAppToken();
//       } catch (exception) {
//         debugPrint('$exception');
//       }
//     } else {
//       debugPrint('Firebase is not available on this project');
//     }
//     return firebaseAppToken;
//   }
//
//   static void initializeNotificationChannel() {
//     AwesomeNotificationsFirebase().initialize(
//       '@mipmap/ic_launcher',
//       [
//         NotificationChannel(
//           channelKey: 'my_notification_channel',
//           channelName: 'Task Management',
//           channelDescription: 'Task Management',
//           ledColor: const Color(0xff0000FF),
//           playSound: true,
//           enableVibration: true,
//           importance: NotificationImportance.High,
//           channelShowBadge: true,
//         ),
//       ],
//     );
//   }
//
//   static int generateUniqueId() {
//     final random = Random();
//     return random.nextInt(2147483647);
//   }
// }

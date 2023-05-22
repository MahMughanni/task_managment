//
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:meta/meta.dart';
// import 'package:task_management/model/notification_data_model.dart';
//
// part 'notification_state.dart';
//
// class NotificationCubit extends Cubit<NotificationState> {
//   NotificationCubit() : super(const NotificationState([])) {
//     _configureAwesomeNotifications();
//   }
//
//   Future<void> loadNotifications() async {
//     final List<MyNotificationModel> notifications =
//         (await AwesomeNotifications().listScheduledNotifications())
//             .map((notification) => MyNotificationModel(
//                   title: notification.content!.title!,
//                   body: notification.content!.body!,
//                   timestamp: notification.content!.createdDate!,
//                 ))
//             .toList();
//     emit(NotificationState(notifications));
//   }
//
//   Future<void> addNotification(MyNotificationModel notification) async {
//     final List<MyNotificationModel> currentNotifications = state.notifications;
//     final List<MyNotificationModel> updatedNotifications =
//         List.from(currentNotifications)..add(notification);
//     await AwesomeNotifications().createNotification(
//       content: _mapNotificationModelToContent(notification),
//     );
//     emit(NotificationState(updatedNotifications));
//   }
//
//   Future<void> clearOutdatedNotifications() async {
//     final List<MyNotificationModel> notifications = state.notifications;
//     final DateTime currentTime = DateTime.now();
//
//     final List<MyNotificationModel> updatedNotifications =
//         notifications.where((notification) {
//       final Duration timeDifference =
//           currentTime.difference(notification.timestamp);
//       return timeDifference.inDays <
//           1; // Keep notifications within the last day
//     }).toList();
//
//     await AwesomeNotifications().cancelAllSchedules();
//     for (final notification in updatedNotifications) {
//       await AwesomeNotifications().createNotification(
//         content: _mapNotificationModelToContent(notification),
//       );
//     }
//     emit(NotificationState(updatedNotifications));
//   }
//
//   void _configureAwesomeNotifications() {
//     AwesomeNotifications().initialize(
//       null,
//       [
//         NotificationChannel(
//           channelKey: 'channel_key',
//           channelName: 'Channel Name',
//           channelDescription: 'Channel Description',
//           defaultColor: Colors.blueAccent,
//           ledColor: Colors.blueAccent,
//           playSound: true,
//           enableVibration: true,
//         ),
//       ],
//     );
//
//     AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
//       if (!isAllowed) {
//         AwesomeNotifications().requestPermissionToSendNotifications();
//       }
//     });
//   }
//
//   static NotificationContent _mapNotificationModelToContent(
//     MyNotificationModel notification,
//   ) {
//     return NotificationContent(
//       id: notification.id!,
//       // Convert 'id' to String
//       channelKey: 'channel_key',
//       title: notification.title,
//       body: notification.body,
//       payload: notification.toJson(),
//     );
//   }
// }

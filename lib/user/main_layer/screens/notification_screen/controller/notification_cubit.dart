import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/model/notificationData.dart';
import 'package:task_management/user/main_layer/screens/notification_screen/controller/NotificationService.dart';
import 'package:bloc/bloc.dart';

class NotificationCubit extends Cubit<List<NotificationData>> {
  NotificationCubit() : super([]) {
    listenToNotifications();
  }

  void markNotificationAsSeen(int index) {
    if (index >= 0 && index < state.length) {
      final updatedNotifications = List<NotificationData>.from(state);
      updatedNotifications[index] = NotificationData(
        title: state[index].title,
        description: state[index].description,
        isSeen: true,
        isLocalNotification: true,
        createdAt: DateTime.now(),
      );
      emit(updatedNotifications);
    }
  }

  void listenToNotifications() {
    FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        print('No notifications found');
        return;
      }

      final notifications = snapshot.docs.map((doc) {
        return NotificationData.fromSnapshot(doc);
      }).toList();

      emit(notifications);

      for (var notification in notifications) {
        if (!notification.isSeen) {
          final title = notification.title ?? 'New Notification';
          final message = notification.description ?? 'You have a new notification';

          print('Notification Title: $title');
          print('Notification Description: $message');

          NotificationsService().showNotification(
            title: title,
            message: message,
          );
        }
      }
    }, onError: (error) {
      print('Error retrieving notifications: $error');
    });
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/model/notificationData.dart';
import 'package:task_management/user/main_layer/screens/notification_screen/controller/NotificationService.dart';
import 'package:bloc/bloc.dart';

class NotificationCubit extends Cubit<List<NotificationData>> {
  StreamSubscription<QuerySnapshot>? _notificationSubscription;

  NotificationCubit() : super([]) {
    listenToNotifications();
  }

  Future<void> deleteAllNotifications() async {
    final notificationsCollection =
        FirebaseFirestore.instance.collection('notifications');
    final snapshot = await notificationsCollection.get();
    final batch = FirebaseFirestore.instance.batch();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    try {
      await batch.commit();
      print('All notifications deleted from Firebase');
      emit([]);
    } catch (e) {
      print('Failed to delete all notifications: $e');
    }
  }

  void markNotificationAsSeen(String notificationId) {
    final updatedNotifications = List<NotificationData>.from(state);
    final index =
        updatedNotifications.indexWhere((n) => n.id == notificationId);
    if (index >= 0 && index < state.length) {
      updatedNotifications.removeAt(index);
      emit(updatedNotifications);
      deleteAllNotifications();
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

      final latestNotification = notifications.first;

      if (!latestNotification.isSeen) {
        final title = latestNotification.title ?? 'New Notification';
        final message =
            latestNotification.description ?? 'You have a new notification';

        print('Notification Title: $title');
        print('Notification Description: $message');

        NotificationsService().showNotification(
          title: title,
          message: message,
        );
      }
    }, onError: (error) {
      print('Error retrieving notifications: $error');
    });
  }

  void stopListeningToNotifications() {
    _notificationSubscription?.cancel();
  }
}

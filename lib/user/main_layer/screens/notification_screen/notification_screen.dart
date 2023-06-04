import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:task_management/model/notificationData.dart';
import 'package:task_management/user/main_layer/screens/notification_screen/controller/notification_cubit.dart';
import 'package:task_management/utils/app_constants.dart';

import 'controller/NotificationService.dart';

class NotificationScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final notificationCubit = context.read<NotificationCubit>();

    // Start listening to notifications
    useEffect(() {
      notificationCubit.listenToNotifications();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: BlocBuilder<NotificationCubit, List<NotificationData>>(
        builder: (context, notifications) {
          if (notifications.isEmpty) {
            return const Center(
              child: Text('Empty'),
            );
          } else {
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  title: Text(notification.title ?? ''),
                  subtitle: Text(notification.description ?? ''),
                  trailing: notification.isSeen
                      ? null
                      : ElevatedButton(
                    onPressed: () {
                      notificationCubit.markNotificationAsSeen(index);
                    },
                    child: const Text('Mark as Seen'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

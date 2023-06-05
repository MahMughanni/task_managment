import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/model/notificationData.dart';
import 'package:task_management/user/main_layer/screens/notification_screen/controller/notification_cubit.dart';

class NotificationScreen extends HookWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationCubit = context.read<NotificationCubit>();
    useEffect(() {
      notificationCubit.listenToNotifications();
      return () {
        notificationCubit.stopListeningToNotifications();
      };
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              notificationCubit.deleteAllNotifications();
            },
            child: const Text('Mark All as Seen'),
          ),
          Expanded(
            child: BlocBuilder<NotificationCubit, List<NotificationData>>(
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
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xffF6F6F6),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        height: 70.h,
                        child: ListTile(
                          title: Text(notification.title ?? ''),
                          subtitle: Text(notification.description ?? ''),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

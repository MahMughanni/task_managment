import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/model/notification_data_model.dart';
import 'package:task_management/user/main_layer/screens/notification_screen/controller/notification_cubit.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      // body: BlocBuilder<NotificationCubit, NotificationState>(
      //   builder: (context, state) {
      //     final List<MyNotificationModel> notifications = state.notifications;
      //     print('notifications: $notifications');
      //
      //     return Column(
      //       children: [
      //         const Text('Notifications'),
      //         Expanded(
      //           child: ListView.builder(
      //             itemCount: notifications.length,
      //             itemBuilder: (context, index) {
      //               final MyNotificationModel notification =
      //                   notifications[index];
      //               print('notification: $notification');
      //
      //               return ListTile(
      //                 title: Text(
      //                   notification.title,
      //                   style: Theme.of(context).textTheme.bodyLarge,
      //                 ),
      //                 subtitle: Text(
      //                   notification.body,
      //                   style: Theme.of(context).textTheme.bodyLarge,
      //                 ),
      //               );
      //             },
      //           ),
      //         ),
      //       ],
      //     );
      //   },
      // ),
    );
  }
}

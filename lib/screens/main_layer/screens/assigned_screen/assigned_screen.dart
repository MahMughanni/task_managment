import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_mangment/logic/firebase_controller.dart';
import 'package:task_mangment/model/task_model.dart';

import '../../../../shared_widgets/custom_appbar.dart';
import '../home_screen/widgets/custom_task_list.dart';

class AssignedScreen extends StatelessWidget {
  AssignedScreen({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppbar(
        title: 'Assigned Tasks',
        action: [
          Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ],
      ),
      body: StreamBuilder<List<TaskModel>>(
        stream: FireBaseController.getUserTasksStream(userId: user.uid),
        builder:
            (BuildContext context, AsyncSnapshot<List<TaskModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Container();
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text(
                'No data found.',
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
            );
          } else {
            return CustomTaskList(
              state: 'upcoming',
              label: '',
              userTask: FireBaseController.getUserTasksStream(userId: user.uid),
            );
          }
        },
      ),
    );
  }
}

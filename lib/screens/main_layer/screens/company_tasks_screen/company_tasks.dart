import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../logic/firebase_controller.dart';
import '../../../../shared_widgets/custom_appbar.dart';
import '../home_screen/widgets/custom_task_list.dart';

class CompanyTasksScreen extends StatelessWidget {
  CompanyTasksScreen({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppbar(
            height: 150,
            title: 'Company Tasks',
            action: const [],
            bottom: TabBar(
                unselectedLabelColor: Colors.black,
                splashBorderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                splashFactory: InkRipple.splashFactory,
                indicator: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                    color: Colors.blueAccent.withOpacity(.8)),
                tabs: const [
                  Tab(
                    text: 'Today',
                  ),
                  Tab(
                    text: 'Upcoming',
                  ),
                  Tab(
                    text: 'Completed',
                  ),
                ]),
          ),
          // body: TabBarView(
          //   children: [
          //     CustomTaskList(
          //       state: 'today',
          //       label: '',
          //       userTask:
          //           FireBaseRepository.getUserTasksStream(userId: user.uid),
          //     ),
          //     CustomTaskList(
          //       state: 'upcoming',
          //       label: '',
          //       userTask:
          //           FireBaseRepository.getUserTasksStream(userId: user.uid),
          //     ),
          //     CustomTaskList(
          //       state: 'completed',
          //       label: '',
          //       userTask:
          //           FireBaseRepository.getUserTasksStream(userId: user.uid),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}

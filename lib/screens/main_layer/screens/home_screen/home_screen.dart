import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:task_mangment/screens/main_layer/screens/home_screen/widgets/custom_sliver_appbar.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/widgets/custom_task_list.dart';
import 'package:task_mangment/shared_widgets/cutom_container.dart';

import '../../../../logic/firebase_controller.dart';
import '../../../../model/task_model.dart';
import '../../../../model/user_model.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;
  final List taskTitles = [
    'Tasks',
    'Assigned',
    'Completed',
  ];

  @override
  Widget build(BuildContext context) {
    String userId = user.uid;
    final userFuture = FireBaseRepository.getUserInfo();
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        bottom: true,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: FutureBuilder(
            future: userFuture,
            builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final userData = snapshot.data!;
                return NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      StreamBuilder<List<TaskModel>>(
                        stream: FireBaseRepository.getUserTasksStream(
                            userId: user.uid),
                        builder: (context2, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return BuildSliverAppBar(
                              userName: userData.userName.toString(),
                              taskNumber: 'Loading...',
                              itemCount: 3,
                              itemBuilder: (BuildContext context, int index) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[350]!,
                                  highlightColor: Colors.grey[700]!,
                                  child: const CustomContainer(
                                    color: Color(0x86e5e5e5),
                                    title: '',
                                    taskNumber: '',
                                  ),
                                );
                              },
                              imageUrl: userData.profileImageUrl.toString(),
                              userId: userId,
                            );
                          } else if (snapshot.hasError) {
                            return BuildSliverAppBar(
                              userName: userData.userName.toString(),
                              taskNumber: 'Error: ${snapshot.error}',
                              itemCount: 3,
                              itemBuilder: (BuildContext context, int index) {
                                return Container();
                              },
                              imageUrl: '',
                              userId: userId,
                            );
                          } else {
                            List<TaskModel> userTasks = snapshot.data!;
                            return BuildSliverAppBar(
                              userName: userData.userName.toString(),
                              taskNumber: userTasks.length.toString(),
                              itemCount: 3,
                              itemBuilder: (BuildContext context, int index) {
                                int todayTasksCount = userTasks.length;
                                int upcomingTasksCount = userTasks
                                    .where((task) => task.state == 'upcoming')
                                    .length;
                                int completedTasksCount = userTasks
                                    .where((task) => task.state == 'completed')
                                    .length;

                                switch (index) {
                                  case 0:
                                    return CustomContainer(
                                      color: const Color(0xffF9B5D0),
                                      title: 'Tasks',
                                      taskNumber: todayTasksCount.toString(),
                                    );
                                  case 1:
                                    return CustomContainer(
                                      color: const Color(0xffC9F4AA),
                                      title: 'Assigned',
                                      taskNumber: upcomingTasksCount.toString(),
                                    );
                                  case 2:
                                    return CustomContainer(
                                      color: const Color(0xffF3CCFF),
                                      title: 'Completed',
                                      taskNumber:
                                          completedTasksCount.toString(),
                                    );
                                  default:
                                    return const CustomContainer(
                                        title: '', taskNumber: '');
                                }
                              },
                              imageUrl: userData.profileImageUrl ?? '',
                              userId: userId,
                            );
                          }
                        },
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: [
                      CustomTaskList(
                        userName: userData.userName,
                        state: 'today',
                        label: 'today',
                        userTask: FireBaseRepository.getUserTasksStream(
                          userId: userId,
                        ),
                      ),
                      CustomTaskList(
                        userName: userData.userName,
                        state: 'upcoming',
                        label: 'Upcoming',
                        userTask: FireBaseRepository.getUserTasksStream(
                          userId: userId,
                        ),
                      ),
                      CustomTaskList(
                        userName: userData.userName,
                        state: 'completed',
                        label: 'Completed',
                        userTask: FireBaseRepository.getUserTasksStream(
                          userId: userId,
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class BuildSliverAppBar extends StatelessWidget {
  const BuildSliverAppBar({
    Key? key,
    required this.userName,
    required this.taskNumber,
    required this.itemCount,
    required this.itemBuilder,
    required this.imageUrl,
    required this.userId,
  }) : super(key: key);

  final String userName, taskNumber, imageUrl, userId;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SliverPersistentHeader(
      delegate: CustomSliverAppBar(
        expandedHeight: screenSize.height * .36,
        userName: userName,
        taskNumber: taskNumber,
        itemBuilder: itemBuilder,
        itemCount: itemCount,
        imageUrl: imageUrl,
        userId: userId,
      ),
    );
  }
}

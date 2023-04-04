import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/widgets/custom_sliver_appbar.dart';
import 'package:task_mangment/utils/UtilsConfig.dart';

import '../../../../logic/firebase_controller.dart';
import '../../../../model/task_model.dart';
import '../../../../model/user_model.dart';
import '../../../../shared_widgets/list_item_body.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final userFuture = FireBaseController.getUserInfo();
    final userTasks = FireBaseController.getUserTasks(userId: user.uid);
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
                        FutureBuilder<List<TaskModel>>(
                          future:
                              FireBaseController.getUserTasks(userId: user.uid),
                          builder: (context2, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SliverPersistentHeader(
                                delegate: MySliverAppBar(
                                  expandedHeight: 300,
                                  userName: userData.userName.toString(),
                                  taskNumber: 'Loading...',
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return SliverPersistentHeader(
                                delegate: MySliverAppBar(
                                  expandedHeight: 300,
                                  userName: userData.userName.toString(),
                                  taskNumber: 'Error: ${snapshot.error}',
                                ),
                              );
                            } else {
                              List<TaskModel> userTasks = snapshot.data!;
                              return SliverPersistentHeader(
                                delegate: MySliverAppBar(
                                  expandedHeight: 300,
                                  userName: userData.userName.toString(),
                                  taskNumber: userTasks.length.toString(),
                                ),
                              );
                            }
                          },
                        ),
                      ];
                    },
                    body: TabBarView(
                      children: [
                        FutureBuilder<dynamic>(
                          future: userTasks,
                          builder: (mContext, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }
                            final tasks = snapshot.data!;
                            return ListView.builder(
                                itemCount: tasks.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  // print(tasks[index].state);
                                  if (tasks[index].state == 'today') {
                                    return ListViewItemBody(
                                      title: tasks[index].description,
                                      startTime: UtilsConfig.formatTime(
                                              tasks[index].startTime)
                                          .toString(),
                                      userName: tasks[index].title,
                                      taskCategory: tasks[index].state,
                                      // endTime: tasks[index].endTime,
                                    );
                                  } else {
                                    return Container();
                                  }
                                });
                          },
                        ),
                        FutureBuilder<dynamic>(
                          future: userTasks,
                          builder: (mContext, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }
                            final tasks = snapshot.data!;
                            return ListView.builder(
                                itemCount: tasks.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  // print(tasks[index].state);
                                  if (tasks[index].state == 'upcoming') {
                                    return ListViewItemBody(
                                      title: tasks[index].description,
                                      startTime: UtilsConfig.formatTime(
                                              tasks[index].startTime)
                                          .toString(),
                                      userName: tasks[index].title,
                                      taskCategory: tasks[index].state,
                                      // endTime: tasks[index].endTime,
                                    );
                                  } else {
                                    return Container();
                                  }
                                });
                          },
                        ),
                        FutureBuilder<dynamic>(
                          future: userTasks,
                          builder: (mContext, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }
                            final tasks = snapshot.data!;
                            return ListView.builder(
                                itemCount: tasks.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  // print(tasks[index].state);
                                  if (tasks[index].state == 'completed') {
                                    return ListViewItemBody(
                                      title: tasks[index].description,
                                      startTime: UtilsConfig.formatTime(
                                              tasks[index].startTime)
                                          .toString(),
                                      userName: tasks[index].title,
                                      taskCategory: tasks[index].state,
                                      // endTime: tasks[index].endTime,
                                    );
                                  } else {
                                    return Container();
                                  }
                                });
                          },
                        ),
                      ],
                    ));
              }
            },
          ),
        ),
      ),
    );
  }
}

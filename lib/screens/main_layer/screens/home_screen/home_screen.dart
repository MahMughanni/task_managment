import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_mangment/model/task_model.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/widgets/custom_sliver_appbar.dart';

import '../../../../logic/auth_provider.dart';
import '../../../../model/user_model.dart';
import '../../../../shared_widgets/list_item_body.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final userFuture = AuthFireBase.getUserInfo();
    final userTasks = AuthFireBase.getUserTasks(userId: user.uid);
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
                        SliverPersistentHeader(
                            delegate: MySliverAppBar(
                          expandedHeight: 300,
                          userName: userData.userName.toString(),
                        ))
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
                                // print(tasks[index].title);
                                return ListViewItemBody(
                                  title: tasks[index].title,
                                  startTime: tasks[index].createdDate.toString(),
                                  userName: 'name',
                                  taskCategory: 'Task Category',
                                  // endTime: tasks[index].endTime,
                                );
                              },
                            );
                          },
                        ),
                        // ListView.builder(
                        //   itemCount: 10,
                        //   shrinkWrap: true,
                        //   itemBuilder: (BuildContext context, int index) {
                        //     return const ListViewItemBody(
                        //       userName: '',
                        //       taskCategory: '',
                        //       startTime: '',
                        //       title: '',
                        //     );
                        //   },
                        // ),
                        ListView.builder(
                          itemCount: 2,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return const ListViewItemBody(
                              userName: '',
                              taskCategory: '',
                              startTime: '',
                              title: '',
                            );
                          },
                        ),
                        ListView.builder(
                          itemCount: 3,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return const ListViewItemBody(
                              userName: '',
                              taskCategory: '',
                              startTime: '',
                              title: '',
                            );
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

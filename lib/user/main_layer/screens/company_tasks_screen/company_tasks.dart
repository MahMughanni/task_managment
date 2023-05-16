import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_mangment/user/main_layer/screens/home_screen/controller/task_cubit.dart';
import 'package:task_mangment/user/main_layer/screens/home_screen/controller/task_state.dart';
import 'package:task_mangment/user/main_layer/screens/home_screen/widgets/custom_task_list.dart';
import 'package:task_mangment/shared_widgets/custom_appbar.dart';

class CompanyTasksScreen extends StatelessWidget {
  CompanyTasksScreen({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: true,
      create: (context) => TaskCubit(userId: user.uid),
      child: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: CustomAppbar(
                height: 120.h,
                title: 'Company Tasks',
                action: const [],
                bottom: TabBar(
                    padding: const EdgeInsets.all(8).r,
                    labelColor: Colors.white,
                    labelStyle: const TextStyle(color: Colors.white),
                    indicatorSize: TabBarIndicatorSize.tab,
                    unselectedLabelColor: Colors.black,
                    splashBorderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                    splashFactory: InkRipple.splashFactory,
                    indicator: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        color: Colors.blueAccent.withOpacity(.9)),
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
              body: TabBarView(
                children: [
                  CustomTaskList(
                    state: 'today',
                    label: '',
                    userName: '',
                    userId: user.uid,
                    userCubit: BlocProvider.of<TaskCubit>(context),
                  ),
                  CustomTaskList(
                    state: 'upcoming',
                    label: '',
                    userName: '',
                    userCubit: BlocProvider.of<TaskCubit>(context),
                    userId: user.uid,
                  ),
                  CustomTaskList(
                    state: 'completed',
                    userId: user.uid,
                    label: '',
                    userCubit: BlocProvider.of<TaskCubit>(context),
                    userName: '',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

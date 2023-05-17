import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_mangment/shared_widgets/custom_tabBar.dart';
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
                bottom: const CustomTabBar(),
              ),
              body: TabBarView(
                children: [
                  CustomTaskList(
                    state: 'today',
                    label: 'today',
                    userName: '',
                    userId: user.uid,
                    userCubit: BlocProvider.of<TaskCubit>(context),
                    taskType: 'today',
                  ),
                  CustomTaskList(
                    state: 'upcoming',
                    label: '',
                    userName: '',
                    userCubit: BlocProvider.of<TaskCubit>(context),
                    userId: user.uid,
                    taskType: 'upcoming',
                  ),
                  CustomTaskList(
                    state: 'completed',
                    userId: user.uid,
                    label: '',
                    userCubit: BlocProvider.of<TaskCubit>(context),
                    userName: '',
                    taskType: 'completed',
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

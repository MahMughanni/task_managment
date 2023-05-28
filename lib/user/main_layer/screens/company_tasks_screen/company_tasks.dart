import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/admin/controller/admin_cubit.dart';
import 'package:task_management/shared_widgets/custom_tabBar.dart';
import 'package:task_management/user/auth_layer/controller/authentication_cubit.dart';
import 'package:task_management/user/main_layer/screens/home_screen/widgets/custom_task_list.dart';
import 'package:task_management/shared_widgets/custom_appbar.dart';

class CompanyTasksScreen extends StatelessWidget {
  const CompanyTasksScreen({Key? key, required this.userRole})
      : super(key: key);
  final String userRole;

  @override
  Widget build(BuildContext context) {
    final user = BlocProvider.of<AuthenticationCubit>(context).firebaseAuth.currentUser!;

    final adminCubit = BlocProvider.of<AdminCubit>(context);

    adminCubit.fetchAllTasks();

    return Scaffold(
      body: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
          if (state is LoginSuccess) {
            if (userRole == 'user') {
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
                        userName: user.displayName,
                        userId: user.uid,
                        adminCubit: BlocProvider.of<AdminCubit>(context),
                        taskType: 'today',
                      ),
                      CustomTaskList(
                        state: 'upcoming',
                        label: 'upcoming',
                        userName: user.displayName,
                        adminCubit: BlocProvider.of<AdminCubit>(context),
                        userId: user.uid,
                        taskType: 'upcoming',
                      ),
                      CustomTaskList(
                        state: 'completed',
                        userId: user.uid,
                        label: 'completed',
                        adminCubit: BlocProvider.of<AdminCubit>(context),
                        userName: user.displayName,
                        taskType: 'completed',
                      ),
                    ],
                  ),
                ),
              );
            } else if (userRole == 'admin') {
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
                        userName: user.displayName,
                        userId: user.uid,
                        adminCubit: BlocProvider.of<AdminCubit>(context),
                        taskType: 'today',
                      ),
                      CustomTaskList(
                        state: 'upcoming',
                        label: '',
                        userName: ' ajsdsajdj',
                        adminCubit: BlocProvider.of<AdminCubit>(context),
                        userId: user.uid,
                        taskType: 'upcoming',
                      ),
                      CustomTaskList(
                        state: 'completed',
                        userId: user.uid,
                        label: '',
                        adminCubit: BlocProvider.of<AdminCubit>(context),
                        userName: 'asdjhash',
                        taskType: 'completed',
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // Handle unknown role
              return const Center(
                child: Text('Unknown User Role'),
              );
            }
          } else {
            // Handle login state
            return Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: Text("Something Went Wrong"),
              ),
            );
          }
        },
      ),
    );
  }
}

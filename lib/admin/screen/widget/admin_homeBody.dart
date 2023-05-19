import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:task_mangment/admin/controller/admin_cubit.dart';
import 'package:task_mangment/core/routes/app_router.dart';
import 'package:task_mangment/core/routes/named_router.dart';
import 'package:task_mangment/shared_widgets/cutom_container.dart';
import 'package:task_mangment/user/main_layer/screens/home_screen/widgets/custom_sliver_appbar.dart';
import 'package:task_mangment/user/main_layer/screens/home_screen/widgets/custom_task_list.dart';
import 'package:task_mangment/utils/app_constants.dart';

class AdminHomeScreenBody extends HookWidget {
  const AdminHomeScreenBody({
    Key? key,
    required this.userId,
    required this.userRole,
  }) : super(key: key);

  final String userId, userRole;

  @override
  Widget build(BuildContext context) {
    final adminCubit = BlocProvider.of<AdminCubit>(context);

    // Fetch tasks when the widget is built
    useEffect(() {
      adminCubit.fetchAllTasks();
      return () {
        // Cleanup function if needed
      };
    }, []);

    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        if (state is AdminInitial || state is AdminLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AdminTasksLoadedState) {
          final userTasks = state.tasks;
          final upcomingTasksCount =
              userTasks.where((task) => task.state == 'upcoming').length;
          final completedTasksCount =
              userTasks.where((task) => task.state == 'completed').length;

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                BuildSliverAppBar(
                  userName: '',
                  taskNumber: userTasks.length.toString(),
                  itemCount: 2,
                  itemBuilder: (BuildContext context, int index) {
                    switch (index) {
                      case 0:
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: CustomContainer(
                            color: const Color(0xffF9B5D0),
                            title: 'Assigned',
                            taskNumber: upcomingTasksCount.toString(),
                            height: ScreenUtil().setHeight(90),
                            width: ScreenUtil().setWidth(150),
                            onTap: () {
                              AppRouter.goTo(
                                  screenName:
                                      NamedRouter.adminDetailsStatusTasks,
                                  arguments: 'upcoming');
                            },
                          ),
                        );
                      case 1:
                        return CustomContainer(
                          color: const Color(0xff6EB3E7),
                          title: 'Completed',
                          taskNumber: completedTasksCount.toString(),
                          height: ScreenUtil().setHeight(90),
                          width: ScreenUtil().setWidth(150),
                          onTap: () {
                            AppRouter.goTo(
                                screenName: NamedRouter.adminDetailsStatusTasks,
                                arguments: 'completed');
                          },
                        );
                      default:
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child:
                              const CustomContainer(title: '', taskNumber: ''),
                        );
                    }
                  },
                  imageUrl: '',
                  userId: userId,
                  userRole: userRole,
                )
              ];
            },
            body: TabBarView(
              children: [
                CustomTaskList(
                  userName: '',
                  state: 'today',
                  label: 'today',
                  userId: userId,
                  adminCubit: adminCubit,
                  taskType: 'today',
                ),
                CustomTaskList(
                  userName: 'Admin',
                  state: 'upcoming',
                  label: 'Upcoming',
                  userId: userId,
                  adminCubit: adminCubit,
                  taskType: 'upcoming',
                ),
                CustomTaskList(
                  userName: 'Admin',
                  state: 'completed',
                  label: 'Completed',
                  userId: userId,
                  adminCubit: adminCubit,
                  taskType: 'completed',
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: Lottie.asset(
              ImageConstManger.noInternet,
              width: 200.w,
              height: 200.h,
            ),
          );
        }
      },
    );
  }
}

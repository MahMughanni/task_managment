import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/shared_widgets/custom_shimmer.dart';
import 'package:task_management/user/auth_layer/controller/authentication_cubit.dart';
import 'package:task_management/user/main_layer/screens/home_screen/controller/task_cubit.dart';
import 'package:task_management/user/main_layer/screens/home_screen/controller/task_state.dart';
import 'package:task_management/user/main_layer/screens/home_screen/widgets/custom_task_list.dart';
import 'package:task_management/shared_widgets/custom_appbar.dart';

class AssignedScreen extends StatelessWidget {
  const AssignedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user =
        BlocProvider.of<AuthenticationCubit>(context).firebaseAuth.currentUser!;
    return BlocProvider<TaskCubit>(
      create: (context) => TaskCubit(userId: user.uid),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Assigned Tasks',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            if (state is UserLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is Failure) {
              return const ShimmerListViewItemBody();
            } else if (state is UserLoadedState) {
              return CustomTaskList(
                userName: user.displayName,
                state: 'upcoming',
                label: 'Upcoming',
                userId: user.uid,
                userCubit: BlocProvider.of<TaskCubit>(context),
                taskType: 'upcoming',
                role: '',
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

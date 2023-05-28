import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/admin/controller/admin_cubit.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppbar(
        title: 'Assigned Tasks',
        action: [],
      ),
      body: BlocBuilder<AdminCubit, AdminState>(
        builder: (context, state) {
          if (state is AdminLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminFailure) {
            return const Center(
              child: Text('Something Went Wrong'),
            );
          } else if (state is AdminTasksLoadedState) {
            var user = state.user;
            return CustomTaskList(
              userName: user?.userName ?? '',
              state: 'upcoming',
              label: 'Upcoming',
              userId: user?.uId ?? '',
              adminCubit: BlocProvider.of<AdminCubit>(context),
              taskType: 'upcoming',
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

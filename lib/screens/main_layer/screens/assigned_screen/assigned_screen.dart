import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_mangment/screens/auth_layer/controller/authentication_cubit.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/controller/user_cubit.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/controller/user_state.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/widgets/custom_task_list.dart';
import 'package:task_mangment/shared_widgets/custom_appbar.dart';

class AssignedScreen extends StatelessWidget {
  const AssignedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = BlocProvider.of<AuthenticationCubit>(context)
        .firebaseAuth
        ?.currentUser!;
    return BlocProvider<UserCubit>(
      create: (context) => UserCubit(userId: user!.uid.toString()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppbar(
          title: 'Assigned Tasks',
          action: [],
        ),
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserErrorState) {
              return const Center(
                child: Text('Something Went Wrong'),
              );
            } else if (state is UserLoadedState) {
              return CustomTaskList(
                state: 'upcoming',
                label: 'upcoming',
                userName: state.user.userName.toString(),
                userId: user!.uid,
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

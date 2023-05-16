import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:task_mangment/user/main_layer/screens/home_screen/controller/task_cubit.dart';
import 'package:task_mangment/user/main_layer/screens/home_screen/controller/task_state.dart';
import 'package:task_mangment/user/main_layer/screens/home_screen/widgets/homeScreen_body.dart';
import 'package:task_mangment/utils/app_constants.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final List taskTitles = [
    'Tasks',
    'Assigned',
    'Completed',
  ];
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    debugPrint('Build $userId');
    return BlocProvider(
      create: (context) => TaskCubit(userId: userId!),
      child: SafeArea(
        child: Scaffold(
          body: BlocConsumer<TaskCubit, TaskState>(
            listener: (context, state) {
              if (state is UserErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is UserInitial) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is UserLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is UserLoadedState) {
                return DefaultTabController(
                  length: taskTitles.length,
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    body: HomeScreenBody(
                      userId: userId!,
                    ),
                  ),
                );
              } else if (state is UserConnectedState) {
                return const Center(
                  child: CircularProgressIndicator(),
                ); // Show a loading indicator when the connection state is changing
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
          ),
        ),
      ),
    );
  }
}

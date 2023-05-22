import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/user/main_layer/screens/home_screen/controller/task_cubit.dart';
import 'package:task_management/user/main_layer/screens/home_screen/widgets/homeScreen_body.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key, required this.userRole}) : super(key: key);
  final String userRole;

  final List taskTitles = [
    'Tasks',
    'Assigned',
    'Completed',
  ];
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    debugPrint('Build $userId');
    return BlocProvider(
      create: (context) => TaskCubit(userId: userId!),
      child: SafeArea(
        child: Scaffold(
          body: DefaultTabController(
            length: taskTitles.length,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: HomeScreenBody(
                userId: userId!,
                userRole: userRole,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

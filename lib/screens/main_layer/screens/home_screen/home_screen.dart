import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/controller/user_cubit.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/controller/user_state.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/widgets/homeScreen_body.dart';

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
    // debugPrint(userId ?? '');

    return BlocProvider(
      create: (context) => UserCubit(userId: userId!),
      child: SafeArea(
        child: Scaffold(
          body: BlocConsumer<UserCubit, UserState>(
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
                return const Center(
                  child: Text('No InterNet Connection '),
                ); // A placeholder when the state is unknown
              }
            },
          ),
        ),
      ),
    );
  }
}

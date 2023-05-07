import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/controller/user_cubit.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/widgets/homeScreen_body.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;
  final List taskTitles = [
    'Tasks',
    'Assigned',
    'Completed',
  ];

  @override
  Widget build(BuildContext context) {
    debugPrint('Build');
    String userId = user.uid;
    return BlocProvider(
      create: (context) => UserCubit(userId),
      child: DefaultTabController(
        length: 3,
        child: SafeArea(
          bottom: true,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: HomeScreenBody(
              userId: userId,
            ),
          ),
        ),
      ),
    );
  }
}

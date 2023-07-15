import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_management/admin/screen/widget/admin_homeBody.dart';

class AdminHomeScreen extends StatelessWidget {
  AdminHomeScreen({Key? key, required this.userRole}) : super(key: key);
  final String userRole;

  final List taskTitles = [
    'Tasks',
    'Assigned',
    'Completed',
  ];

  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: taskTitles.length,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: AdminHomeScreenBody(
              userId: userId ?? '',
              userRole: userRole,
            ),
          ),
        ),
      ),
    );
  }
}

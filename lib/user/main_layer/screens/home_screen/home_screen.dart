import 'package:flutter/material.dart';
import 'package:task_management/user/main_layer/screens/home_screen/widgets/homeScreen_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key, required this.userRole}) : super(key: key);
  final String userRole;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: HomeScreenBody(
              userRole: userRole,
              // userName: user?.displayName ?? '',
            ),
          ),
        ),
      ),
    );
  }
}

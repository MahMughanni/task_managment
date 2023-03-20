import 'package:flutter/material.dart';
import 'package:task_mangment/screens/auth_layer/login_screen.dart';
import 'package:task_mangment/screens/main_layer/main_screen.dart';
import 'package:task_mangment/utils/app_theme/app_theme_light.dart';

void main() {
  runApp(const TaskMangeMentApp());
}

class TaskMangeMentApp extends StatelessWidget {
  const TaskMangeMentApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getAppTheme(),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

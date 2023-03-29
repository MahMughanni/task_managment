import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_mangment/screens/main_layer/main_screen.dart';
import 'package:task_mangment/utils/app_theme/app_theme_light.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(const TaskManageMentApp()),
  );
}

class TaskManageMentApp extends StatelessWidget {
  const TaskManageMentApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

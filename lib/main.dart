import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_mangment/core/routes/app_router.dart';
import 'package:task_mangment/core/routes/generate_routes.dart';
import 'package:task_mangment/core/routes/named_router.dart';

import 'package:responsive_framework/responsive_framework.dart';
import 'package:task_mangment/logic/firebase_controller.dart';
import 'package:task_mangment/utils/utils_config.dart';

import 'model/task_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var userId = FirebaseAuth.instance.currentUser!.uid;
  getUserTasksByDateToCalender(userId: userId);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(const TaskManageMentApp()),
  );
}

class TaskManageMentApp extends StatelessWidget {
  const TaskManageMentApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: OnGenerateRouter.onGenerateRoute,
      navigatorKey: AppRouter.navigatorKey,
      initialRoute: NamedRouter.splashScreen,
      theme: ThemeData(fontFamily: 'Cairo'),
      scaffoldMessengerKey: UtilsConfig.scaffoldKey,
      builder: (context, child) => ResponsiveWrapper.builder(
        child,
        maxWidth: 1200,
        minWidth: 480,
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(480, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
        ],
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

Stream<List<TaskModel>> getUserTasksByDateToCalender({required String userId}) {
  final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
  final tasksCollection = userDoc.collection('tasks');
  var data = tasksCollection
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((querySnapshot) {
    final tasks =
        querySnapshot.docs.map((doc) => TaskModel.fromSnapshot(doc)).toList();
    print("Length : ${tasks.length}");
    return tasks;
  });
  return data;
}

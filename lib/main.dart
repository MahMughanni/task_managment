import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_mangment/core/routes/app_router.dart';
import 'package:task_mangment/core/routes/generate_routes.dart';
import 'package:task_mangment/core/routes/named_router.dart';

import 'package:responsive_framework/responsive_framework.dart';
import 'package:task_mangment/model/user_model.dart';
import 'package:task_mangment/utils/UtilsConfig.dart';

import 'logic/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // final data =  AuthFireBase.getUserTasks(userId: 'i8I9c76QJxOUU6hjIiJ0ND23kIi2');
  // print("data :${data}");
  // addTask('Buy mahmoud', 'Milk, eggs, bread, and cheese');

  // FirebaseAuth.instance.signOut();
  // AuthFireBase.createUserAccount('mahm@asd.com', '123456mA@', 'mahmoud', '0597289998');
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

// Future<void> addTask(String title, String description) async {
//   final userId = FirebaseAuth.instance.currentUser!.uid;
//   final tasksRef = FirebaseFirestore.instance.collection('tasks');
//   final newTaskRef =
//       tasksRef.doc(); // creates a new DocumentReference with a unique ID
//
//   try {
//     await newTaskRef.set({
//       'userId': userId,
//       'title': title,
//       'description': description,
//       'createdDate': DateTime.now(),
//       'completed': false,
//     });
//
//     print('Task added successfully!');
//   } catch (e) {
//     print('Error adding task: $e');
//   }
// }

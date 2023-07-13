import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/admin/controller/admin_cubit.dart';
import 'package:task_management/admin/screen/add_project/controller/project_cubit.dart';
import 'package:task_management/core/logic/base_cubit.dart';
import 'package:task_management/core/routes/app_router.dart';
import 'package:task_management/core/routes/generate_routes.dart';
import 'package:task_management/core/routes/named_router.dart';
import 'package:task_management/user/auth_layer/controller/authentication_cubit.dart';
import 'package:task_management/user/main_layer/screens/add_task_screen/controller/add_task_cubit.dart';
import 'package:task_management/user/main_layer/screens/home_screen/controller/task_cubit.dart';
import 'package:task_management/utils/app_theme/app_theme_light.dart';
import 'package:task_management/utils/utils_config.dart';

import 'user/main_layer/screens/notification_screen/controller/NotificationService.dart';
import 'user/main_layer/screens/notification_screen/controller/notification_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final userAUTH = FirebaseAuth.instance;
  final user = userAUTH.currentUser;

  NotificationsService notificationsService = NotificationsService();
  notificationsService.init();
  notificationsService.initAwesome();

  // Get the current connectivity status
  final ConnectivityResult connectivityResult =
      await Connectivity().checkConnectivity();

  // Set the preferred orientation to portrait
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Run the app
  runApp(TaskManagementApp(
    userAUTH: userAUTH,
    user: user,
    connectivityResult: connectivityResult,
  ));
}

class TaskManagementApp extends StatelessWidget {
  const TaskManagementApp(
      {Key? key,
      required this.userAUTH,
      this.user,
      required this.connectivityResult})
      : super(key: key);
  final FirebaseAuth userAUTH;
  final User? user;
  final ConnectivityResult connectivityResult;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<NotificationCubit>(
              create: (context) => NotificationCubit(),
            ),
            BlocProvider<BaseCubit>(
              lazy: false,
              create: (BuildContext context) {
                return BaseCubit();
              },
            ),
            BlocProvider<ProjectCubit>(
              create: (BuildContext context) {
                return ProjectCubit();
              },
            ),
            BlocProvider<AuthenticationCubit>(
              create: (BuildContext context) =>
                  AuthenticationCubit(firebaseAuth: userAUTH),
            ),
            BlocProvider<AddTaskCubit>(
              create: (BuildContext context) => AddTaskCubit(),
            ),
            BlocProvider<AdminCubit>(
              create: (BuildContext context) => AdminCubit(),
            ),
            BlocProvider<TaskCubit>(
              create: (BuildContext context) =>
                  TaskCubit(userId: userAUTH.currentUser?.uid ?? ''),
            ),
          ],
          child: MaterialApp(
            onGenerateRoute: OnGenerateRouter.onGenerateRoute,
            navigatorKey: AppRouter.navigatorKey,
            initialRoute: NamedRouter.splashScreen,
            scaffoldMessengerKey: UtilsConfig.scaffoldKey,
            theme: getAppTheme(),
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}

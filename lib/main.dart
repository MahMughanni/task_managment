import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_mangment/admin/controller/admin_cubit.dart';
import 'package:task_mangment/core/routes/app_router.dart';
import 'package:task_mangment/core/routes/generate_routes.dart';
import 'package:task_mangment/core/routes/named_router.dart';
import 'package:task_mangment/logic/base_cubit.dart';
import 'package:task_mangment/user/auth_layer/controller/authentication_cubit.dart';
import 'package:task_mangment/user/main_layer/screens/home_screen/controller/task_cubit.dart';
import 'package:task_mangment/utils/app_theme/app_theme_light.dart';
import 'package:task_mangment/utils/utils_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final userAUTH = FirebaseAuth.instance;
  final user = userAUTH.currentUser;

  final ConnectivityResult connectivityResult =
      await Connectivity().checkConnectivity();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(TaskManagementApp(
      userAUTH: userAUTH,
      user: user,
      connectivityResult: connectivityResult,
    )),
  );
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
            BlocProvider<BaseCubit>(
                lazy: false,
                create: (BuildContext context) {
                  return BaseCubit();
                }),
            BlocProvider<AuthenticationCubit>(
              create: (BuildContext context) =>
                  AuthenticationCubit(firebaseAuth: userAUTH),
            ),
            BlocProvider<AdminCubit>(
                create: (BuildContext context) => AdminCubit()),
            BlocProvider<TaskCubit>(
              create: (BuildContext context) =>
                  TaskCubit(userId: userAUTH.currentUser?.uid ?? ''),
            ),
          ],
          child: MaterialApp(
            onGenerateRoute: OnGenerateRouter.onGenerateRoute,
            navigatorKey: AppRouter.navigatorKey,
            initialRoute: NamedRouter.splashScreen,
            theme: getAppTheme(),
            scaffoldMessengerKey: UtilsConfig.scaffoldKey,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}

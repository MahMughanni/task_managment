import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_mangment/core/routes/app_router.dart';
import 'package:task_mangment/core/routes/generate_routes.dart';
import 'package:task_mangment/core/routes/named_router.dart';
import 'package:task_mangment/logic/base_cubit.dart';
import 'package:task_mangment/screens/auth_layer/controller/authentication_cubit.dart';
import 'package:task_mangment/screens/main_layer/screens/add_task_screen/controller/add_task_cubit.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/controller/user_cubit.dart';
import 'package:task_mangment/utils/app_theme/app_theme_light.dart';
import 'package:task_mangment/utils/utils_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final userAUTH = FirebaseAuth.instance;
  final user = userAUTH.currentUser;

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(TaskManageMentApp(
      userAUTH: userAUTH,
      user: user,
    )),
  );
}

class TaskManageMentApp extends StatelessWidget {
  const TaskManageMentApp({Key? key, required this.userAUTH, this.user})
      : super(key: key);
  final FirebaseAuth userAUTH;
  final User? user;

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
              create: (BuildContext context) => BaseCubit(),
            ),
            BlocProvider<AuthenticationCubit>(
              create: (BuildContext context) => AuthenticationCubit(userAUTH),
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

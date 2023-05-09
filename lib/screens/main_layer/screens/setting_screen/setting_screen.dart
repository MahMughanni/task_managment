import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_mangment/core/routes/app_router.dart';
import 'package:task_mangment/core/routes/named_router.dart';
import 'package:task_mangment/screens/auth_layer/controller/authentication_cubit.dart';
import 'package:task_mangment/utils/app_constants.dart';
import 'package:task_mangment/utils/utils_config.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);

  final titleList = [
    'My Profile',
    'All Employee',
    'About app',
    'Language',
    'Log out',
  ];

  final imageList = [
    ImageConstManger.profileImage,
    ImageConstManger.emailImage,
    ImageConstManger.aboutUsImage,
    ImageConstManger.langImage,
    ImageConstManger.logoutImage,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              floating: true,
              snap: true,
              pinned: true,
              title: Text(
                'Setting',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: AppConstFontWeight.regular,
                  fontSize: 25.sp,
                ),
              ),
              titleSpacing: 24,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Colors.white,
                  width: 100.w,
                  height: 100.h,
                  child: Image.asset(
                    ImageConstManger.logoImage,
                  ),
                ),
              ),
              expandedHeight: 150.h,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8)
                          .r,
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xffF8FCFF),
                        borderRadius: BorderRadius.circular(14)),
                    child: ListTile(
                      onTap: () async {
                        switch (index) {
                          case 0:
                            AppRouter.goTo(
                                screenName: NamedRouter.profileScreen);
                            break;
                          case 1:
                            AppRouter.goTo(
                                screenName: NamedRouter.employeeScreen);

                            break;
                          case 2:
                            UtilsConfig.showSnackBarMessage(
                                message: index.toString(), status: true);
                            break;
                          case 3:
                            UtilsConfig.showSnackBarMessage(
                                message: index.toString(), status: true);
                            break;
                          case 4:
                            final authenticationCubit =
                                context.read<AuthenticationCubit>();
                            await authenticationCubit.logOut();
                            AppRouter.goToAndRemove(
                                routeName: NamedRouter.loginScreen);
                            break;

                          default:
                            UtilsConfig.showSnackBarMessage(
                                message: 'Something WWrong', status: true);
                        }
                      },
                      contentPadding: const EdgeInsets.all(20).r,
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          fit: BoxFit.cover,
                          imageList[index],
                        ),
                      ), //C
                      title: Text(titleList[index]), // enter
                    ),
                  ),
                ), //ListTile
                childCount: titleList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_management/core/routes/app_router.dart';
import 'package:task_management/core/routes/named_router.dart';
import 'package:task_management/user/auth_layer/controller/authentication_cubit.dart';
import 'package:task_management/utils/app_constants.dart';
import 'package:task_management/utils/utils_config.dart';

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
    SvgIconsConstManger.profileImage,
    SvgIconsConstManger.employeeImage,
    SvgIconsConstManger.aboutUsImage,
    SvgIconsConstManger.langImage,
    SvgIconsConstManger.logoutImage,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                centerTitle: false,
                backgroundColor: Colors.white,
                floating: false,
                snap: false,
                pinned: true,
                title: Padding(
                  padding: const EdgeInsets.all(8.0).r,
                  child: Text(
                    'Setting',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                titleSpacing: 4,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.all(16.0).r,
                    child: Image.asset(
                      ImageConstManger.logoImage,
                      width: 50.r,
                      height: 50.r,
                    ),
                  ),
                ),
                expandedHeight: 150.h,
              ),
            ];
          },
          body: ListView.builder(
            itemCount: titleList.length,
            itemBuilder: (context, index) => Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16).r,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffF8FCFF),
                  borderRadius: BorderRadius.circular(14).r,
                ),
                child: ListTile(
                  minVerticalPadding: 0,
                  onTap: () async {
                    switch (index) {
                      case 0:
                        AppRouter.goTo(screenName: NamedRouter.profileScreen);
                        break;
                      case 1:
                        AppRouter.goTo(screenName: NamedRouter.employeeScreen);
                        break;
                      case 2:
                        break;
                      case 3:
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
                            message: 'Something Wrong', status: true);
                    }
                  },
                  contentPadding: const EdgeInsets.all(15).r,
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: SvgPicture.asset(
                      fit: BoxFit.cover,
                      imageList[index],
                    ),
                  ),
                  title: Text(
                    titleList[index],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

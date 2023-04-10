import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_mangment/core/routes/app_router.dart';
import 'package:task_mangment/shared_widgets/custom_appbar.dart';
import 'package:task_mangment/utils/app_constants.dart';
import 'package:task_mangment/utils/extentions/padding_extention.dart';
import 'package:task_mangment/utils/utils_config.dart';

import '../../../../core/routes/named_router.dart';

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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            floating: true,
            snap: true,
            pinned: true,
            title: const Text(
              'Setting',
              style: TextStyle(
                color: Colors.black,
                fontWeight: AppConstFontWeight.normal,
                fontSize: 25,
              ),
            ),
            titleSpacing: 24,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.white,
                width: 100,
                height: 100,
                child: Image.asset(
                  ImageConstManger.logoImage,
                ),
              ),
            ),
            expandedHeight: 250,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xffF8FCFF),
                      borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    onTap: () {
                      switch (index) {
                        case 0:
                          AppRouter.goTo(screenName: NamedRouter.profileScreen);
                          break;
                        case 1:
                          AppRouter.goTo(screenName: NamedRouter.employee);

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
                          FirebaseAuth.instance.signOut();
                          AppRouter.goToAndRemove(
                              screenName: NamedRouter.loginScreen);
                          break;

                        default:
                          UtilsConfig.showSnackBarMessage(
                              message: 'Something WWrong', status: true);
                      }
                    },
                    contentPadding: const EdgeInsets.all(20),
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
              childCount: 5,
            ),
          ),
        ],
      ),
    );
  }
}

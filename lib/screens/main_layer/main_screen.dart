import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:task_mangment/screens/main_layer/screens/add_task_screen/addtask_screen.dart';
import 'package:task_mangment/screens/main_layer/screens/assigned_screen/assigned_screen.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/home_screen.dart';
import 'package:task_mangment/screens/main_layer/screens/notification_screen/notification_screen.dart';
import 'package:task_mangment/screens/main_layer/screens/setting_screen/setting_screen.dart';
import 'package:task_mangment/utils/app_constants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      AssignedScreen(),
      const AddTaskScreen(),
      const NotificationScreen(),
      SettingScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.doc_checkmark),
        title: ("Assigned"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.add, size: 30),
        title: ("Add Task"),
        activeColorPrimary: ColorConstManger.primaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.notifications_none_sharp),
        title: ("Notification"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.settings_solid),
        title: ("Setting"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(2.0).r,
            colorBehindNavBar: Colors.white,
            adjustScreenBottomPaddingOnCurve: false
          // boxShadow: [
          //   const BoxShadow(
          //     offset: Offset(0, -2),
          //     spreadRadius: 1,
          //     blurRadius: 10,
          //     blurStyle: BlurStyle.outer,
          //     color: Colors.black12,
          //   )
          // ],
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          duration: Duration(milliseconds: 250),
          curve: Curves.linear,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.linear,
          duration: Duration(milliseconds: 250),
        ),
        navBarStyle: NavBarStyle.style9)  ;
  }
}

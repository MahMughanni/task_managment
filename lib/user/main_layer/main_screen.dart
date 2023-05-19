import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_mangment/admin/screen/admin_add_task_screen.dart';
import 'package:task_mangment/admin/screen/admin_home_screen.dart';
import 'package:task_mangment/user/main_layer/screens/add_task_screen/addtask_screen.dart';
import 'package:task_mangment/user/main_layer/screens/assigned_screen/assigned_screen.dart';
import 'package:task_mangment/user/main_layer/screens/home_screen/home_screen.dart';
import 'package:task_mangment/user/main_layer/screens/notification_screen/notification_screen.dart';
import 'package:task_mangment/user/main_layer/screens/setting_screen/setting_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, this.userRole}) : super(key: key);
  final String? userRole;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> screens;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    print(widget.userRole);
    screens = [
      (widget.userRole == 'admin')
          ? AdminHomeScreen(
              userRole: 'admin',
            )
          : HomeScreen(userRole: widget.userRole ?? 'user'),
      (widget.userRole == 'admin') ? Container() : const AssignedScreen(),
      (widget.userRole == 'admin') ? const AdminAddTaskScreen() : const AddTaskScreen(),
      const NotificationScreen(),
      SettingScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blueAccent,
        currentIndex: currentIndex,
        onTap: onTapNavBottom,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.home,
              size: 20.0.r,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.doc_checkmark,
              size: 20.0.r,
            ),
            label: (widget.userRole == 'admin') ? 'projects' : 'Assigned',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_bag,
              color: Colors.transparent,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications_none_sharp,
              size: 20.0.r,
            ),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.settings_solid,
              size: 20.0.r,
            ),
            label: 'Setting',
          ),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: CustomFloatingBtn(
        onBtnPressed: () => setState(() {
          currentIndex = 2;
        }),
        color: (currentIndex == 2) ? Colors.blueAccent : Colors.grey,
      ),
    );
  }

  void onTapNavBottom(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}

class CustomFloatingBtn extends StatelessWidget {
  const CustomFloatingBtn(
      {Key? key, required this.onBtnPressed, required this.color})
      : super(key: key);

  final Function() onBtnPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).r,
      child: Container(
        width: 52.r,
        height: 52.r,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: FloatingActionButton(
          shape: const CircleBorder(),
          elevation: 7,
          backgroundColor: color,
          onPressed: onBtnPressed,
          child: Theme(
            data: ThemeData(
              iconTheme: IconThemeData(
                color: Colors.white,
                size: 30.r,
              ),
            ),
            child: const Icon(
              CupertinoIcons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

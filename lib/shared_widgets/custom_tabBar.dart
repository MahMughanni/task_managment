import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTabBar extends StatelessWidget with PreferredSizeWidget {
  const CustomTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
        labelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: TextStyle(fontSize: 14.sp, color: Colors.white),
        unselectedLabelColor: Colors.black,
        splashBorderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        splashFactory: InkRipple.splashFactory,
        indicator: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
            color: Colors.blueAccent.withOpacity(.8),
            boxShadow: [
              BoxShadow(spreadRadius: 1, blurRadius: 10.r, color: Colors.black12)
            ]),
        tabs: const [
          Tab(
            text: 'Today',
          ),
          Tab(
            text: 'Upcoming',
          ),
          Tab(
            text: 'Completed',
          ),
        ]);
  }

  @override
  Size get preferredSize => Size.fromHeight(90.h);
}

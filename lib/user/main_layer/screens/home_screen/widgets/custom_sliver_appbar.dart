import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_tab_bar.dart';

class BuildSliverAppBar extends StatelessWidget {
  const BuildSliverAppBar({
    Key? key,
    required this.userName,
    required this.taskNumber,
    required this.itemCount,
    required this.itemBuilder,
    required this.imageUrl,
    required this.userId,
    required this.userRole,
  }) : super(key: key);

  final String userName, taskNumber, imageUrl, userId, userRole;

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: CustomSliverAppBar(
        userName: userName,
        taskNumber: taskNumber,
        itemBuilder: itemBuilder,
        itemCount: itemCount,
        imageUrl: imageUrl,
        userId: userId,
        userRole: userRole,
      ),
    );
  }
}

class CustomSliverAppBar extends SliverPersistentHeaderDelegate {
  final String userName, taskNumber, imageUrl, userId, userRole;
  final Widget? Function(BuildContext, int) itemBuilder;
  final int itemCount;

  CustomSliverAppBar({
    required this.imageUrl,
    required this.itemBuilder,
    required this.itemCount,
    required this.userId,
    required this.userName,
    required this.taskNumber,
    required this.userRole,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return CustomTabBarViewTabs(
      userName: userName,
      taskNumber: taskNumber,
      itemBuilder: itemBuilder,
      itemCount: itemCount,
      imageUrl: imageUrl,
      userId: userId,
      userRole: userRole,
    );
  }

  @override
  double get maxExtent => ScreenUtil().screenHeight * 0.30 + kToolbarHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

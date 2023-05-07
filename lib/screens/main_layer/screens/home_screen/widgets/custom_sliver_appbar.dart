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
  }) : super(key: key);

  final String userName, taskNumber, imageUrl, userId;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SliverPersistentHeader(
      delegate: CustomSliverAppBar(
        expandedHeight: screenSize.height * .26.h,
        userName: userName,
        taskNumber: taskNumber,
        itemBuilder: itemBuilder,
        itemCount: itemCount,
        imageUrl: imageUrl,
        userId: userId,
      ),
    );
  }
}

class CustomSliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  CustomSliverAppBar({
    required this.imageUrl,
    required this.itemBuilder,
    required this.itemCount,
    required this.userId,
    required this.expandedHeight,
    required this.userName,
    required this.taskNumber,
  });

  final String userName, taskNumber, imageUrl, userId;
  final Widget? Function(BuildContext, int) itemBuilder;
  final int itemCount;

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
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

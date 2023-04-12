import 'package:flutter/material.dart';

import 'custom_tab_bar.dart';

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

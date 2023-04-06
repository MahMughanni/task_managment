import 'package:flutter/material.dart';

import 'custom_tabBar.dart';

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  MySliverAppBar({
    required this.imageUrl,
    required this.itemBuilder,
    required this.itemCount,
    required this.expandedHeight,
    required this.userName,
    required this.taskNumber,
  });

  final String userName, taskNumber, imageUrl;
  final Widget? Function(BuildContext, int) itemBuilder;
  final int itemCount;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return TabBarViewTabs(
      userName: userName,
      taskNumber: taskNumber,
      itemBuilder: itemBuilder,
      itemCount: itemCount,
      imageUrl: imageUrl,
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

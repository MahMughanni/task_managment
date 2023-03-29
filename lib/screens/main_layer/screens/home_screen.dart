import 'package:flutter/material.dart';
import 'package:task_mangment/utils/extentions/padding_extention.dart';

import '../../../shared_widgets/cutom_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            bottom: const TabBarViewTabs(),
          ),
          backgroundColor: Colors.black12,
          body: const TabBarView(
            children: [
              Text('1'),
              Text('2'),
              Text('3'),
            ],
          )),
    );
  }
}

class TabBarViewTabs extends StatelessWidget with PreferredSizeWidget {
  const TabBarViewTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomContainer(),
                CustomContainer(),
                CustomContainer(),

              ],
            ),
          ),
          16.ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Company tasks'),
              Text('See More'),
            ],
          ),
          16.ph,
          TabBar(
              splashBorderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
              splashFactory: InkRipple.splashFactory,
              indicator: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                  color: Colors.white.withOpacity(.2)),
              tabs: const [
                Tab(
                  text: 'Today',
                ),
                Tab(
                  text: 'Upcoming',
                ),
                Tab(
                  text: 'Complite',
                ),
              ])
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(200);
}

import 'package:flutter/material.dart';
import 'package:task_mangment/utils/app_constants.dart';
import 'package:task_mangment/utils/extentions/padding_extention.dart';

import '../../../../../shared_widgets/cutom_container.dart';

class TabBarViewTabs extends StatelessWidget with PreferredSizeWidget {
  const TabBarViewTabs({Key? key, required this.userName}) : super(key: key);

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      child: Image.asset(ImageConstManger.logoImage),
                    ),
                    8.pw,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RichText(
                            text: TextSpan(
                                style: const TextStyle(color: Colors.black , fontSize: 16),
                                text: 'Hi ,',
                                children: [
                                  TextSpan(text: userName ,style: Theme.of(context).textTheme.titleLarge),
                                ]),
                          ),
                          6.ph,
                          RichText(
                            text: const TextSpan(
                                style: TextStyle(color: Colors.black),
                                text: ' You Have',
                                children: [
                                  TextSpan(
                                      text: '8 Task',
                                      style: TextStyle(color: Colors.blueAccent)),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.calendar_month)
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  CustomContainer(),
                  CustomContainer(),
                  CustomContainer(),
                ],
              ),
            ),
            16.ph,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Company tasks',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w400,
                      fontSize: 18),
                ),
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See More',
                      style: TextStyle(color: Colors.black),
                    )),
              ],
            ),
            16.ph,
            TabBar(
                unselectedLabelColor: Colors.black,
                splashBorderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                splashFactory: InkRipple.splashFactory,
                indicator: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                    color: Colors.blueAccent.withOpacity(.8)),
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
                ])
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(240);
}

import 'package:flutter/material.dart';
import 'package:task_mangment/core/routes/app_router.dart';
import 'package:task_mangment/core/routes/named_router.dart';
import 'package:task_mangment/utils/extentions/padding_extention.dart';

import '../../../../../shared_widgets/custom_circle_image.dart';

class TabBarViewTabs extends StatelessWidget with PreferredSizeWidget {
  const TabBarViewTabs(
      {Key? key,
      required this.userName,
      required this.taskNumber,
      required this.itemBuilder,
      required this.itemCount,
      required this.imageUrl})
      : super(key: key);

  final String userName, taskNumber;
  final Widget? Function(BuildContext, int) itemBuilder;
  final int itemCount;
  final String imageUrl;

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
                      radius: 30,
                      child: CustomCircleImage(url: imageUrl),
                    ),
                    8.pw,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RichText(
                            text: TextSpan(
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16),
                                text: 'Hi ,',
                                children: [
                                  TextSpan(
                                      text: userName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge),
                                ]),
                          ),
                          6.ph,
                          RichText(
                            text: TextSpan(
                                style: const TextStyle(color: Colors.black),
                                text: ' You Have',
                                children: [
                                  TextSpan(
                                      text: '$taskNumber Task',
                                      style: const TextStyle(
                                          color: Colors.blueAccent)),
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
            SizedBox(
              height: 100,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: itemCount,
                  itemBuilder: itemBuilder),
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
                    onPressed: () {
                      AppRouter.goTo(screenName: NamedRouter.companyTasks);
                    },
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

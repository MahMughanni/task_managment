import 'package:flutter/material.dart';
import 'package:task_mangment/core/routes/app_router.dart';
import 'package:task_mangment/core/routes/named_router.dart';
import 'package:task_mangment/utils/extentions/padding_extention.dart';

import '../../../../../shared_widgets/custom_circle_image.dart';

class CustomTabBarViewTabs extends StatelessWidget {
  const CustomTabBarViewTabs({
    Key? key,
    required this.userName,
    required this.taskNumber,
    required this.itemBuilder,
    required this.itemCount,
    required this.imageUrl,
    required this.userId,
  }) : super(key: key);

  final String userName, taskNumber, userId;
  final Widget? Function(BuildContext, int) itemBuilder;
  final int itemCount;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.ph,
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomCircleImage(
                        image: imageUrl,
                        width: 70,
                        height: 70,
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      AppRouter.goTo(
                          screenName: NamedRouter.calenderScreen,
                          arguments: userId);
                    },
                    icon: const Icon(
                      Icons.calendar_month_sharp,
                      size: 30,
                      color: Colors.black54,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 130,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: itemCount,
                  itemBuilder: itemBuilder),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Company tasks',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w800,
                      fontSize: 20),
                ),
                TextButton(
                    onPressed: () {
                      AppRouter.goTo(screenName: NamedRouter.companyTasks);
                    },
                    child: Text(
                      'see more',
                      style: TextStyle(
                          color: Colors.black.withOpacity(.7), fontSize: 13),
                    )),
              ],
            ),
            16.ph,
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 1,
                    blurRadius: 16,
                    color: Colors.grey.shade200,
                  )
                ],
              ),
              child: TabBar(
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
                      boxShadow: const [
                        BoxShadow(
                            spreadRadius: 1,
                            blurRadius: 10,
                            color: Colors.black12)
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
                  ]),
            )
          ],
        ),
      ),
    );
  }
}

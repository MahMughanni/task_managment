import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_mangment/core/routes/app_router.dart';
import 'package:task_mangment/core/routes/named_router.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 8).r,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            12.verticalSpace,
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4).r,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomCircleImage(
                        image: imageUrl,
                        width: 50.w,
                        height: 50.h,
                      ),
                      8.horizontalSpace,
                      Padding(
                        padding: const EdgeInsets.all(8.0).r,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15.sp),
                                  text: 'Hi ,',
                                  children: [
                                    TextSpan(
                                        text: userName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(fontSize: 13.sp)),
                                  ]),
                            ),
                            2.verticalSpace,
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12.sp),
                                text: ' You Have',
                                children: [
                                  TextSpan(
                                      text: '$taskNumber Task',
                                      style: TextStyle(
                                          fontSize: 12.sp,
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
                    icon: Icon(
                      Icons.calendar_month_sharp,
                      size: 20.r,
                      color: Colors.black54,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 90.h,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: itemCount,
                  itemBuilder: itemBuilder),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Company tasks',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w800,
                      fontSize: 18.sp),
                ),
                TextButton(
                    onPressed: () {
                      AppRouter.goTo(screenName: NamedRouter.companyTasks);
                    },
                    child: Text(
                      'see more',
                      style: TextStyle(
                          color: Colors.black.withOpacity(.7), fontSize: 12.sp),
                    )),
              ],
            ),
            4.verticalSpace,
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9).r,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 1,
                    blurRadius: 16.r,
                    color: Colors.grey.shade200,
                  )
                ],
              ),
              child: TabBar(
                labelStyle: TextStyle(fontSize: 14.sp),
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
                      text: 'Today' ,

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

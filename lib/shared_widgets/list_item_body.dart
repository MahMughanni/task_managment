import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_management/utils/app_constants.dart';
import 'package:task_management/utils/utils_config.dart';

import 'custom_circle_image.dart';

class ListViewItemBody extends StatelessWidget {
  const ListViewItemBody({
    Key? key,
    required this.taskTitle,
    required this.taskCategory,
    required this.startTime,
    required this.title,
    required this.url,
    required this.status,
    required this.userName,
    required this.assignedTo,
  }) : super(key: key);

  final String? taskTitle,
      taskCategory,
      startTime,
      title,
      url,
      status,
      userName,
      assignedTo;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8).r,
      height: ScreenUtil().setHeight(110),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: .1,
            blurStyle: BlurStyle.inner,
            offset: const Offset(-5, .1),
            color: Colors.blueAccent.withOpacity(.3),
          ),
          BoxShadow(
            blurRadius: 3,
            spreadRadius: .3,
            blurStyle: BlurStyle.normal,
            offset: const Offset(1, 2),
            color: Colors.grey.withOpacity(.3),
          ),
        ],
        borderRadius: BorderRadius.circular(10).r,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 8).r,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                4.verticalSpace,
                Text(
                  taskCategory!,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: AppConstFontWeight.medium,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: taskTitle,
                    style: TextStyle(
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 14.sp,
                      fontWeight: AppConstFontWeight.regular,
                    ),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
                RichText(
                  text: TextSpan(
                    text: UtilsConfig.formatDate(startTime.toString()),
                    style: TextStyle(
                      fontWeight: AppConstFontWeight.regular,
                      color: Colors.deepOrange,
                      fontSize: 11.sp,
                    ),
                    children: [
                      WidgetSpan(
                          child: status == 'completed'
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: SvgPicture.asset(
                                    SvgIconsConstManger.done,
                                    width: 15.r,
                                    height: 15.r,
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: SvgPicture.asset(
                                    SvgIconsConstManger.calender,
                                    width: 15.r,
                                    height: 15.r,
                                  ),
                                )),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
                RichText(
                  text: TextSpan(
                    text: status == 'completed'
                        ? 'completed by '
                        : assignedTo?.length == 0
                            ? 'Assigned Employee'
                            : 'Assigned To ${assignedTo}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.blueAccent, fontSize: 13.sp),
                    children: [
                      TextSpan(
                        text: status == 'completed'
                            ? userName!.isEmpty
                                ? '- - - - '
                                : userName
                            : '',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: const Color(0xff3AAF3C)),
                      )
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
                4.verticalSpace,
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).r,
              child: CustomCircleImage(
                image: url,
                width: 40.r,
                height: 40.r,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_management/utils/app_constants.dart';

class CardNotificationWidget extends StatelessWidget {
  const CardNotificationWidget({
    required this.time,
    required this.title,
    required this.subTitle,
    Key? key,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final String time;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ListTile(
      leading: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              height: 50.h,
              width: 50.w,
              decoration: BoxDecoration(
                color: ColorConstManger.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 3,
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 0.5)
                ],
              ),
              child: SvgPicture.asset(
                SvgIconsConstManger.location,
                height: 35.h,
                width: 38.w,
              )),
          CircleAvatar(
            radius: 9.r,
            backgroundColor: Colors.green,
          ),
        ],
      ),
      title: Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
      ),
      subtitle: Row(
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Text(
                subTitle,
                style: textTheme.bodyMedium!
                    .copyWith(color: ColorConstManger.titleTextFormFieldColor),
                overflow: TextOverflow.ellipsis,
              )),
          const Spacer(),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Text(
                time,
                style: textTheme.bodyMedium!
                    .copyWith(color: ColorConstManger.greyIconBorder),
                overflow: TextOverflow.ellipsis,
              ))
        ],
      ),
      trailing: CircleAvatar(
        backgroundColor: ColorConstManger.primaryBorder,
        radius: 5.r,
      ),
    );
  }
}

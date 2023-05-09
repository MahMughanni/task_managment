import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListViewItemBody extends StatelessWidget {
  const ShimmerListViewItemBody({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 8.h,
                      width: ScreenUtil().setWidth(160).w,
                      color: Colors.white,
                    ),
                  ),
                  8.verticalSpace,
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 8.h,
                        width: ScreenUtil().setWidth(140).w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  8.verticalSpace,
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 8.h,
                      width: ScreenUtil().setWidth(160).w,
                      color: Colors.white,
                    ),
                  ),
                  8.verticalSpace,
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 8.h,
                      width: ScreenUtil().setWidth(120).w,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: CircleAvatar(
                radius: 25.r,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

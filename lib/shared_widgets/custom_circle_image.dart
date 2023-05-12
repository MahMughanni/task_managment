import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_mangment/utils/app_constants.dart';

class CustomCircleImage extends StatelessWidget {
  final dynamic image;
  final double width;
  final double height;

  const CustomCircleImage({
    Key? key,
    required this.image,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.r,
      height: height.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[100],
      ),
      child: ClipOval(
        child: image is String
            ? Image.network(
                image,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return Image.asset(
                    ImageConstManger.logoImage,
                    fit: BoxFit.contain,
                    width: 25.r,
                    height: 25.r,
                  );
                },
                scale: 2,
              )
            : Image.file(
                image as File, // Cast image to a File
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

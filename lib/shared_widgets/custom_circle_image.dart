import 'dart:io';

import 'package:flutter/material.dart';

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
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
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
            return const Icon(
              Icons.no_accounts,
              color: Colors.red,
              size: 30,
            );
          },
        )
            : Image.file(
          image as File, // Cast image to a File
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_mangment/utils/extentions/padding_extention.dart';

import 'app_constants.dart';

class UtilsConfig {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBarMessage({required String message, required bool status}) {
    return scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning,
              color: Color(ColorConstManger.borderSnackBarFalse),
            ),
            16.pw,
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                    fontSize: 16,
                    color: Color(ColorConstManger.primaryTextColor)),
              ),
            ),
          ],
        ),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: BorderSide(
            color: status
                ? const Color(ColorConstManger.borderSnackBarTrue)
                : const Color(ColorConstManger.borderSnackBarFalse),
          ),
        ),
        elevation: 0,
        backgroundColor: status
            ? const Color(ColorConstManger.backGroundSnackBarTrue)
            : const Color(ColorConstManger.backGroundSnackBarFalse),
      ),
    );
  }

  static String formatTime(data) {
    DateTime createdDate = DateTime.parse(data);
    String formattedDate = DateFormat.MMMMEEEEd().format(createdDate);
    return formattedDate;
  }

}

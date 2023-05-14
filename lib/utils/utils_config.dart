import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_mangment/core/routes/app_router.dart';
import 'package:task_mangment/utils/extentions/padding_extention.dart';
import 'app_constants.dart';

class UtilsConfig {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

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

  static String formatDate(String dateString) {
    final List<String> months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final List<String> parts = dateString.split(' ');
    final String month = months
        .indexWhere((m) => m.toLowerCase() == parts[1].toLowerCase())
        .toString();
    final String day = parts[2].replaceAll(',', '');
    final String year = parts[3];

    final String formattedDate = '$day.${months[int.parse(month)]}.$year';
    return formattedDate;
  }

  static showSnakBar(String content, {bool Success = false}) {
    return AppRouter.snackBarKey.currentState?.showSnackBar(SnackBar(
      content: Text(
        content,
      ),
      backgroundColor:
          Success ? ColorConstManger.primaryColor : ColorConstManger.red,
      behavior: SnackBarBehavior.floating,
    ));
  }

  static void showFirebaseException(FirebaseException e) {
    String errorMessage;
    switch (e.code) {
      case 'invalid-email':
        errorMessage = 'The email address is not valid.';
        break;
      case 'user-not-found':
        errorMessage = 'The user with the provided email does not exist.';
        break;
      case 'wrong-password':
        errorMessage = 'The password is incorrect.';
        break;
      // Add more cases as needed
      default:
        errorMessage = e.message!;
    }
    showSnakBar(errorMessage, Success: false);
  }

  static void showBottomSheet(Widget widget) {
    showModalBottomSheet<dynamic>(
      backgroundColor: Colors.transparent,
      context: AppRouter.navigatorKey.currentContext!,
      builder: (context) {
        return Popover(
          child: widget,
        );
      },
    );
  }
}

class Popover extends StatelessWidget {
  const Popover({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(23.0), topRight: Radius.circular(23.0)),
      ),
      child: child!,
    );
  }
}

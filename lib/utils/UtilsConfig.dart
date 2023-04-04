import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
            Text(
              message,
              style: const TextStyle(
                  fontSize: 16,
                  color: Color(ColorConstManger.primaryTextColor)),
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
    String formattedDate = DateFormat.yMMMEd().format(createdDate);
    return formattedDate;
  }
// static showAlertDialog(BuildContext context, String title) {
//   AlertDialog alert = AlertDialog(
//     elevation: 5,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//     actionsAlignment: MainAxisAlignment.center,
//     icon: Align(
//       alignment: Alignment.topRight,
//       child: InkWell(
//         onTap: () {
//           AppRouter.back();
//         },
//         child: const Icon(
//           Icons.close,
//           size: 20,
//         ),
//       ),
//     ),
//     iconPadding: const EdgeInsets.only(right: 10, top: 10),
//     contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
//     content: Padding(
//       padding: const EdgeInsets.only(bottom: 15),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 16,
//           color: Color(AppColor.primaryTextColor),
//         ),
//       ),
//     ),
//     actions: [
//       ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             backgroundColor: const Color(AppColor.whiteTextButtonColor),
//             shape: RoundedRectangleBorder(
//               side: const BorderSide(
//                 color: Color(AppColor.borderColor),
//               ),
//               borderRadius: BorderRadius.circular(7),
//             ),
//           ),
//           onPressed: () => Navigator.pop(context, false),
//           child: const Text(
//             'No',
//             style: TextStyle(color: Color(AppColor.primaryTextColor)),
//           )),
//       ElevatedButton(
//         onPressed: () {
//           AppRouter.back();
//           UtilsConfig.showSnackBarMessage(
//               message: 'Bank account has been deleted.', status: true);
//           //  bank.removeItem(index);
//         },
//         style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(AppColor.whiteTextButtonColor),
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             shape: RoundedRectangleBorder(
//               side: const BorderSide(
//                 color: Color(AppColor.borderColor),
//               ),
//               borderRadius: BorderRadius.circular(7),
//             )),
//         child: const Text(
//           'Yes',
//           style: TextStyle(
//             color: Color(AppColor.primaryTextColor),
//           ),
//         ),
//       ),
//     ],
//   );
//
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }
}

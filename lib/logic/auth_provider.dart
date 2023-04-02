import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_mangment/utils/UtilsConfig.dart';

class AuthFireBase {
  static Future logIn(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      UtilsConfig.showSnackBarMessage(message: ' Login Success !', status: true);
    } on FirebaseAuthException catch (e) {
      // print('error MSG : $e');
      if (e.code == 'user-not-found') {
        UtilsConfig.showSnackBarMessage(
            message: 'No user found for that email.', status: false);
      } else if (e.code == 'wrong-password') {
        UtilsConfig.showSnackBarMessage(
            message: 'Wrong password provided for that user.', status: false);
      }
    }
  }



// static Future signIn(String email, String password) async {
//   try {
//     await FirebaseAuth.instance
//         .signInWithEmailAndPassword(email: email, password: password);
//     UtilsConfig.showSnackBarMessage(message: ' Login Success !', status: true);
//   } on FirebaseAuthException catch (e) {
//     // print('error MSG : $e');
//     if (e.code == 'user-not-found') {
//       UtilsConfig.showSnackBarMessage(
//           message: 'No user found for that email.', status: false);
//     } else if (e.code == 'wrong-password') {
//       UtilsConfig.showSnackBarMessage(
//           message: 'Wrong password provided for that user.', status: false);
//     }
//   }
// }
}

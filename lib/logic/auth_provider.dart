import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_mangment/utils/UtilsConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthFireBase {
  static Future logIn(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      UtilsConfig.showSnackBarMessage(
          message: ' Login Success !', status: true);
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

  static Future<void> createUserAccount(
      String email, String password, String username, String phone) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    print('frist step') ;
    try {
      print('create account') ;
      // Create user account with email and password
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print('create account2') ;

      // Add user information to FireStore
      String userId = userCredential.user!.uid;
      print('create account1 ') ;

      await firestore
          .collection('users')
          .doc(userId)
          .set({'username': username, 'phone': phone});

      print('User created successfully!');
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
}

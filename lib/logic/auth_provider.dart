import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_mangment/model/task_model.dart';
import 'package:task_mangment/utils/UtilsConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

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

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      String userId = userCredential.user!.uid;

      await firestore
          .collection('users')
          .doc(userId)
          .set({'username': username, 'phone': phone, 'role': 'user'});

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

  static Future<UserModel> getUserInfo() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final userData = await firestore.collection('users').doc(userId).get();
    final userName = userData.get('username');
    final role = userData.get('role');
    final phone = userData.get('phone');

    final userModel =
        UserModel(userName: userName, uId: userId, phone: phone, role: role);

    return userModel;
  }

  static Future<List<TaskModel>> getUserTasks({required String userId}) async {
    final tasks = <TaskModel>[];
    final querySnapshot = await FirebaseFirestore.instance
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    querySnapshot.docs.forEach((doc) {
      final data = doc.data();
      final task = TaskModel(
        id: doc.id,
        title: data['title'],
        description: data['description'],
        createdDate: data['createdDate'].toDate(),
        // userId: data['userId'],
        isCompleted: data['isCompleted'],
      );
      tasks.add(task);
    });

    print(tasks.first.toString());
    return tasks.toList();
  }
}

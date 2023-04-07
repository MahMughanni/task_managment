import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_mangment/model/task_model.dart';
import 'package:task_mangment/utils/UtilsConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class FireBaseController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

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
    final profileImageUrl = userData.get('profileImageUrl');

    final userModel = UserModel(
        userName: userName,
        uId: userId,
        phone: phone,
        role: role,
        profileImageUrl: profileImageUrl);
    return userModel;
  }

  static Future<List<TaskModel>> getUserTasks({required String userId}) async {
    final tasks = <TaskModel>[];
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final tasksCollection = userDoc.reference.collection('tasks');
    final querySnapshot = await tasksCollection.get();

    for (var doc in querySnapshot.docs) {
      final task = TaskModel.fromSnapshot(doc);
      tasks.add(task);
    }

    return tasks;
  }

  static Future<void> addTask({
    required String title,
    required String description,
    required String startTime,
    required String endTime,
    required String state,
    List<File>? imageFiles,
  }) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;

    List<String> imageUrls = [];
    for (File imageFile in imageFiles ?? []) {
      final Reference storageRef =
          FirebaseStorage.instance.ref().child('images/${user.uid}/$title');
      final UploadTask uploadTask = storageRef.putFile(imageFile);
      await uploadTask.whenComplete(() async {
        String imageUrl = await storageRef.getDownloadURL();
        imageUrls
            .add(imageUrl); // Add the download URL to the list of image URLs
      });
    }

    final task = TaskModel(
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      state: state,
      imageUrls: imageUrls,
    );

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .add(task.toMap());

    print('add success');
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_mangment/model/task_model.dart';
import 'package:task_mangment/utils/utils_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../model/user_model.dart';

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FireBaseController {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

      // print('User created successfully!');
    } on FirebaseAuthException catch (e) {
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
    final position = userData.get('position');

    final userModel = UserModel(
      userName: userName,
      uId: userId,
      phone: phone,
      role: role,
      profileImageUrl: profileImageUrl,
      position: position,
    );
    return userModel;
  }

  static Stream<List<TaskModel>> getUserTasksStream({required String userId}) {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    final tasksCollection = userDoc.collection('tasks');
    final snapshots =
        tasksCollection.orderBy('createdAt', descending: true).snapshots();
    return snapshots.map((querySnapshot) {
      final tasks = <TaskModel>[];
      for (var doc in querySnapshot.docs) {
        final task = TaskModel.fromSnapshot(doc);
        tasks.add(task);
      }
      return tasks;
    });
  }

  static Stream<List<TaskModel>> getTasksDetailsStream(
      {required String userId}) {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    final tasksCollection = userDoc.collection('tasks');
    final snapshots =
        tasksCollection.orderBy('createdAt', descending: true).snapshots();

    return snapshots.map((querySnapshot) {
      final tasks = <TaskModel>[];
      for (var doc in querySnapshot.docs) {
        final task = TaskModel.fromSnapshot(doc);
        tasks.add(task);
      }
      return tasks;
    });
  }

  static Future<void> addTask({
    required String title,
    required String description,
    required String startTime,
    required String endTime,
    required String state,
    List<File>? imageFiles,
  }) async {
    final FirebaseFirestore fireStore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;

    List<String> imageUrls = [];
    for (int i = 0; i < (imageFiles?.length ?? 0); i++) {
      final File imageFile = imageFiles![i];
      final String fileName =
          '$title-${const Uuid().v4()}.${imageFile.path.split('.').last}';
      final Reference storageRef =
          FirebaseStorage.instance.ref().child('images/${user.uid}/$fileName');
      final UploadTask uploadTask = storageRef.putFile(imageFile);
      await uploadTask.whenComplete(() async {
        String imageUrl = await storageRef.getDownloadURL();
        imageUrls.add(imageUrl);
      });
    }

    final task = TaskModel(
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      state: state,
      imageUrls: imageUrls,
      createdAt: Timestamp.now(),
    );

    await fireStore
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .add(task.toMap());

    // print('add success');
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_mangment/model/task_model.dart';
import 'package:task_mangment/utils/utils_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../model/user_model.dart';
import 'package:path/path.dart' as path;

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FireBaseController {
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
    final FirebaseFirestore fireStore = FirebaseFirestore.instance;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      String userId = userCredential.user!.uid;

      await fireStore.collection('users').doc(userId).set({
        'username': username,
        'phone': phone,
        'role': 'user',
        'profileImageUrl': '',
        'position': '',
      });
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

  // static Future<void> editUserInfo({
  //   required String userName,
  //   required String phone,
  //   required String position,
  //   File? newImage,
  // }) async {
  //   final userId = FirebaseAuth.instance.currentUser!.uid;
  //   final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  //
  //   if (newImage != null) {
  //     // Upload the new image to Firebase Storage
  //     final Reference storageRef = FirebaseStorage.instance
  //         .ref()
  //         .child('profileImageUrl')
  //         .child('$userId.jpg');
  //     await storageRef.putFile(newImage);
  //
  //     // Get the download URL of the new image
  //     final String imageUrl = await storageRef.getDownloadURL();
  //
  //     await fireStore.collection('users').doc(userId).update({
  //       'username': userName,
  //       'phone': phone,
  //       'position': position,
  //       'profileImageUrl': imageUrl,
  //     });
  //   } else {
  //     // Update the user's document in the Firestore collection without changing the image URL
  //     await fireStore.collection('users').doc(userId).update({
  //       'username': userName,
  //       'phone': phone,
  //       'position': position,
  //     });
  //   }
  // }
  static Future<void> editUserInfo({
    required String userName,
    required String phone,
    required String position,
    File? newImage,
  }) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final FirebaseFirestore fireStore = FirebaseFirestore.instance;

    // Update the user's profile data
    await fireStore.collection('users').doc(userId).update({
      'username': userName,
      'phone': phone,
      'position': position,
    });

    // If a new image was provided, upload it to Firebase Storage and update the user's profile picture URL
    if (newImage != null) {
      final imageUrl = await uploadProfileImage(userId, newImage);
      await fireStore.collection('users').doc(userId).update({
        'profileImageUrl': imageUrl,
      });
    }
  }

  static Future<void> editProfileImage(
    File? newImage,
  ) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final FirebaseFirestore fireStore = FirebaseFirestore.instance;
    if (newImage != null) {
      final imageUrl = await uploadProfileImage(userId, newImage);
      await fireStore.collection('users').doc(userId).update({
        'profileImageUrl': imageUrl,
      });
    }
  }

  static Future<String> uploadProfileImage(
      String userId, File imageFile) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final ref = storage.ref('users/$userId/${path.basename(imageFile.path)}');
    final metadata = SettableMetadata(
      contentType: 'image/${path.extension(imageFile.path).substring(1)}',
    );
    final uploadTask = ref.putFile(imageFile, metadata);
    final downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  static Future<UserModel> getUserInfo() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final FirebaseFirestore fireStore = FirebaseFirestore.instance;

    final userData = await fireStore.collection('users').doc(userId).get();
    final userName = userData.get('username');
    final role = userData.get('role');
    final phone = userData.get('phone');
    final profileImageUrl = userData.get('profileImageUrl');
    final position = userData.get('position');
    final email = FirebaseAuth.instance.currentUser!.email;
    final password =
        FirebaseAuth.instance.currentUser!.providerData[0].providerId ==
                'password'
            ? '********'
            : '';

    final userModel = UserModel(
      userName: userName,
      uId: userId,
      phone: phone,
      role: role,
      profileImageUrl: profileImageUrl,
      position: position,
      email: email!,
      password: password,
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

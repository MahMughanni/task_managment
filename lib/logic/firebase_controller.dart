import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_mangment/model/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../model/user_model.dart';
import 'package:path/path.dart' as path;

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FireBaseRepository {
  final user = FirebaseAuth.instance.currentUser!;

  static Future<List<DocumentSnapshot>> getAllUsers() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    return querySnapshot.docs;
  }

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

  static Stream<List<TaskModel>> getUserTasksByDateToCalender(
      {required String userId}) {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    final tasksCollection = userDoc.collection('tasks');
    return tasksCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
        .map((doc) => TaskModel.fromSnapshot(doc))
        .toList());
  }

  static Stream<List<TaskModel>> getUserTasksStream({required String userId}) {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    final tasksCollection = userDoc.collection('tasks');
    final snapshots = tasksCollection.orderBy('createdAt', descending: true).snapshots();
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

  }
}

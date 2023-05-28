import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_management/model/project_model.dart';
import 'package:task_management/model/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_management/model/user_model.dart';
import 'package:uuid/uuid.dart';

import 'package:path/path.dart' as path;

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FireBaseRepository {
  final user = FirebaseAuth.instance.currentUser!;

  Future<List<UserModel>> getAllUsers() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    return querySnapshot.docs
        .map((doc) => UserModel.fromSnapshot(doc))
        .toList();
  }

  static Future<void> updateTask(
      {required String userId,
      required String taskId,
      required String newState}) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    final taskDoc = userDoc.collection('tasks').doc(taskId);

    await taskDoc.update({'state': newState});
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

  static Future<UserModel> getUserInfo2({String? userId}) async {
    final id = FirebaseAuth.instance.currentUser!.uid;
    final FirebaseFirestore fireStore = FirebaseFirestore.instance;
    final userData =
        await fireStore.collection('users').doc(userId ?? id).get();
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

  static Stream<List<ProjectModel>> getProjects({required String userId}) {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    final tasksCollection = userDoc.collection('projects');
    final snapshots =
        tasksCollection.orderBy('createdAt', descending: true).snapshots();

    return snapshots.map((querySnapshot) {
      final projects = <ProjectModel>[];
      for (var doc in querySnapshot.docs) {
        final project = ProjectModel.fromSnapshot(doc);
        projects.add(project);
      }
      return projects;
    });
  }

  Future<List<TaskModel>> getTasksForUser(
      String userId, String userRole) async {
    final FirebaseFirestore fireStore = FirebaseFirestore.instance;

    Query query = fireStore.collection('tasks');

    if (userRole == 'admin') {
      // Retrieve all tasks for the admin user
    } else if (userRole == 'user') {
      // Retrieve tasks specific to the user
      query = query.where('userId', isEqualTo: userId);
    }

    final snapshot = await query.get();

    return snapshot.docs.map((doc) => TaskModel.fromSnapshot(doc)).toList();
  }

  Future<void> addTask({
    required String title,
    required String description,
    required String startTime,
    required String endTime,
    required String state,
    List<File>? imageFiles,
    required String userName,
    String? assignedTo,
  }) async {
    final FirebaseFirestore fireStore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;

    List<String> imageUrls = [];

    if (imageFiles != null && imageFiles.isNotEmpty) {
      for (int i = 0; i < imageFiles.length; i++) {
        final File imageFile = imageFiles[i];
        final String fileName =
            '$title-${const Uuid().v4()}.${imageFile.path.split('.').last}';
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('images/${user.uid}/$fileName');
        final UploadTask uploadTask = storageRef.putFile(imageFile);
        await uploadTask.whenComplete(() async {
          String imageUrl = await storageRef.getDownloadURL();
          imageUrls.add(imageUrl);
        });
      }
    }

    final task = TaskModel(
      id: '',
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      state: state,
      imageUrls: imageUrls,
      createdAt: Timestamp.now(),
      userName: userName,
      assignedTo: assignedTo ?? '',
    );

    final DocumentReference docRef = await fireStore
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .add(task.toMap());

    final String taskId = docRef.id;

    await docRef.update({'id': taskId});
  }

  Future<void> addTaskForUser({
    required String userId,
    required String title,
    required String description,
    required String startTime,
    required String endTime,
    required String state,
    List<File>? imageFiles,
    required String userName,
    required String assignedTo,
  }) async {
    final FirebaseFirestore fireStore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;

    List<String> imageUrls = [];

    if (imageFiles != null && imageFiles.isNotEmpty) {
      for (int i = 0; i < imageFiles.length; i++) {
        final File imageFile = imageFiles[i];
        final String fileName =
            '$title-${const Uuid().v4()}.${imageFile.path.split('.').last}';
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('images/$userId/$fileName'); // Use userId parameter
        final UploadTask uploadTask = storageRef.putFile(imageFile);
        await uploadTask.whenComplete(() async {
          String imageUrl = await storageRef.getDownloadURL();
          imageUrls.add(imageUrl);
        });
      }
    }

    final task = TaskModel(
      id: '',
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      state: state,
      imageUrls: imageUrls,
      createdAt: Timestamp.now(),
      userName: userName,
      assignedTo: assignedTo,
    );

    final DocumentReference docRef = await fireStore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .add(task.toMap());

    final String taskId = docRef.id;

    await docRef.update({'id': taskId});
  }

  Future<void> createProject({
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

    if (imageFiles != null && imageFiles.isNotEmpty) {
      for (int i = 0; i < imageFiles.length; i++) {
        final File imageFile = imageFiles[i];
        final String fileName =
            '$title-${const Uuid().v4()}.${imageFile.path.split('.').last}';
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('images/${user.uid}/$fileName');
        final UploadTask uploadProject = storageRef.putFile(imageFile);
        await uploadProject.whenComplete(() async {
          String imageUrl = await storageRef.getDownloadURL();
          imageUrls.add(imageUrl);
        });
      }
    }

    final project = ProjectModel(
      id: '',
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      state: state,
      imageUrls: imageUrls,
      createdAt: Timestamp.now(),
    );

    final DocumentReference docRef = await fireStore
        .collection('users')
        .doc(user.uid)
        .collection('projects')
        .add(project.toMap());

    final String projectId = docRef.id;

    await docRef.update({'id': projectId});
  }
}

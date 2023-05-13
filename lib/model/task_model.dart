import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String? id;
  final String title;
  final String description;
  final String startTime;
  final String endTime;
  String state;
  final List<String> imageUrls;
  final Timestamp createdAt;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.state,
    required this.imageUrls,
    required this.createdAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final imageUrls = List<String>.from(json['imageUrls'] ?? []);
    return TaskModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      state: json['state'] ?? '',
      imageUrls: imageUrls,
      createdAt: json['createdAt'] == null
          ? Timestamp.now()
          : Timestamp.fromDate(DateTime.parse(json['createdAt'])),
    );
  }

  factory TaskModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final imageUrls = List<String>.from(data['imageUrls'] ?? []);

    return TaskModel(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      state: data['state'] ?? '',
      imageUrls: imageUrls,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime,
      'endTime': endTime,
      'state': state,
      'imageUrls': imageUrls,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return 'TaskModel{ Id: $id, title: $title, description: $description, startTime: $startTime, endTime: $endTime, state: $state, imageUrls: $imageUrls}';
  }
}

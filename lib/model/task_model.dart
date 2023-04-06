import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String title;
  final String description;
  final String startTime;
  final String endTime;
  final String state;
  final String? imageUrl;
  final String? id;

  TaskModel({
    this.imageUrl,
    this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.state,
  });

  factory TaskModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return TaskModel(
      id: snapshot.id,
      title: data['title'],
      description: data['description'],
      startTime: data['startTime'],
      endTime: data['endTime'],
      state: data['state'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startTime': startTime,
      'endTime': endTime,
      'state': state,
    };
  }

  @override
  String toString() {
    return 'TaskModel{title: $title, description: $description, startTime: $startTime, endTime: $endTime, state: $state, id: $id}';
  }
}

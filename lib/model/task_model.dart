
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String title;
  final String description;
  final String startTime;
  final String endTime;
  final String state;
  final List<String> imageUrls;

  TaskModel({
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.state,
    required this.imageUrls,
  });

  factory TaskModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final imageUrls = List<String>.from(data['imageUrls'] ?? []);

    return TaskModel(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      state: data['state'] ?? '',
      imageUrls: imageUrls,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startTime': startTime,
      'endTime': endTime,
      'state': state,
      'imageUrls': imageUrls,
    };
  }

  @override
  String toString() {
    return 'TaskModel{title: $title, description: $description, startTime: $startTime, endTime: $endTime, state: $state, imageUrls: $imageUrls}';
  }
}

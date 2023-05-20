import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String? id;
  final String title;
  final String description;
  final String startTime;
  final String endTime;
  String state;
  final List<String> imageUrls;
  final Timestamp createdAt;

  ProjectModel({
    this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.state,
    required this.imageUrls,
    required this.createdAt,
  });

  factory ProjectModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final imageUrls = List<String>.from(data['imageUrls'] ?? []);

    return ProjectModel(
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

  ProjectModel copyWith({
    String? id,
    String? title,
    String? description,
    String? startTime,
    String? endTime,
    String? state,
    List<String>? imageUrls,
    Timestamp? createdAt,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      state: state ?? this.state,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
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
    return 'TaskModel{ Id: $id, title: $title, description: $description, startTime: $startTime, endTime: $endTime, state: $state, imageUrls: $imageUrls,}';
  }
}

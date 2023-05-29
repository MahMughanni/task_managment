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
  String userName;
  String? assignedTo;
  String? completedBy;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.state,
    required this.imageUrls,
    required this.createdAt,
    required this.userName,
    required this.assignedTo,
    required this.completedBy,
  });

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
      userName: data['username'] ?? '',
      assignedTo: data['assignedTo'] ?? ' ',
      completedBy: data['completedBy'] ??
          '', // Initialize the username as an empty string
    );
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? startTime,
    String? endTime,
    String? state,
    List<String>? imageUrls,
    Timestamp? createdAt,
    String? userName,
    String? assignedTo,
    String? completedBy,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      state: state ?? this.state,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      userName: userName ?? this.userName,
      assignedTo: assignedTo ?? this.assignedTo,
      completedBy: completedBy ?? this.completedBy,
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
      'username': userName,
      'assignedTo': assignedTo,
      'completedBy': completedBy,
    };
  }

  @override
  String toString() {
    return 'TaskModel{ Id: $id, title: $title, description: $description, startTime: $startTime, endTime: $endTime, state: $state, imageUrls: $imageUrls, userName: $userName}';
  }
}

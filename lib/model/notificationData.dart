import 'package:cloud_firestore/cloud_firestore.dart';


class NotificationData {
  final String title;
  final String id;
  final String description;
  final bool isLocalNotification;
  final DateTime createdAt;
  final bool isSeen;

  NotificationData({
    required this.title,
    required this.id,
    required this.description,
    required this.isLocalNotification,
    required this.createdAt,
    required this.isSeen,
  });

  factory NotificationData.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final createdAt =
    data['createdAt'] != null ? data['createdAt'].toDate() : DateTime.now();

    return NotificationData(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      isLocalNotification: data['isLocalNotification'] ?? false,
      createdAt: createdAt,
      isSeen: data['isSeen'] ?? false,
      id: data['id'] ?? '0',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "isLocalNotification": isLocalNotification,
      "createdAt": createdAt,
      "isSeen": isSeen,
      "id": id,
    };
  }
}
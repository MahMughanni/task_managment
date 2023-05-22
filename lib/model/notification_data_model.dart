class MyNotificationModel {
  final int? id;
  final String title;
  final String body;
  final DateTime timestamp;

  MyNotificationModel({
    this.id,
    required this.title,
    required this.body,
    required this.timestamp,
  });

  factory MyNotificationModel.fromJson(Map<String, dynamic> json) {
    return MyNotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, String?> toJson() {
    return {
      'id': id.toString(), // Convert 'id' to String
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

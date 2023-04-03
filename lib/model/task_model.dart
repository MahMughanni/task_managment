class TaskModel {
  final String title;
  final String description;
  final String startTime;
  final String endTime;
  final String state;

  TaskModel({
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.state,
  });

  factory TaskModel.fromSnapshot(Map<String, dynamic> data) {
    return TaskModel(
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
}

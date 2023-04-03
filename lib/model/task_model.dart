class TaskModel {
  String id;
  String title;
  String description;
  DateTime createdDate;
  bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdDate,
    required this.isCompleted,
  });

  @override
  String toString() {
    return 'TaskModel{id: $id, title: $title, description: $description, createdDate: $createdDate, isCompleted: $isCompleted}';
  }
}

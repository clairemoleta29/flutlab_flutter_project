class Task {
  final int? id;
  final String title;
  final int isCompleted; // 0 for false, 1 for true

  Task({this.id, required this.title, this.isCompleted = 0});

  // Convert a Task into a Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  // Extract a Task from a Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      isCompleted: map['isCompleted'],
    );
  }
}

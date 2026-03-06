import 'package:uuid/uuid.dart';

class Task {
  final String id;
  final String title;
  final bool isDone;

  Task({String? id, required this.title, this.isDone = false})
    : id = id ?? const Uuid().v4();

  Task copyWith({String? title, bool? isDone}) {
    return Task(
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      id: id,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'isDone': isDone};

  factory Task.fromJson(Map<String, dynamic> json) =>
      Task(id: json['id'], title: json['title'], isDone: json['isDone']);
}

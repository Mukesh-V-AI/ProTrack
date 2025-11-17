import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 3)
class Todo {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final bool isCompleted;

  @HiveField(3)
  final DateTime? dueDate;

  @HiveField(4)
  final bool isRepeating;

  @HiveField(5)
  final String? repeatPattern; // 'daily', 'weekly', 'monthly'

  @HiveField(6)
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.dueDate,
    this.isRepeating = false,
    this.repeatPattern,
    required this.createdAt,
  });

  Todo copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? dueDate,
    bool? isRepeating,
    String? repeatPattern,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      isRepeating: isRepeating ?? this.isRepeating,
      repeatPattern: repeatPattern ?? this.repeatPattern,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'dueDate': dueDate?.toIso8601String(),
      'isRepeating': isRepeating,
      'repeatPattern': repeatPattern,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      isRepeating: json['isRepeating'] as bool? ?? false,
      repeatPattern: json['repeatPattern'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}



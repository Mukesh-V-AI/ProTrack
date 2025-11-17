import 'package:hive/hive.dart';

part 'assignment.g.dart';

@HiveType(typeId: 1)
class Assignment {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String subject;

  @HiveField(3)
  final DateTime dueDate;

  @HiveField(4)
  final String? description;

  @HiveField(5)
  final bool isCompleted;

  @HiveField(6)
  final DateTime createdAt;

  Assignment({
    required this.id,
    required this.name,
    required this.subject,
    required this.dueDate,
    this.description,
    this.isCompleted = false,
    required this.createdAt,
  });

  Assignment copyWith({
    String? id,
    String? name,
    String? subject,
    DateTime? dueDate,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Assignment(
      id: id ?? this.id,
      name: name ?? this.name,
      subject: subject ?? this.subject,
      dueDate: dueDate ?? this.dueDate,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subject': subject,
      'dueDate': dueDate.toIso8601String(),
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] as String,
      name: json['name'] as String,
      subject: json['subject'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      description: json['description'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}



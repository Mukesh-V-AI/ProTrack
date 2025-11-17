import 'package:hive/hive.dart';

part 'exam.g.dart';

@HiveType(typeId: 2)
class Exam {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DateTime dateTime;

  @HiveField(3)
  final String? notes;

  @HiveField(4)
  final DateTime createdAt;

  Exam({
    required this.id,
    required this.name,
    required this.dateTime,
    this.notes,
    required this.createdAt,
  });

  Exam copyWith({
    String? id,
    String? name,
    DateTime? dateTime,
    String? notes,
    DateTime? createdAt,
  }) {
    return Exam(
      id: id ?? this.id,
      name: name ?? this.name,
      dateTime: dateTime ?? this.dateTime,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dateTime': dateTime.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'] as String,
      name: json['name'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}



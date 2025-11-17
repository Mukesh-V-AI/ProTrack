import 'package:hive/hive.dart';

part 'leetcode_entry.g.dart';

@HiveType(typeId: 0)
class LeetCodeEntry {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final int problemsSolved;

  @HiveField(3)
  final String? notes;

  LeetCodeEntry({
    required this.id,
    required this.date,
    required this.problemsSolved,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'problemsSolved': problemsSolved,
      'notes': notes,
    };
  }

  factory LeetCodeEntry.fromJson(Map<String, dynamic> json) {
    return LeetCodeEntry(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      problemsSolved: json['problemsSolved'] as int,
      notes: json['notes'] as String?,
    );
  }
}



class WeeklySummary {
  final DateTime weekStart;
  final DateTime weekEnd;
  final int leetCodeProblemsSolved;
  final int assignmentsCompleted;
  final int tasksCompleted;
  final int notesAdded;
  final double productivityScore;

  WeeklySummary({
    required this.weekStart,
    required this.weekEnd,
    required this.leetCodeProblemsSolved,
    required this.assignmentsCompleted,
    required this.tasksCompleted,
    required this.notesAdded,
    required this.productivityScore,
  });

  Map<String, dynamic> toJson() {
    return {
      'weekStart': weekStart.toIso8601String(),
      'weekEnd': weekEnd.toIso8601String(),
      'leetCodeProblemsSolved': leetCodeProblemsSolved,
      'assignmentsCompleted': assignmentsCompleted,
      'tasksCompleted': tasksCompleted,
      'notesAdded': notesAdded,
      'productivityScore': productivityScore,
    };
  }

  factory WeeklySummary.fromJson(Map<String, dynamic> json) {
    return WeeklySummary(
      weekStart: DateTime.parse(json['weekStart'] as String),
      weekEnd: DateTime.parse(json['weekEnd'] as String),
      leetCodeProblemsSolved: json['leetCodeProblemsSolved'] as int,
      assignmentsCompleted: json['assignmentsCompleted'] as int,
      tasksCompleted: json['tasksCompleted'] as int,
      notesAdded: json['notesAdded'] as int,
      productivityScore: (json['productivityScore'] as num).toDouble(),
    );
  }
}



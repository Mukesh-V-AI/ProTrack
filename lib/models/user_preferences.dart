import 'package:hive/hive.dart';

part 'user_preferences.g.dart';

@HiveType(typeId: 5)
class UserPreferences {
  @HiveField(0)
  final int dailyLeetCodeGoal;

  @HiveField(1)
  final bool weeklyGoal; // true for weekly, false for daily

  @HiveField(2)
  final bool leetCodeRemindersEnabled;

  @HiveField(3)
  final DateTime? lastWeeklySummary;

  UserPreferences({
    this.dailyLeetCodeGoal = 2,
    this.weeklyGoal = false,
    this.leetCodeRemindersEnabled = true,
    this.lastWeeklySummary,
  });

  UserPreferences copyWith({
    int? dailyLeetCodeGoal,
    bool? weeklyGoal,
    bool? leetCodeRemindersEnabled,
    DateTime? lastWeeklySummary,
  }) {
    return UserPreferences(
      dailyLeetCodeGoal: dailyLeetCodeGoal ?? this.dailyLeetCodeGoal,
      weeklyGoal: weeklyGoal ?? this.weeklyGoal,
      leetCodeRemindersEnabled:
          leetCodeRemindersEnabled ?? this.leetCodeRemindersEnabled,
      lastWeeklySummary: lastWeeklySummary ?? this.lastWeeklySummary,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dailyLeetCodeGoal': dailyLeetCodeGoal,
      'weeklyGoal': weeklyGoal,
      'leetCodeRemindersEnabled': leetCodeRemindersEnabled,
      'lastWeeklySummary': lastWeeklySummary?.toIso8601String(),
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      dailyLeetCodeGoal: json['dailyLeetCodeGoal'] as int? ?? 2,
      weeklyGoal: json['weeklyGoal'] as bool? ?? false,
      leetCodeRemindersEnabled:
          json['leetCodeRemindersEnabled'] as bool? ?? true,
      lastWeeklySummary: json['lastWeeklySummary'] != null
          ? DateTime.parse(json['lastWeeklySummary'] as String)
          : null,
    );
  }
}


